#include "messagebox.h"

#include "game/gameconfiguration.h"
#include "game/gamecontrollerintegration.h"
#include "image/psd.h"
#include "joystick/gamecontroller.h"

#include <iostream>
#include <math.h>

std::deque<MessageBox> MessageBox::mQueue;
bool MessageBox::sInitialized = false;

std::vector<std::shared_ptr<Layer>> MessageBox::sLayerStack;
std::map<std::string, std::shared_ptr<Layer>> MessageBox::sLayers;
sf::Font MessageBox::sFont;
sf::Text MessageBox::sText;


MessageBox::MessageBox()
{
   initializeLayers();
   initializeControllerCallbacks();
}


MessageBox::MessageBox(MessageBox::Type type, const std::string& message, MessageBox::MessageBoxCallback cb, int32_t buttons)
 : mType(type),
   mMessage(message),
   mCallback(cb),
   mButtons(buttons)
{
   initializeLayers();
   initializeControllerCallbacks();
}


MessageBox::~MessageBox()
{
   auto gci = GameControllerIntegration::getInstance(0);
   if (gci)
   {
      gci->getController()->removeButtonPressedCallback(SDL_CONTROLLER_BUTTON_A, mButtonCallbackA);
      gci->getController()->removeButtonPressedCallback(SDL_CONTROLLER_BUTTON_B, mButtonCallbackB);
   }
}


bool MessageBox::empty()
{
   return mQueue.empty();
}


bool MessageBox::keyboardKeyPressed(sf::Keyboard::Key key)
{
   if (empty())
   {
      return false;
   }

   auto& box = mQueue.front();

   if (box.mDrawn)
   {
      MessageBox::Button button = MessageBox::Button::Invalid;

      // yay
      if (key == sf::Keyboard::Return)
      {
         if (box.mButtons & static_cast<int32_t>(Button::Yes))
         {
            button = Button::Yes;
         }
         else if (box.mButtons & static_cast<int32_t>(Button::Ok))
         {
            button = Button::Ok;
         }
      }

      // nay
      if (key == sf::Keyboard::Escape)
      {
         if (box.mButtons & static_cast<int32_t>(Button::No))
         {
            button = Button::No;
         }
         else if (box.mButtons & static_cast<int32_t>(Button::Cancel))
         {
            button = Button::Cancel;
         }
      }

      if (button != MessageBox::Button::Invalid)
      {
         box.mCallback(button);
         mQueue.pop_front();
      }
   }

   return true;
}


void MessageBox::initializeLayers()
{
   if (!sInitialized)
   {
      PSD psd;
      psd.setColorFormat(PSD::ColorFormat::ABGR);
      psd.load("data/game/messagebox.psd");

      if (!sFont.loadFromFile("data/fonts/deceptum.ttf"))
      {
         std::cerr << "font load fuckup" << std::endl;
      }

      // load layers
      for (const auto& layer : psd.getLayers())
      {
         // skip groups
         if (layer.getSectionDivider() != PSD::Layer::SectionDivider::None)
         {
            continue;
         }

         auto tmp = std::make_shared<Layer>();

         auto texture = std::make_shared<sf::Texture>();
         auto sprite = std::make_shared<sf::Sprite>();

         texture->create(layer.getWidth(), layer.getHeight());
         texture->update(reinterpret_cast<const sf::Uint8*>(layer.getImage().getData().data()));

         sprite->setTexture(*texture, true);
         sprite->setPosition(static_cast<float>(layer.getLeft()), static_cast<float>(layer.getTop()));

         tmp->mTexture = texture;
         tmp->mSprite = sprite;

         sLayerStack.push_back(tmp);
         sLayers[layer.getName()] = tmp;
      }

      sInitialized = true;
   }
}


void MessageBox::initializeControllerCallbacks()
{
   auto gci = GameControllerIntegration::getInstance(0);
   if (gci)
   {
      mButtonCallbackA = [](){keyboardKeyPressed(sf::Keyboard::Return);};
      mButtonCallbackB = [](){keyboardKeyPressed(sf::Keyboard::Escape);};

      gci->getController()->addButtonPressedCallback(SDL_CONTROLLER_BUTTON_A, mButtonCallbackA);
      gci->getController()->addButtonPressedCallback(SDL_CONTROLLER_BUTTON_B, mButtonCallbackB);
   }
}


void MessageBox::draw(sf::RenderTarget& window, sf::RenderStates states)
{
   if (empty())
   {
      return;
   }

   auto& box = mQueue.front();
   box.mDrawn = true;

   const auto xbox = (GameControllerIntegration::getInstance(0) != nullptr);
   const auto buttons = box.mButtons;

   sLayers["msg-copyssYN"]->mVisible = false;
   sLayers["msg-overwritessYN"]->mVisible = false;
   sLayers["msg-deletessYN"]->mVisible = false;
   sLayers["msg-defaultsYN"]->mVisible = false;
   sLayers["msg-quitYN"]->mVisible = false;

   sLayers["yes_xbox_1"]->mVisible = xbox && buttons & static_cast<int32_t>(Button::Yes);
   sLayers["no_xbox_1"]->mVisible = xbox && buttons & static_cast<int32_t>(Button::No);

   sLayers["yes_pc_1"]->mVisible = !xbox && buttons & static_cast<int32_t>(Button::Yes);
   sLayers["no_pc_1"]->mVisible = !xbox && buttons & static_cast<int32_t>(Button::No);

   // set up an ortho view with screen dimensions
   sf::View pixelOrtho(
      sf::FloatRect(
         0.0f,
         0.0f,
         static_cast<float>(GameConfiguration::getInstance().mViewWidth),
         static_cast<float>(GameConfiguration::getInstance().mViewHeight)
      )
   );
   window.setView(pixelOrtho);

   for (auto& layer : sLayerStack)
   {
      if (layer->mVisible)
      {
         layer->draw(window, states);
      }
   }

   sText.setScale(0.25f, 0.25f);
   sText.setFont(sFont);
   sText.setCharacterSize(48);
   sText.setString(box.mMessage);
   sText.setFillColor(sf::Color{232, 219, 243});

   // box top/left: 137 x 94
   // box dimensions: 202 x 71
   // box left: 143
   const auto rect = sText.getGlobalBounds();
   const auto left = 143;
   const auto x = left + (202 - rect.width) * 0.5f;

   sText.setPosition(floor(x), 112);
   window.draw(sText, states);
}


void MessageBox::messageBox(Type type, const std::string& message, MessageBoxCallback callback, int32_t buttons)
{
   mQueue.emplace_back(type, message, callback, buttons);
}


void MessageBox::info(const std::string& message, MessageBoxCallback callback, int32_t buttons)
{
   messageBox(MessageBox::Type::Info, message, callback, buttons);
}


void MessageBox::question(const std::string& message, MessageBox::MessageBoxCallback callback, int32_t buttons)
{
   messageBox(MessageBox::Type::Info, message, callback, buttons);
}


// https://www.sfml-dev.org/tutorials/2.5/graphics-text.php


