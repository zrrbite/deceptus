TEMPLATE = app
TARGET = jumpnrun
CONFIG_APP_NAME = jumpnrun

DEFINES += _USE_MATH_DEFINES
DEFINES += USE_GL

CONFIG += console
CONFIG += c++17
CONFIG -= debug_and_release

OBJECTS_DIR = .obj

# get rid of all qt
CONFIG -= QT
CONFIG -= app_bundle
QT -= gui
QT -= core
LIBS -= -lQtGui
LIBS -= -lQtCore

# code requires c++17
win32 {
   # visual studio wants 'latest' for C++17 support
   QMAKE_CXXFLAGS += -std:c++latest

   # link debug symbols
   QMAKE_CFLAGS_RELEASE += -Zi
   QMAKE_CXXFLAGS_RELEASE += -Zi
   QMAKE_LFLAGS_RELEASE += /DEBUG /OPT:REF
}

linux {
    QMAKE_CXXFLAGS += -std=c++17
    QMAKE_CXXFLAGS += -lc++fs
}


win32 {
    LIBS += -Llib64
    LIBS += -LSDL\lib\x64
    LIBS += -lSDL2
    LIBS += -lglu32
    LIBS += -lopengl32
    LIBS += -llua53

    # sfml
    LIBS += -Lsfml\lib
    CONFIG(release, debug|release) {
      LIBS += -lsfml-audio
      LIBS += -lsfml-graphics
      LIBS += -lsfml-network
      LIBS += -lsfml-window
      LIBS += -lsfml-system
    } else {
      LIBS += -lsfml-audio-d
      LIBS += -lsfml-graphics-d
      LIBS += -lsfml-network-d
      LIBS += -lsfml-window-d
      LIBS += -lsfml-system-d
    }
}


linux {
   # apt install:
   # libsfml-dev libsdl2-dev liblua5.3-dev
   LIBS += -lstdc++fs
   LIBS += -llua5.3
   LIBS += -lSDL2
   LIBS += -lGL
   LIBS += -lsfml-audio
   LIBS += -lsfml-graphics
   LIBS += -lsfml-network
   LIBS += -lsfml-window
   LIBS += -lsfml-system
}


#sfml
INCLUDEPATH += sfml/include
DEPENDPATH += sfml/include


INCLUDEPATH += .
INCLUDEPATH += src


SOURCES += \
   src/main.cpp \
    src/game/debugdraw.cpp \
    src/game/globalclock.cpp \
    src/game/game.cpp \
    src/game/player.cpp \
    src/game/level.cpp \
    src/tmxparser/tmxanimation.cpp \
    src/tmxparser/tmxelement.cpp \
    src/tmxparser/tmxframe.cpp \
    src/tmxparser/tmximage.cpp \
    src/tmxparser/tmxlayer.cpp \
    src/tmxparser/tmxparser.cpp \
    src/tmxparser/tmxtile.cpp \
    src/tmxparser/tmxtileset.cpp \
    src/game/tilemap.cpp \
    src/tmxparser/tmxobjectgroup.cpp \
    src/tmxparser/tmxobject.cpp \
    src/tmxparser/tmxpolyline.cpp \
    src/game/gamecontactlistener.cpp \
    src/game/bullet.cpp \
    src/poly2tri/common/shapes.cc \
    src/poly2tri/sweep/advancing_front.cc \
    src/poly2tri/sweep/cdt.cc \
    src/poly2tri/sweep/sweep.cc \
    src/poly2tri/sweep/sweep_context.cc \
    src/game/weapon.cpp \
    src/game/audio.cpp \
    src/game/movingplatform.cpp \
    src/tmxparser/tmxproperty.cpp \
    src/tmxparser/tmxproperties.cpp \
    src/game/luainterface.cpp \
    src/game/door.cpp \
    src/game/portal.cpp \
    src/game/gameconfiguration.cpp \
    src/game/playerconfiguration.cpp \
    src/game/worldconfiguration.cpp \
    src/tinyxml2/tinyxml2.cpp \
    src/game/sfmlmath.cpp \
    src/tmxparser/tmxtools.cpp \
    src/game/gamenode.cpp \
    src/game/luanode.cpp \
    src/game/fixturenode.cpp \
    src/game/gamecontrollerintegration.cpp \
    src/joystick/gamecontrollerinfo.cpp \
    src/joystick/gamecontroller.cpp \
    src/game/extramanager.cpp \
    src/game/extra.cpp \
    src/game/extrahealth.cpp \
    src/game/extratable.cpp \
    src/game/extraitem.cpp \
    src/game/physicsconfiguration.cpp \
    src/game/timer.cpp \
    src/game/bullethitanimation.cpp \
    src/game/animation.cpp \
    src/game/infolayer.cpp \
    src/game/bitmapfont.cpp \
    src/game/leveldescription.cpp \
    src/game/squaremarcher.cpp \
    src/game/weaponsystem.cpp \
    src/game/weaponitem.cpp \
    src/effects/raycastlight.cpp \
    src/game/pathinterpolation.cpp \
    src/game/extraskill.cpp \
    src/effects/staticlight.cpp \
    src/game/fbm.cpp \
    src/tmxparser/tmximagelayer.cpp \
    src/game/ambientocclusion.cpp \
    src/game/imagelayer.cpp \
    src/game/actioncontrollermap.cpp \
    src/game/inventorylayer.cpp \
    src/game/inventoryitem.cpp \
    src/game/displaymode.cpp \
    src/game/gamestate.cpp \
    src/game/animationpool.cpp \
    src/game/bumper.cpp \
    src/game/jumpplatform.cpp \
    src/game/bouncer.cpp \
    src/game/conveyorbelt.cpp \
    src/game/progresssettings.cpp \
    src/game/levels.cpp \
    src/tmxparser/tmxpolygon.cpp \
    src/tmxparser/tmxchunk.cpp \
    src/game/meshtools.cpp \
    src/menus/menu.cpp \
    src/menus/menuscreen.cpp \
    src/menus/menuscreenmain.cpp \
    src/menus/menuscreenoptions.cpp \
    src/menus/menuscreencontrols.cpp \
    src/menus/menuscreenvideo.cpp \
    src/menus/menuscreenaudio.cpp \
    src/menus/menuscreengame.cpp \
    src/menus/menuscreenachievements.cpp \
    src/menus/menuscreencredits.cpp \
    src/image/layer.cpp \
    src/image/image.cpp \
    src/image/psd.cpp \
    src/image/tga.cpp \
    src/game/messagebox.cpp \
    src/game/animationsettings.cpp


