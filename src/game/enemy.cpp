#include "enemy.h"

#include "tmxparser/tmxobject.h"

#include "constants.h"
#include "sfmlmath.h"

#include <iostream>


void Enemy::parse(TmxObject* object)
{
   mId = object->mId;
   mName = object->mName;

   auto w = static_cast<int32_t>(object->mWidth);
   auto h = static_cast<int32_t>(object->mHeight);

   if (w == 0)
   {
      w = PIXELS_PER_TILE;
   }

   if (h == 0)
   {
      h = PIXELS_PER_TILE;
   }

   const auto left = static_cast<int32_t>(object->mX);
   const auto top = static_cast<int32_t>(object->mY);

   mRect.top = top;
   mRect.left = left;
   mRect.width = w;
   mRect.height = h;

   mVertices[0].x = left;
   mVertices[0].y = top;

   mVertices[1].x = left;
   mVertices[1].y = top  + h;

   mVertices[2].x = left + w;
   mVertices[2].y = top  + h;

   mVertices[3].x = left + w;
   mVertices[3].y = top;
}


void Enemy::addChain(const std::vector<std::vector<b2Vec2>>& chains)
{
   bool assigned = false;

   // a player rect can only overlap with a single chain.
   // this function finds this chain and assigns it.
   for (const auto& chain : chains)
   {
      for (auto i0 = 0u; i0 < chain.size(); i0++)
      {
         sf::Vector2i v0{
            static_cast<int32_t>(chain[i0].x * PPM),
            static_cast<int32_t>(chain[i0].y * PPM)
         };

         // check if rect contains point, then we have a match
         if (mRect.contains(v0))
         {
            mChain = chain;
            assigned = true;
            break;
         }
         else
         {
            // otherwise check if the line intersects with the rect
            const auto i1 = (i0 == chain.size() -1) ? 0u : (i0 + 1);

            sf::Vector2i v1{
               static_cast<int32_t>(chain[i1].x * PPM),
               static_cast<int32_t>(chain[i1].y * PPM)
            };

            const auto intersectsLeft   = SfmlMath::intersect(v0, v1, mVertices[0], mVertices[1]);
            const auto intersectsBottom = SfmlMath::intersect(v0, v1, mVertices[1], mVertices[2]);
            const auto intersectsRight  = SfmlMath::intersect(v0, v1, mVertices[2], mVertices[3]);
            const auto intersectsTop    = SfmlMath::intersect(v0, v1, mVertices[3], mVertices[0]);

            if (
                  intersectsLeft.has_value()
               || intersectsBottom.has_value()
               || intersectsRight.has_value()
               || intersectsTop.has_value()
            )
            {
               // std::cout << "assigned chain to: " << mId << std::endl;
               mChain = chain;
               assigned = true;
               break;
            }
         }
      }
   }

   if (!assigned)
   {
      std::cerr << "object " << mId << " (" << mName << ") has invalid chain" << std::endl;
   }
   else
   {
      // std::transform(
      //    mChain.begin(),
      //    mChain.end(),
      //    std::back_inserter(mPixelChain),
      //    [](const auto& v) -> sf::Vector2f { return {v.x * PPM, v.y * PPM}; }
      // );

      for (const auto& v : mChain)
      {
         mPixelChain.push_back(static_cast<int32_t>(v.x * PPM));
         mPixelChain.push_back(static_cast<int32_t>(v.y * PPM));
      }
   }
}

