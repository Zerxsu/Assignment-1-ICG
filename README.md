# Assignment 1 ICG
This game is finished and will be uploaded on my itch as a finalized game.

I will start this readme by explaining in depth the key components that make of this project, how it was added, why it was added, and how it fits the scene.
There will also be a READMEmp4, which will demonstrate me visually showcasing mechanics/concepts of exactly how certain things function within the project.

**Contents (each topic talked about for each level (Volcano & Crystal Dungeon))**
- Game Idea
- Shaders
- Textures
- VFX
- Final Notes

**Game Idea**

This game is a parkour escape game with 2 main levels with them being escaping a volcano and a crystal dungeon. Each level has a different colour pallete which makes them unique, as well as different types of devices that can harm you. There are specific objects that can take a life away from your player, and there are also checkpoint through the course that the player can respawn at if they we're to lose a life. Different shaders are in play for each level to give them their unique appearances and general feel.


**VOLCANO LEVEL CONTENTS**

**Shaders**

The volcano level was the start of the project and utilized basic shaders with ambient, specular and diffuse lighting. Every object that the player interacts with has 3 materials assigned to it, and when the player presses the numbers on their keyboard 1, 2 or 3, it switches to the respective shader with the lighting attached to it. This idea was specifically added as it was a requirement for the assignment. The shaders are split up into 3 categories, a set of shaders with an emission/normal map added, a set of shaders with rimlighting/normal map added, and last a set of shaders with just a normal map added. 

   **- Emission/Normal Map Shader:** The purpose of this shader was to add a glow with the help of post processing to give specific blocks a red glow which could signify lava. In a volcano theres lava everywhere so as the player is trying to escape, the brightest emission from the shader causes the lava to glow a specific color to indicate to the player that it is a deadly object that shouldn't be touched. It suits the scene because it falls in line with the aesthetic of being within a volcano. The normal map is then added to apply a lava texture to the object so they dont seem flat and it sells the vibe it is trying to be portrayed as.

   **- Rimlighting/Normal Map Shader:** The purpose of this shader was to add a cool effect to the checkpoints in which the players interact with to showcase that this is an interactable item. The color is also protrayed as gree so it seems more friendly. However I originally used a rectangle as the base for the shader and it caused the rim highlights to be difficult to observe. This was then changed to a more spherical shape to showcase the shader effects more clearly and it became a success. The rimlighting brings the overal checkpoint objects together by highlighting them as friendly interactable objects the player can safely touch to save their respawn point.

   **- Normal Map Shader:** This shader is extremely simple and I created it to apply a texture to the platforms so they dont look flat and unappealing. There's nothing particularly special about this shader and it was done just for very basic aesthetic reasons. 

**Textures**

The volcano used very minimal textures as at the time I didn't fully understand how to create a shader with an albedo, metallic, roughness, height, and normal map slot in which I prefab to make models and texture them using substance painter. However the giant volcano the player is in was created in blender, uv unwrapped, textured in substance painter and imported into Unity. It used Unity's standard shader as it was very acessible at the time. The rest of the objects had stretched textures and a simple normal map was applied to every object that I wanted to have a base texture for.

**VFX**

   **- Particles:** The main big VFX that was present in the volcano was the particles implemented with Unity's particle system. They we're created to simulate rising embers as you are in a heated environment which is on fire. They had a color gradation from deep red to bright yellow and they got higher and smaller within the volcano to showcase them "fading away". I ended up getting the exact effect I wanted and heard good criticism about the implementation so no further tweaking was necessary for part 2 of this assignment.

   **- Color Grading:** The color grading was implemented by taking and LUT into an image editing software along with a screen shot of my base game. I put visual effect on the image and it was also applied to the LUT. A script was made to hold the LUT and it was assigned to a material then placed onto the main camera to take effect. What I created for the volcano scene was a slight firey red/orang tint to furthermore, extract the feel of being a hot enivironment. I added this because  the base colors in the scene weren't appealing enough and I wanted to change the entire feel.

**Final notes**

All in all the volcano level is protrayed perfectly as a firey heated environment with the urge to escape while avoiding lava blocks, and interacting with checkpoints to prevent progression lost. Out of all the lighting models, I found the simple diffuse shader to be the most appealing as it made the scene have depth in the case of lighting, and things didn't feel flat. It gave the scene good shadows and color with in my opinions completed the exact look I was going for. If I we're to do something differently it would be adding a water shader effect to lava to showcase it moving around while it's rising to give off a "bubbly" heat effect.


**CRYSTAL DUNGEON LEVEL CONTENTS**

**Shaders**