# add box2d

HEADERS += \
    src/game/constants.h \
    src/game/globalclock.h \
    src/game/bulletplayer.h \
    src/game/game.h \
    src/game/player.h \
    src/game/level.h \
    src/tmxparser/tmxanimation.h \
    src/tmxparser/tmxelement.h \
    src/tmxparser/tmxframe.h \
    src/tmxparser/tmximage.h \
    src/tmxparser/tmxlayer.h \
    src/tmxparser/tmxparser.h \
    src/tmxparser/tmxtile.h \
    src/tmxparser/tmxtileset.h \
    src/game/tilemap.h \
    src/tmxparser/tmxobjectgroup.h \
    src/tmxparser/tmxobject.h \
    src/tmxparser/tmxpolyline.h \
    src/game/gamecontactlistener.h \
    src/game/bullet.h \
    src/game/debugdraw.h \
    src/poly2tri/poly2tri.h \
    src/poly2tri/common/shapes.h \
    src/poly2tri/common/utils.h \
    src/poly2tri/sweep/advancing_front.h \
    src/poly2tri/sweep/cdt.h \
    src/poly2tri/sweep/sweep.h \
    src/poly2tri/sweep/sweep_context.h \
    src/game/weapon.h \
    src/game/audio.h \
    src/game/movingplatform.h \
    src/tmxparser/tmxproperty.h \
    src/tmxparser/tmxproperties.h \
    src/game/luainterface.h \
    src/game/door.h \
    src/game/portal.h \
    src/game/gameconfiguration.h \
    src/game/playerconfiguration.h \
    src/game/worldconfiguration.h \
    src/tinyxml2/tinyxml2.h \
    src/game/sfmlmath.h \
    src/tmxparser/tmxtools.h \
    src/json/json.hpp \
    src/game/luaconstants.h \
    src/game/gamenode.h \
    src/game/luanode.h \
    src/game/fixturenode.h \
    src/effects/blur.h \
    src/effects/effect.h \
    src/effects/pixelate.h \
    src/game/gamecontrollerintegration.h \
    src/joystick/gamecontrollerinfo.h \
    src/joystick/gamecontrollerballvector.h \
    src/joystick/gamecontroller.h \
    src/game/extramanager.h \
    src/game/extra.h \
    src/game/extrahealth.h \
    src/game/extratable.h \
    src/game/extraitem.h \
    src/game/physicsconfiguration.h \
    src/game/timer.h \
    src/game/bullethitanimation.h \
    src/game/animation.h \
    src/game/infolayer.h \
    src/game/bitmapfont.h \
    src/game/leveldescription.h \
    src/game/squaremarcher.h \
    src/game/weaponsystem.h \
    src/game/weaponitem.h \
    src/effects/raycastlight.h \
    src/game/pathinterpolation.h \
    src/game/extraskill.h \
    src/effects/staticlight.h \
    src/game/fbm.h \
    src/tmxparser/tmximagelayer.h \
    src/game/ambientocclusion.h \
    src/game/imagelayer.h \
    src/game/actioncontrollermap.h \
    src/game/inventorylayer.h \
    src/game/inventoryitem.h \
    src/game/displaymode.h \
    src/game/gamestate.h \
    src/game/animationpool.h \
    src/game/bumper.h \
    src/game/jumpplatform.h \
    src/game/bouncer.h \
    src/game/conveyorbelt.h \
    src/game/progresssettings.h \
    src/game/levels.h \
    src/tmxparser/tmxpolygon.h \
    src/tmxparser/tmxchunk.h \
    src/game/meshtools.h \
    src/menus/menu.h \
    src/menus/menuscreen.h \
    src/menus/menuscreenmain.h \
    src/menus/menuscreenoptions.h \
    src/menus/menuscreencontrols.h \
    src/menus/menuscreenvideo.h \
    src/menus/menuscreenaudio.h \
    src/menus/menuscreengame.h \
    src/menus/menuscreenachievements.h \
    src/menus/menuscreencredits.h \
    src/image/layer.h \
    src/image/image.h \
    src/image/psd.h \
    src/image/tga.h \
    src/game/messagebox.h \
    src/game/animationsettings.h


