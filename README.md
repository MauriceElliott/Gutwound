# Gutwound

A survival game for Playdate.

Gutwound is a survival game, that asks the question, how would you fair surviving in a towerblock during the apocalypse, while bleeding out from a Gutwound, and trying to get to the top to ascend to the afterlife before you are consumed.

The gameplay will go like this, you will start on a randomly generated but distinct floor. You will be bleeding out from a wound you sustained before the start of the game, the wound is in your gut, meaning you have time to live, and even longer if you get treatment. At the top of the tower is ascention, if you can arrive there before dying, you have a chance as ascending to the afterlife. To get to the top, you will search the tower, find healing, food, water, clothes, protective items and medicine, as well as an assortment of other odds and ends.

## Kowloon
#### General
Each floor will have its own selection of item containers, you will search through to find the items you need to survive, different floors will have their own distinct pools to pull from but they will generally share where appropriate. i.e. You will find painkillers, food, water, medical supplies etc on every floor. Each floor transition will be acompanied with some flavour text. I'll be the only major world building/story in the game.

#### Casper
The game will take place over 4 levels, the first is a normal level, nothing super special happening there apart from a standard post apocalyptic apartment block, there will be some locked doors, and items to help open them, but this is mostly the set up floor which will decide on how the rest of your run is going to go. You will usually know by the end of this floor if you'll have an easy time on the next and by extension the one after. On this floor a main corridor will run through, allowing you to pick and choose how many rooms you choose to explore.

#### Melchior
The second level has lots of missing walls, exposing the floor to the elements outside. This floor is extremely cold, if the player has not found warm clothes or does not quickly find them or a place to warm up they will not survive the floor. Warm clothing will always spawn somewhere on the floor, but never in the same location. There will also be fire pits in some rooms where you can use some of your items to create a fire and warm up. This floor will also have a central corridor, as an easy way to breaze through if you are confident you have the resources to survive Balthasar and Adam.

#### Balthasar
The third has high radiation, it is made up of labs where research must have been conducted, the experiments are long gone but the radioactive isotopes live on, you must find radiation protection to survive the floor, you should have found some of it on the second floor. Radiation protection will always spawn somewhere on the floor as well in case you have not found it yet.

#### Adam
The fourth floor you will confront your own sanity, the dark sections of the map outside of the rooms will show grotesque aparitions. Pools of blood will start to collect on the floor, and then your vision will start to diminish. This floor is the shortest and features a sharp deceleration on all stat reductions - while it feels like the scariest floor, you are least likely to die here. The biggest danger is the player losing their sense of direction and motion. The real challenge is to make it to the end of the 3rd floor with enough life force to make it across this dreadful place.

## Gameplay elements
#### Crank
The crank will act as the healing screen, while inventory management will need to go on within the confines of the main game, the actual healing and use of items will be from this screen. You will also use the crank for different actions, i.e. to pour dissenfectant, to bandage, to sew.

#### Survival
##### Core stats
- **Main health**
Your main health is generally affected by everything, any other single stat can drain it, but it usually takes a culmination of neglect and bad luck to depleat your main health reserves.
- **Wound Health**
The health of your wound, walking affects it, sprinting also, over time and in cold and radiactive air it will take increased damage. Covering it, treating it and taking your time will reduce the multiplier drastically, but it will always be a few drastic moves away from death.
- **Delirium**
Delirium is like Main Health, it will increased based on the values of other stats, the more depleted you are the faster delirium will grow. There will be a few places on the map to reduce this like nicely decorated rooms, music players, nice food if you can find it.
- **Temperature**
If you run, you will get hot, if you wear too many thick clothes while by a fire you will get hot, if you are not wearing enough thick clothes you will get cold. Heat increases exhaustion and will cause higher thirst. Coldness will slow your movement and slowly kill you via your main health pool.
- **Exhaustion**
Exhaustion is tiredness, you will need to sleep to resolve this debuff. While tired you will walk slower and your vision will become blury. You will start passing out and each time you wake a certain level of damage will have been done to your survival stats.
- **Pain**
Pain is a mainline stat, you will need to find painkillers to manage it, as well as other medical items to reduce the inflamation and treat the wound. Alcohol as well. If your pain gets to high and stays that way it will negatively affect your Delirium.
- **Hunger**
Having high hunger will increase your exhaustion, it is also one of your main sources of healing as well as sitting by the fire, and can also improve you delirium and other related levels.
- **Thirst**
This is self explanitory, easiest one to manage, just something extra to keep an eye on. Hopefully you're able to find enough to drink as having high thirst will slowly deplete your main health.

Whenever you move you lose a small amount of health. This minor drain encourages thorough exploration and looting rather than rushing through. There will be more than enough healing items to offset this loss with proper scavenging.

## Roguelike elemenets
#### Map RNG
The floors will have a specific "Biome" which I think is the easiest way to decribe how they'll be split up. Each major room will be hand created, where as each set of room configurations will be randomized based on the type of the central room. The corridor for Casper and Melchior will be randomized as well to create that feeling of uneaze and cobbled together nature of kowloon.

The tilesize I am currently set on is 48x48, but that is yet to be fully defined due to the last test of 12x12 using reduced scale.
Art style and movement will be loosely based on racheteer.

For sound I would like to use a synthesizer, possibly an analogue synth, we will see about getting one. I also really love the idea of just include ambient type music, similar to the sad soft cold playlists nobody produces.

## Code Structure
For the code, I want to make sure that I can properly structure the game so that extension is straight forward, without having to do too much in terms of rewrites, however rewrites are inevitable, so the other way we need to manage this is making the rewrites easier.

For this we will use the core principal of data vs manipulator, i.e. I will use classes and structs for data and objects, with functions that are separated into libraries depending on the objects they are responsible for manipulating.

Then we will also use a scene based state structure where we will have a central scene manager that has responsibility for floor/level vs menu/healing menu/game progress etc. This will give us enough structure for the size of game we are aiming for and will help to manage state.

## Note on protective suit
Should have to start with, but can upgrade/repair to add capabilities like cold protection, toxic/radiation protection, etc, use items you find on the floors.


## Todo list

1. Animate character
	1. [x] Work out how to create animations in Asperite
	2. [ ] Animate walk cycle down
	3. [x] Code up animation in engine
	4. [ ] Create workflow
	5. [ ] Animate walk cycle left
	6. [ ] “” up
	7. [x] “” idle down
	8. [ ] “” idle left
2. Create map pipeline
	1. [ ] Create way to generate rooms with collision baked in use aseprite
	2. [ ] Create way to display and tile those on the screen
3. Create collision interactions
	1. [ ]  create way to define player collision
	2. [ ]  Create way for player to see they have colided with something, maybe a minor push back animation or something
	3. [ ]  Consider blocking and none blocking furniture
	4. [ ]  X/y axis for when you do or don’t interact with furniture i.e. you should be able to walk behind and in front of furniture depending on you and its y position.
4. Create ways to define the layers, colission flags etc
