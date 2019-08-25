#include "menuscreen.h"

#include "image/psd.h"
#include "game/gamecontrollerintegration.h"

#include <iostream>


void MenuScreen::update(const sf::Time& /*dt*/)
{
}


void MenuScreen::draw(sf::RenderTarget& window, sf::RenderStates states)
{
   for (auto& layer : mLayerStack)
   {
      if (layer->mVisible)
      {
         layer->draw(window, states);
      }
   }
}


const std::string &MenuScreen::getFilename()
{
   return mFilename;
}


void MenuScreen::setFilename(const std::string& filename)
{
   mFilename = filename;
}


void MenuScreen::load()
{
   PSD psd;
   psd.setColorFormat(PSD::ColorFormat::ABGR);
   psd.load(mFilename);

   // std::cout << mFilename << std::endl;

   for (const auto& layer : psd.getLayers())
   {
      // skip groups
      if (layer.getSectionDivider() != PSD::Layer::SectionDivider::None)
      {
         continue;
      }

      // std::cout << layer.getName() << std::endl;

      auto tmp = std::make_shared<Layer>();
      // tmp.mVisible = layer.isVisible();

      auto texture = std::make_shared<sf::Texture>();
      auto sprite = std::make_shared<sf::Sprite>();

      texture->create(layer.getWidth(), layer.getHeight());
      texture->update(reinterpret_cast<const sf::Uint8*>(layer.getImage().getData().data()));

      sprite->setTexture(*texture, true);
      sprite->setPosition(static_cast<float>(layer.getLeft()), static_cast<float>(layer.getTop()));

      tmp->mTexture = texture;
      tmp->mSprite = sprite;

      // std::cout << "    " << layer.getName() << std::endl;

      mLayerStack.push_back(tmp);
      mLayers[layer.getName()] = tmp;
   }

   // std::cout << "---------" << std::endl;

   loadingFinished();
}


void MenuScreen::loadingFinished()
{

}


void MenuScreen::keyboardKeyPressed(sf::Keyboard::Key /*key*/)
{

}


void MenuScreen::keyboardKeyReleased(sf::Keyboard::Key /*key*/)
{

}

bool MenuScreen::isControllerUsed() const
{
   auto gji = GameControllerIntegration::getInstance(0);
   if (gji == nullptr)
   {
      return false;
   }

   return true;
}