SOURCES += \
    src/Box2D/Collision/Shapes/b2ChainShape.cpp \
    src/Box2D/Collision/Shapes/b2CircleShape.cpp \
    src/Box2D/Collision/Shapes/b2EdgeShape.cpp \
    src/Box2D/Collision/Shapes/b2PolygonShape.cpp \
    src/Box2D/Common/b2BlockAllocator.cpp \
    src/Box2D/Common/b2Draw.cpp \
    src/Box2D/Common/b2Math.cpp \
    src/Box2D/Common/b2Settings.cpp \
    src/Box2D/Common/b2StackAllocator.cpp \
    src/Box2D/Common/b2Timer.cpp \
    src/Box2D/Collision/b2BroadPhase.cpp \
    src/Box2D/Collision/b2CollideCircle.cpp \
    src/Box2D/Collision/b2CollideEdge.cpp \
    src/Box2D/Collision/b2CollidePolygon.cpp \
    src/Box2D/Collision/b2Collision.cpp \
    src/Box2D/Collision/b2Distance.cpp \
    src/Box2D/Collision/b2DynamicTree.cpp \
    src/Box2D/Collision/b2TimeOfImpact.cpp \
    src/Box2D/Dynamics/b2Body.cpp \
    src/Box2D/Dynamics/b2ContactManager.cpp \
    src/Box2D/Dynamics/b2Fixture.cpp \
    src/Box2D/Dynamics/b2Island.cpp \
    src/Box2D/Dynamics/b2World.cpp \
    src/Box2D/Dynamics/b2WorldCallbacks.cpp \
    src/Box2D/Rope/b2Rope.cpp \
    src/Box2D/Dynamics/Joints/b2DistanceJoint.cpp \
    src/Box2D/Dynamics/Joints/b2FrictionJoint.cpp \
    src/Box2D/Dynamics/Joints/b2GearJoint.cpp \
    src/Box2D/Dynamics/Joints/b2Joint.cpp \
    src/Box2D/Dynamics/Joints/b2MotorJoint.cpp \
    src/Box2D/Dynamics/Joints/b2MouseJoint.cpp \
    src/Box2D/Dynamics/Joints/b2PrismaticJoint.cpp \
    src/Box2D/Dynamics/Joints/b2PulleyJoint.cpp \
    src/Box2D/Dynamics/Joints/b2RevoluteJoint.cpp \
    src/Box2D/Dynamics/Joints/b2RopeJoint.cpp \
    src/Box2D/Dynamics/Joints/b2WeldJoint.cpp \
    src/Box2D/Dynamics/Joints/b2WheelJoint.cpp \
    src/Box2D/Dynamics/Contacts/b2ChainAndCircleContact.cpp \
    src/Box2D/Dynamics/Contacts/b2ChainAndPolygonContact.cpp \
    src/Box2D/Dynamics/Contacts/b2CircleContact.cpp \
    src/Box2D/Dynamics/Contacts/b2Contact.cpp \
    src/Box2D/Dynamics/Contacts/b2ContactSolver.cpp \
    src/Box2D/Dynamics/Contacts/b2EdgeAndCircleContact.cpp \
    src/Box2D/Dynamics/Contacts/b2EdgeAndPolygonContact.cpp \
    src/Box2D/Dynamics/Contacts/b2PolygonAndCircleContact.cpp \
    src/Box2D/Dynamics/Contacts/b2PolygonContact.cpp