The crystal level had the same keyboard toggle to trigger the exact same lighting type as the previous volcano level with the biggest difference being that the textures was massively impacted by each lighting type. This is the case because I created a juiced shader which handled all the texture maps that could be exported from substance painter for the models. Below are the explanations for all the additional/new shaders.

   **- Upgraded Basic Shader:** I created this shader since I was very comfortable with using the Unity standard shader when it came to exporting texture with substance painter. It already had all the spots for the texture and paramaters to adjust the strengths of them. I challeneged myself to recreated the standard shader but with the 3 different lighting types, ambient, specular, and diffuse lighting. I had great success and was able to get 3 very unique variations of the model that had the materials attached to them. I did this because I wanted to understand how the standard unity shader handles uv unwrapping and created such versatility with it. I ended up adding not just more texture map slots, but also an emission toggle, strength and color so I could use the shader with any materials and have more options. This was mainly added to be showcased on the crystals as this is called the "crystal" dungeon. I wanted them to feel lit, and to make the environment feel alive than flat.

   **- Upgraded Rimlighting Shader:** The rimlighting shader I originally had in the volcano wasn't being showcased properly because I was using blocks instead of an object with a more organic form and after swapping the object associated with the shader, the effects we're night and day. However I wanted to amplify is even more to make the checkpoints even more noticable. So I added an outline to the shader in which I could set the color and thickness to make the checkpoints even more noticable. I did this because I wanted to genuinely make it look like something you had to touch, since a problem with this game is if you pass a checkpoint and die later on, you will lose that checkpoint and respawn much further into the game. With the outline added, I think the goal of this shader is complete and makes the checkpoints feel more interactable.

   **- Water Shader:** I know I wanted to add water so I created a water texture and made a shader which could simulate waves. I have adjustable parameters in the shader in which I can adjust the wave color, frequency, speed, and amplitude of the water. I added these to give me more creative freedom to get the exact kind of waves I was looking for and I ended up finding something that looks nice. I don't like the idea of having a "flat" looking game, so wherever I could add some kind of effect to make it feel better than that I shall do.

**Textures**

I explained some of the textures above but I will also go a bit more in depth here and also talk about the models. The entire tileset was created in blender and took 8+ hours of straight modeling to create. I then had to mark seams, and create UV's for each model, assign materials, then texture each one in substance painter. Heres a list of all models in my game that went through this process and utilized the Upgraded Basic Shader to get their textures in game:
   - BaseCrystalRoom
   - BrickWall
   - Chains
   - Crystal
   - Door
   - FloorEnd
   - Floor/Roof
   - Pillar
   - PitFloor
   - PitWall
   - Platform
   - Platform/Roof/Corner
   - RockPlatform
   - ShorterFloorEnd
   - Spike
   - Stair
   - SwingingAxe
   - WallSlant
Every single one of these models has 5 texture maps, Normal map, Albedo, Metallic, Roughness, and Height. I used a custom script which helps combine the metallic and roughness shader into one, and each texture for each models was assigned to 3 materials with each material having a different shader which them being ambient, specular, or diffuse based. 
To simply put it, each model had 3 materials, each material had a shader with 4 texture slots, there are 3 shaders for 3 lighting models. Visually this will be easier to understand in the video report but it's difficult to express in words.

**VFX**

I have 2 semi new VFX's and a brand new VFX when compared to the volcano level.
   **- Particles:** I recreated the particles so they behave like fireflies. This gives a vibe that you're in a mystical environment with unique life but still in a area not for the faint of heart. I also created a new unity particle shader with an emission added, and created a particle texture in photoshop. With these changes I was able to make spherical particles that glow to simulate fireflies. I also adjust their movement pathing so they move randomly with no set pathing. This simulates it being alive and going for the exact effect that I want.

   **- Color Grading:** Unlike the volcano level needing to feel hot to simulate being in a heated environment. There's no noticable temperature for the crystal dungeon, but since there's bright blue fire flies, and blue crystals, I wanted to change the color grading to the feel of the environment, and to do that i gave the camera a slight blue tint, and increased saturations to make the colors pop out more. The effect was exactly what I was hoping for and it perfectly showcases they your in a "cool" enivronment.

   **- Water Shader:** I don't know if this is considered a visual effect but I think it is since it's visually being adjusted on the screen. I already went in detail about how this functions works in the shader tab above. However like I said, I dont want things to feel "flat" so I gave the water a wave effect to make the environment feel more lively than static.

**Final Notes**

I am so incredibly happy with this project and I will be posting it on my itch page for other people to play. Since I worked completely alone all the ideas and planning was my own but that doesn't mean it was easy. I worked tireslly like 10+ hour on multiple days to make complete this assignment. I love the vibe I created with the crystal dungeon and will most likely update the game to make the volcano level feel a bit more lively when compared to the crystal level.














