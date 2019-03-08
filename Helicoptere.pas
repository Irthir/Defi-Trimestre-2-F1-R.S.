program Helicoptere;
{$UNITPATH \SDL2}
{$APPTYPE GUI} //Pour fermer la console lors du lancement.

//BUT : Faire un programme utilisant SDL2 animant une image à l'aide d'un tileset.
//ENTREE : 	Mouvement de la souris pour déplacer l'hélicoptère.
//			La touche "Echap" pour quitter le programme.
//SORTIE : L'hélicoptère animé suivant la souris, et la fin du programme lorsque "Echap" est pressé.

uses SDL2, SDL2_image;

CONST
LARGEURIMAGEHELICO=128;
NBSPRITEHELICO=5;
HAUTEURIMAGEHELICO=55;

var
sdlWindow1 : PSDL_Window;
sdlRenderer : PSDL_Renderer;
sdlEvent: PSDL_Event;
sdlRect1 : PSDL_Rect;
sdlTexture1: PSDL_Texture;
sdlSurface1: PSDL_Surface;
spriteheli: TSDL_Rect;
sourisheli: TSDL_Rect;
finhelico: Boolean;

//BUT : Créer une fenêtre.
//ENTREE : Rien.
//SORTIE : Une fenêtre.
procedure Initialisation ();
	begin
		  //Initialisation.
		if SDL_Init( SDL_INIT_VIDEO ) < 0 then HALT;

		  //Création de la fenêtre
		sdlWindow1 := SDL_CreateWindow( 'Helicoptere', 50, 50, 500, 500, SDL_WINDOW_SHOWN );
		if sdlWindow1 = nil then HALT;

		sdlRenderer := SDL_CreateRenderer( sdlWindow1, -1, 0 );
		if sdlRenderer = nil then HALT;
	end;

//BUT : Dessiner un rectangle en SDL.
//ENTREE : Rien.
//SORTIE : Le rectangle dessiné pendant une seconde.
procedure RectangleDessin ();
	BEGIN
		  //Changement du fond d'écran pour du jaune citron moche.
		SDL_SetRenderDrawColor( sdlRenderer, 223, 251, 0, 0);
		SDL_RenderClear( sdlRenderer );
		SDL_RenderPresent ( sdlRenderer );
		SDL_Delay( 1000 );

		  //Apparition du rectangle bleu foncé.
		new( sdlRect1 );	
		sdlRect1^.x := 260; sdlRect1^.y := 10; sdlRect1^.w := 230; sdlRect1^.h := 230;
		SDL_SetRenderDrawColor( sdlRenderer, 0, 50, 130, 220 );
		SDL_RenderDrawRect( sdlRenderer, sdlRect1 );
		SDL_RenderPresent( sdlRenderer );
		SDL_Delay( 1000 );
	END;

//BUT : Afficher un BitMap.
//ENTREE : Rien.
//SORTIE : Le BitMap pendant deux secondes.
procedure AfficherBitMap();
	BEGIN
		  //On crée une surface à partir d'un bmp.
		sdlSurface1 := SDL_LoadBMP('AssetsF1_F2\rider.bmp');
		if sdlSurface1 = nil then
			Halt;

		  //On crée une texture à partir d'une surface.
		sdlTexture1 := SDL_CreateTextureFromSurface(sdlRenderer, sdlSurface1);
		if sdlTexture1 = nil then
			Halt;

		  //On interprète la texture.
		if SDL_RenderCopy(sdlRenderer, sdlTexture1, nil, nil) <> 0 then
			Halt;

		  //On affiche la texture pendant 2 secondes.
		SDL_RenderPresent(sdlRenderer);
		SDL_Delay(2000);
	END;

//BUT : Afficher une image.
//ENTREE : Rien.
//SORTIE : L'image pendant deux secondes.
procedure AfficherImage();
	BEGIN
		  //Changement du fond d'écran pour du noir.
		SDL_SetRenderDrawColor( sdlRenderer, 0, 0, 0, 0 );
		SDL_RenderClear( sdlRenderer );
		SDL_RenderPresent ( sdlRenderer );
		SDL_Delay( 500 );


		  //On charge une image.
		sdlTexture1 := IMG_LoadTexture( sdlRenderer, 'AssetsF1_F2\drill.jpg' );
		if sdlTexture1 = nil then HALT;
	  	SDL_RenderCopy( sdlRenderer, sdlTexture1, nil, nil );
	  	SDL_RenderPresent (sdlRenderer);
	  	SDL_Delay( 2000 );
	END;