HEADERS += \
    src/Box2D/Collision/Shapes/b2ChainShape.h \
    src/Box2D/Collision/Shapes/b2CircleShape.h \
    src/Box2D/Collision/Shapes/b2EdgeShape.h \
    src/Box2D/Collision/Shapes/b2PolygonShape.h \
    src/Box2D/Collision/Shapes/b2Shape.h \
    src/Box2D/Box2D.h \
    src/Box2D/Common/b2BlockAllocator.h \
    src/Box2D/Common/b2Draw.h \
    src/Box2D/Common/b2GrowableStack.h \
    src/Box2D/Common/b2Math.h \
    src/Box2D/Common/b2Settings.h \
    src/Box2D/Common/b2StackAllocator.h \
    src/Box2D/Common/b2Timer.h \
    src/Box2D/Collision/b2BroadPhase.h \
    src/Box2D/Collision/b2Collision.h \
    src/Box2D/Collision/b2Distance.h \
    src/Box2D/Collision/b2DynamicTree.h \
    src/Box2D/Collision/b2TimeOfImpact.h \
    src/Box2D/Dynamics/b2Body.h \
    src/Box2D/Dynamics/b2ContactManager.h \
    src/Box2D/Dynamics/b2Fixture.h \
    src/Box2D/Dynamics/b2Island.h \
    src/Box2D/Dynamics/b2TimeStep.h \
    src/Box2D/Dynamics/b2World.h \
    src/Box2D/Dynamics/b2WorldCallbacks.h \
    src/Box2D/Rope/b2Rope.h \
    src/Box2D/Dynamics/Joints/b2DistanceJoint.h \
    src/Box2D/Dynamics/Joints/b2FrictionJoint.h \
    src/Box2D/Dynamics/Joints/b2GearJoint.h \
    src/Box2D/Dynamics/Joints/b2Joint.h \
    src/Box2D/Dynamics/Joints/b2MotorJoint.h \
    src/Box2D/Dynamics/Joints/b2MouseJoint.h \
    src/Box2D/Dynamics/Joints/b2PrismaticJoint.h \
    src/Box2D/Dynamics/Joints/b2PulleyJoint.h \
    src/Box2D/Dynamics/Joints/b2RevoluteJoint.h \
    src/Box2D/Dynamics/Joints/b2RopeJoint.h \
    src/Box2D/Dynamics/Joints/b2WeldJoint.h \
    src/Box2D/Dynamics/Joints/b2WheelJoint.h \
    src/Box2D/Dynamics/Contacts/b2ChainAndCircleContact.h \
    src/Box2D/Dynamics/Contacts/b2ChainAndPolygonContact.h \
    src/Box2D/Dynamics/Contacts/b2CircleContact.h \
    src/Box2D/Dynamics/Contacts/b2Contact.h \
    src/Box2D/Dynamics/Contacts/b2ContactSolver.h \
    src/Box2D/Dynamics/Contacts/b2EdgeAndCircleContact.h \
    src/Box2D/Dynamics/Contacts/b2EdgeAndPolygonContact.h \
    src/Box2D/Dynamics/Contacts/b2PolygonAndCircleContact.h \
    src/Box2D/Dynamics/Contacts/b2PolygonContact.h

OTHER_FILES += \
    data/shaders/parallax_frag.glsl \
    data/shaders/parallax_vert.glsl \
    data/shaders/bumpmap_frag.glsl \
    data/shaders/bumpmap_vert.glsl

DISTFILES += \
    data/level.tmx \
    data/scripts/enemies/dumb.lua \
    data/config/game.json \
    data/config/physics.json \
    data/scripts/enemies/blob.lua \
    data/shaders/raycast.frag \
    data/shaders/raycast.vert \
    data/scripts/enemies/cannon.lua \
    data/shaders/water.frag \
    data/scripts/enemies/landmine.lua \
    data/scripts/enemies/constants.lua \
    data/scripts/enemies/helpers.lua \
    data/scripts/enemies/vectorial2.lua \
    data/config/levels.json \
    data/sprites/animations.json

