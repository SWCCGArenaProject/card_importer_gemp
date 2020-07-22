# card_importer_gemp

This code is really bad, I wrote it in objective-c as quickly as I could way back when I started this project and never cleaned it up.

The goal of this is to read the gemp server source code and derive Unity compatible card assets from it.  
Even though gemp generally gives the client all the information it needs to display the game, I find it 
nice to let the client have some knowledge of what the cards are and what things mean.  This lets me
do stuff like treat rare cards differently in the UI, or render higher quality card text, stuff like that.

There is also a bunch of code in here to process the scanning project's images.  Those are incredibly high-resolution card scans
published on the forums.  I have local backups of all of those, it's about 15gb of texture data lol.  So this code
processes that to extract only the image portion which can then be blended with templates I made to display agreement-friendly, but 
high resolution cards in game.  The playground uses that rendering model, while the gemp arena client is currently using the .gif
format that gemp uses.  

Anyway if you want to use this let me know and I can help you figure it out.