//BUT : Afficher un png à l'écran et l'animer.
//ENTREE : 	Les mouvements de la souris pour déplacer l'hélicoptère.
//			Echap pour fermer le programme.
//SORTIE : L'hélicoptère animé suivant la souris, et la fin du programme lorsqu'échap est pressé.
procedure HelicopterAnimation();
	BEGIN
		//Changement du fond d'écran pour du noir.
		SDL_RenderClear( sdlRenderer );
		SDL_RenderPresent ( sdlRenderer );
		SDL_Delay( 500 );


		// Chargement de l'hélico.
	    sdlTexture1 := IMG_LoadTexture( sdlRenderer, 'AssetsF1_F2\Helicopter.png' );
	    if sdlTexture1 = nil then HALT;

	  	// Préparation des deux rectangles pour gérer l'hélicoptère, spriteheli pour choisir le sprite utilisé actuellement (pour animer l'hélico)
	  	// Et sourisheli pour gérer la position de l'hélicoptère.
	  	spriteheli.x := 0;
	  	spriteheli.y := 0;
	  	spriteheli.w := LARGEURIMAGEHELICO;
	  	spriteheli.h := HAUTEURIMAGEHELICO;

	  	sourisheli.x := 0;	
	  	sourisheli.y := 0;
	  	sourisheli.w := LARGEURIMAGEHELICO;
	  	sourisheli.h := HAUTEURIMAGEHELICO;


	  	// Chargement de la texture dans les rectangles.
	  	SDL_RenderCopy(sdlRenderer, sdlTexture1, @spriteheli, @sourisheli);
	  	SDL_RenderPresent(sdlRenderer);


		new( sdlEvent );

	  	finhelico:=false;
	  	While finhelico=false DO
	  	begin
	  		//Réactualisation de l'affichage.
			SDL_RenderClear( sdlRenderer );

		    //Gestion des inputs.
		    WHILE SDL_PollEvent (sdlEvent)=1 DO
	        BEGIN
	            CASE sdlEvent^.type_ OF
	                SDL_KEYDOWN :
	                BEGIN
	                	//Appuyez sur échap pour quitter.
	                    IF sdlEvent^.key.keysym.sym=SDLK_ESCAPE THEN finhelico:= true;
	                END;
	            END;
	        END;

		    //Gestion des mouvements selon la souris
			sourisheli.x := (sdlEvent^.motion.x-(LARGEURIMAGEHELICO DIV 2));
			sourisheli.y := (sdlEvent^.motion.y-(HAUTEURIMAGEHELICO DIV 2));

		    //Changement du sprite de l'hélicoptère pour l'animation.
			spriteheli.x:=spriteheli.x+LARGEURIMAGEHELICO;
			if (spriteheli.x = (LARGEURIMAGEHELICO*NBSPRITEHELICO)) then
			begin
				spriteheli.x:=0;
			end;

			//Actualisation du sprite de l'hélicoptère
			SDL_RenderCopy(sdlRenderer, sdlTexture1, @spriteheli, @sourisheli);
	  		SDL_RenderPresent(sdlRenderer);
		end;
	END;

//BUT : Effacé les éléments SDL pour fermer le programme et vider la mémoire utilisée.
//ENTREE : Rien.
//SORTIE : Les éléments de SDL effacés, puis la fin du programme.
procedure FinSDL();
	BEGIN
		 //On nettoie la mémoire.
	  	dispose( sdlEvent );
	  	SDL_DestroyTexture( sdlTexture1 );
	  	SDL_DestroyRenderer( sdlRenderer );
	  	SDL_Quit;
	END;

//DEBUT DU PROGRAMME PRINCIPAL

BEGIN

	Initialisation(); //Ici on va créer la fenêtre.

	RectangleDessin(); //Réponse pour l'exercice pour dessiner un rectangle en SDL.

	AfficherBitMap(); //Réponse pour l'exercice pour afficher un Bitmap à l'écran.

	AfficherImage(); //Utilisation de SDL_Image et affichage d'un .jpg à l'écran.

	HelicopterAnimation(); 	//Affichage de l'hélicoptère en .png à l'écran et animation de cet hélicoptère.
							//Il suit la souris et il faut appuyer sur Echap pour quitter.

	FinSDL(); //Nettoyage de la mémoire avant la fin du programme
End.