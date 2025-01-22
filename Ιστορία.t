#charset "iso-8859-7"

/*
 *   Copyright (c) 1999, 2002 by Michael J. Roberts.  Permission is
 *   granted to anyone to copy and use this file for any purpose.  
 *   
 *   This is a starter TADS 3 source file.  This is a complete TADS game
 *   that you can compile and run.
 *   
 *   To compile this game in TADS Workbench, open the "Build" menu and
 *   select "Compile for Debugging."  To run the game, after compiling it,
 *   open the "Debug" menu and select "Go."
 *   
 *   This is the "advanced" starter game - it has only the minimum set of
 *   definitions needed for a working game.  If you would like some more
 *   examples, create a new game, and choose the "introductory" version
 *   when asked for the type of starter game to create.  
 */

/* 
 *   Include the main header for the standard TADS 3 adventure library.
 *   Note that this does NOT include the entire source code for the
 *   library; this merely includes some definitions for our use here.  The
 *   main library must be "linked" into the finished program by including
 *   the file "adv3.tl" in the list of modules specified when compiling.
 *   In TADS Workbench, simply include adv3.tl in the "Source Files"
 *   section of the project.
 *   
 *   Also include the US English definitions, since this game is written
 *   in English.  
 */
#include <adv3.h>
#include <el_gr.h>

/*
 *   Our game credits and version information.  This object isn't required
 *   by the system, but our GameInfo initialization above needs this for
 *   some of its information.
 *   
 *   You'll have to customize some of the text below, as marked: the name
 *   of your game, your byline, and so on.
 */
versionInfo: GameID
    IFID = 'ec944db5-6225-4d0b-a7a4-4eac87cfb010'
    name = 'Η δική μου ιστορία'
    byline = 'by Δήμητρα Μπάτζιου'
    htmlByline = 'by <a href="mailto:your-email@host.com">
                  Δήμητρα Μπάτζιου</a>'
    version = '1'
    authorEmail = 'Δήμητρα Μπάτζιου <your-email@host.com>'
    desc = 'Put a brief "blurb" about your game here'
    htmlDesc = 'Put a brief "blurb" about your game here'
;

/*
 *   The "gameMain" object lets us set the initial player character and
 *   control the game's startup procedure.  Every game must define this
 *   object.  For convenience, we inherit from the library's GameMainDef
 *   class, which defines suitable defaults for most of this object's
 *   required methods and properties.  
 */
gameMain: GameMainDef
    /* the initial player character is 'me' */
    initialPlayerChar = me
     showIntro()
     {
       "Η περιπέτεια του χαμένου δαχτυλιδιού ξεκινά!\b";
     }
     showGoodbye()
     {
       "<.p>Αντίο!\b";
     }
     maxScore = 6     
     beforeRunsBeforeCheck = nil     
;


me: Actor
    /* the initial location */
    location = outsideHouse
;

+ Wearable 'βαρύ μαύρο πανωφόρι/παλτό' 'μαύρ[-ος-η-ο] πανωφόρι'
    "Είναι αρκετά απλό, αλλά το θεωρείς ζεστό."
    wornBy = me
    dobjFor(Doff)
    {
        check()
        {
            failCheck('Δεν μπορείς να τριγυρνάς μισόγυμνος! ');
        }
    }
;
+ Wearable 'κόκκινες δερμάτινες *μπότες' 'δερμάτιν[-ος-η-ο] μπότα'
    "Οι μπότες προστατεύουν καλά από το κρύο και την βροχή."
	isHerPlural = true
    wornBy = me
    dobjFor(Doff)
    {
        check()
        {
            failCheck('Δεν μπορείς να τριγυρνάς ξυπόλητος! ');
        }
    }
;
///////////////////////
modify Thing
    listLocation_ = nil
    listRemoteContents(otherLocation)
    {
        listLocation_ = otherLocation;
        try
        {
            lookAround(gActor, LookListSpecials | LookListPortables); 
        }
        finally
        {
            listLocation_ = nil;
        }
    }
    
    adjustLookAroundTable(tab, pov, actor)
    {
        inherited(tab, pov, actor);
        if(listLocation_ !=  nil)
        {
            local lst = tab.keysToList();
            foreach(local cur in lst)
            {
                if(!cur.isIn(listLocation_))
                    tab.removeElement(cur);
            }
        }
    }
;
////////////////////////

outsideHouse : OutdoorRoom 'Μπροστά στο σπίτι' 
   "Βρέχει, αστραπές και κεραυνοί φωτίζουν στιγμιαία τον χώρο γύρω σου με τις ξαφνικές τους λάμψεις.
   Στέκεσαι έξω από ένα μικρό, μοναχικό σπίτι. Στα νότια απλώνεται ένα σκοτεινό και πυκνό δάσος. Το έδαφος κάτω από τα πόδια σου είναι καλυμμένο
με υγρή τύρφη, που βουλιάζει ελαφρώς με κάθε σου βήμα, σαν να παραδίδεται απρόθυμα στο βάρος σου. 
Στα βορειοδυτικά μπορείς να διακρίνεις ένα στενό μονοπάτι να χάνεται μέσα στην ομίχλη.   "

   south = darkForest
   northwest = mistyRoom
   in = houseDoor
   north asExit(in)
   isIt=true
;
+Enterable ->insideHouse 'μικρό σπίτι/κτήριο' 'μικρ[-ός-ή-ό] σπίτι'
   "Οι τοίχοι του είναι φτιαγμένοι από μαύρη πέτρα, γεμάτοι με ρωγμές που θυμίζουν φλέβες και αφήνουν μια αίσθηση ότι το ίδιο το κτίριο αναπνέει. 
   Οι σκιές πάνω τους μετακινούνται με τρόπους που δεν θα έπρεπε να υπακούν στο φως της ημέρας. 
   Η στέγη είναι από σχιστόλιθο, βαμμένη με ένα βαθύ γκρι χρώμα που, όταν βρέχει, 
   μοιάζει σχεδόν μαύρο, και οι υδρορροές της εκπέμπουν έναν κούφιο ήχο σαν 
   αναστεναγμό κάθε φορά που περνά το νερό. 
   Τα παράθυρα είναι στενά και βαθιά, πλαισιωμένα από ξύλο τόσο παλιό που μοιάζει να διαβρώνεται από τα ίδια τα χρόνια. 
   
   <br><br>Από μέσα, ένα αχνό φως τρεμοπαίζει, σαν κάποιος να περιμένει πίσω από τις κουρτίνες. Ποτέ, όμως, δεν υπάρχει κίνηση. "
   location = outsideHouse
   isIt =true
   cannotCleanMsg = dobjMsg('Δεν έχετε χρόνο για κάτι τέτοιο αυτήν την στιγμή. ')
    notASurfaceMsg = iobjMsg('Δεν μπορείς να φτάσεις την σκεπή. ')
	cannotTakeMsg = 'Δεν νομίζεις ότι είναι λίγο βαρύ για σένα; Κάνε κάτι άλλο καλύτερα. '
 
;

+ houseDoor : LockableWithKey, Door 'παλιά ξύλινη πόρτα' 'παλι[-ός-ά-ό] πόρτα'
    "Η πόρτα του σπιτιού είναι βαριά και ξύλινη, με το χρώμα της να έχει ξεφτίσει από τα χρόνια και τη βροχή, αποκαλύπτοντας σκασίματα και ρωγμές στο υλικό της. 
	Μια σκουριασμένη σιδερένια λαβή κρέμεται στο πλάι, μοιάζοντας να έχει εγκαταλειφθεί στη μοίρα της.  "
    isHer =true
	keyList = [houseKey]
	
	
;

+Decoration 'υγρή τύρφη/έδαφος' 'υγρ[-ός-ή-ό] τύρφη'
 "Η υγρή τύρφη απλώνεται γύρω σου, αφήνοντας μια ανεπαίσθητη μυρωδιά υγρασίας και αποσύνθεσης στον αέρα.
 Η επιφάνειά της είναι μαλακή και ασταθής. Κάθε σου βήμα αφήνει πίσω του ένα αποτύπωμα που γεμίζει αργά με νερό, λες και το έδαφος 
 προσπαθεί να επουλώσει τις πληγές του."
 isHer =true
;

+ Distant 'σκοτεινό πυκνό δάσος' 'δάσος'
    "Το σκοτεινό δάσος βρίσκεται στα νότια. "
    tooDistantMsg = 'Είναι πολύ μακριά για κάτι τέτοιο. '
	isIt = true
;
+ Distant 'στενό μονοπάτι' 'μονοπάτι'
    "Το μονοπάτι οδηγεί βορειοδυτικά. "
    tooDistantMsg = 'Είναι πολύ μακριά για κάτι τέτοιο. '
	isIt = true
;


+Decoration 'σκουριασμένη σιδερένια λαβή' 'σκουριασ[-μένος-μένη-μένο] λαβή'
 "Δεν είναι τίποτα παραπάνω από ένα πόμολο"
 isHer =true
 ;



houseWindow : SenseConnector, Fixture 'παράθυρο' 'παράθυρο'
  "Το παράθυρο είναι θολό αλλά αν κοιτάξει κανείς από κοντά ίσως να δει κάτι. Φαίνεται ότι έχει καιρό να καθαριστεί. "

  dobjFor(LookThrough)
  {
    verify() {}
    check() {}
    action()
    {
      local otherLocation;
	  connectorMaterial = glass;
      if(gActor.isIn(outsideHouse))
      {
         otherLocation = insideHouse;
         "Κοιτάς μέσα από το παράθυρο. Μπορείς να διακρίνεις το εσωτερικό του σπιτιού. ";     
      }
      else
      {
         otherLocation = outsideHouse;
         "Κοιτώντας έξω από το παράθυρο μπορείς να δεις το μονοπάτι που οδηγεί προς το δάσος. ";         
      }
      gActor.location.listRemoteContents(otherLocation);     

    }
  }   
  connectorMaterial = adventium
  locationList = [outsideHouse, insideHouse]
  isIt=true
;
///////////////////////////////////////////////////////
insideHouse : Room 'σαλόνι' 'σαλόνι'
  "Βρίσκεσαι στο εσωτερικό του σπιτιού, όπου το φως ενός μοναχικού κεριού τρεμοπαίζει, προκαλώντας ακανόνιστες σκιές στους τοίχους. 
  Το κερί στέκεται πάνω σε ένα παλιό, κακοφτιαγμένο τραπέζι. Γύρω του, ξεραμένα λουλούδια κείτονται στο πάτωμα, σαν κάποιος να έφυγε βιαστικά. "  
   out = houseDoorInside
   south asExit(out)
   isIt = true
   
   remoteRoomContentsLister(other)
    {
        return new CustomRoomLister('Μέσα από το παράθυρο, {εσύ/αυτός} {βλέπω}', 
                                    ' στο έδαφος.');
    }
   	up : TravelMessage 
  {  
    destination = inpatari 
    canTravelerPass(traveler) 
             { return traveler.isIn(chair) && traveler.posture==standing; }
           explainTravelBarrier(traveler) 
            { "Το πατάρι είναι πολύ ψηλά. "; }  
			
			travelDesc =  "Με το να σταθείς πάνω στην καρέκλα καταφέρνεις να ανέβεις πάνω στο πατάρι.<.p>"
  }
;
+ houseDoorInside : Lockable, Door -> houseDoor 'πόρτα' 'πόρτα';

+Candle 'κόκκινο μισολιωμένο κερί*κεριά' 'κόκκινο κερί'
	 "Έίναι ένα κόκκινο κερί που κάποτε είχε την μορφή μίας φιγούρας, η οποία έχει παύσει να είναι διακριτή από την παραμόρφωση."
	 isIt =true
	;

+Surface 'παλιό κακοφτιαγμένο ξύλινο τραπέζι' 'τραπέζι'
"Το τραπέζι φαίνεται ευαίσθητο, έτοιμο να πέσει με την παραμικρή πίεση."
isIt=true

;

+Fixture 'βρώμικο ψηλό ξύλινο ξύλινη πατάρι/καταπακτή' 'βρώμικ[-ος-η-ο] πατάρι'
	"Είναι μια εσοχή στον τοίχο όπου κάποιος μπορεί να αποθηκεύσει αντικείμενα. Φαίνεται σαν κάτι στο οποίο θα μπορούσες να ανέβεις. 
	Η ξύλινη κατασκευή του μοιάζει πρόχειρη, με τη μικρή καταπακτή του να παραμένει μισάνοιχτη"
	remoteInitSpecialDesc(actor) { "Μέσα από το παράθυρο μπορείς να δεις κάτι να αχνοφαίνεται ψηλά στον τοίχο";}
	isIt=true
	dobjFor(Climb) remapTo(Up)
;

///////////////////////////////////////////////////////////////////////////////
inpatari : Room 'Πατάρι'
	"Το πατάρι είναι ένας στενός αποθηκευτικός χώρος που έχει χρόνια να ανοιχθεί. Μπορείς να μυρίσεις 
	την μούχλα στην ατμόσφαιρα. Αυτό είναι γεμάτο άδεια κουτιά και ψόφια έντομα.
	Ένα αχνό σφύριγμα ακούγεται να έρχεται μέσα από ένα ντουλάπι που υπάρχει στην δεξιά γωνία."
	out = insideHouse
   down asExit(out) 
	
	enteringRoom(traveler) 
    {	    
        if(!traveler.hasSeen(self) && traveler == gPlayerChar)	
            addToScore(1, 'φτάνοντας στο πατάρι. ');	    	    
    } 
	
	
	isIt =true
;

+ ntoulapi : OpenableContainer, Heavy 'παλιό μικρό στενό ντουλάπι' 'στεν[-ός-ή-ό] ντουλάπι'
	" Το ντουλάπι είναι παλιό και στενό. Πάνω του υπάρχει μια ετικέτα που γράφει 'ΕΡΓΑΛΕΙΑ'. Ένας περίεργος, ψιθυριστός ήχος φαίνεται να έρχεται από μέσα του."
	
	isIt=true
    
;


++ snake : Thing 'ανοιχτόχρωμο αντικείμενο/πράγμα' 'ανοιχτόχρωμ[-ος-η-ο] αντικείμενο'
"Ένα ανοιχτόχρωμο αντικείμενο κρύβεται πίσω από τους ιστούς αράχνης. Δεν φαίνεται ξεκάθαρα από τι είναι φτιαγμένο αλλά φαίνεται σαν να έχει μια διχρωμία."
	actionDobjTake()      
    {  
      "Απλώνεις το χέρι σου να πιάσεις το περίεργο αντικείμενο. Αλλά δεν είχες προσέξει ότι δεν είναι αυτό που ψάχνεις. 
	  Είναι ένα φίδι. Με πανικό πας να τραβήξεις το χέρι σου προς τα πίσω αλλά είναι πλέον αργά. 
	  Το φίδι σε τσιμπά.";  
        
      finishGameMsg(ftDeath, [finishOptionUndo]);  
    } 
	isIt=true
;

++ rope : Attachable, Thing 'σκούρο σκουρόχρωμο αντικείμενο/πράγμα' 'σκουρόχρωμ[-ος-η-ο] αντικείμενο'
	"Είναι ένα σκουρόχρωμο αντικείμενο. Η επιφάνειά του δεν είναι λεία."
	initSpecialDesc = "Ένα σκουρόχρωμο αντικείμενο κρύβεται στην αριστερή πλευρά του ντουλαπιού. Οι ιστοί αράχνης δεν σε αφήνουν να καταλάβεις τι ακριβώς βλέπεις. Είναι κυκλικά τυλιγμένο. "
	isIt=true
	dobjFor(ClimbDown) remapTo(Down)
	dobjFor(Take)
  {
	action()  
    {  
      if(!isHeldBy(gActor))  
      {
		  addToScore(1, 'παίρνοντας το σχοινί. ');
		  inherited;
		  name = 'μακρ[-ύς-ιά-ύ] σχοινί';
		  initializeVocabWith(name);
			isIt=true;
	  }
	}
  }
	canAttachTo(obj) { return obj == hook; }
	
	dobjFor(Unfasten) asDobjFor(Detach)
	 dobjFor(Fasten)
	 {
	 verify() { }
	 action() { askForIobj(AttachTo); }
	 }
	 dobjFor(FastenTo) remapTo(AttachTo, self, IndirectObject)
	 dobjFor(UnfastenFrom) remapTo(DetachFrom, self, IndirectObject)
;


//////////////
mistyRoom : OutdoorRoom 'Μέσα στην ομίχλη'
"Μέσα στην ομίχλη χάνεις την αίσθηση του προσανατολισμού. Το μόνο που μπορείς να δεις είναι μια φιγούρα να διαγράφεται."
isHer =true
southeast = outsideHouse
;

tin : OpenableContainer 'μικρό τετράγωνο δοχείο/αντικείμενο' 'μικρ[-ός-ή-ό] δοχείο'
	@mistyRoom
    "Είναι ένα μικρό τετράγωνο δοχείο με καπάκι. "
	initSpecialDesc = "Ένα αντικείμενο γυαλλίζει στο έδαφος"
    subLocation = &subSurface
    bulkCapacity = 5
	isIt = true
;

class Coin : Thing 'νόμισμα/λίρα*κέρματα*λίρες*νομίσματα' 'λίρα'
    "Το χρώμα του είναι χρυσό, έχει χαραγμένο το κεφάλι της Βασίλισσας στη μία πλευρά και γραμμένο <q>Μία Λίρα</q> στην πίσω πλευρά. 
	Η άκρη είναι χαραγμένη με τις λέξεις
    <q>DECUS ET TUTAMEN</q>"
    isEquivalent = true
	isHer = true
;

+  Coin;
+  Coin;
+  Coin;
+  Coin;


houseKey : Key 'μικρό ορειχάλκινο μεταλλικό αντικείμενο/κάτι/κλειδί' 'μεταλλικ[-ός-ή-ό] αντικείμενο'
	@tin
    "Είναι ένα μικρό ορειχάλκινο κλειδί, με μια ξεθωριασμένη ετικέτα πάνω του που δεν μπορείτε πλέον να διαβάσετε. "
    
	isIt=true
    remoteInitSpecialDesc(actor) { 
        
        "Υπάρχει μια στιγμιαία λάμψη καθώς το ελάχιστο φως του ηλίου που καταφέρνει να διαπεράσει τα σκούρα σύννεφα 
		αντανακλάται από κάτι γυαλιστερό."; }
    dobjFor(Take)
    {
        action()
        {
            if(!moved) addToScore(1, 'ανάκτηση του κλειδιού'); 
            inherited;
            name = 'μικρ[-ός-ή-ό] ορειχάλκιν[-ος-η-ο] κλειδί';
			isIt=true;
        }
    }
;
//////npc

stranger : Person 'μαυροφορεμένος άνθρωπος/ξένος' 'άνθρωπος'
  @mistyRoom
  "Είναι δύσκολο να διακρίνεις τα χαρακτηριστικά του κάτω από την μαύρη κουκούλα που φοράει. "
  //properName = 'ξένος' 
  globalParamName = 'ξένος'
  isHim = true
;

+ GiveShowTopic @ring
	topicResponse
  {
  "Όταν του δίνεις το δαχτυλίδι, το αρπάζει χωρίς δεύτερη σκέψη χώνοντάς το βαθιά μέσα στην τσέπη του.
  <q>Μπορείς να πηγαίνεις τώρα.</q> μουρμουρίζει και σου γυρνά την πλάτη.";
  addToScore (2, 'παράδοση δαχτυλιδιού στον ξένο. ');
     finishGameMsg(ftVictory, [finishOptionUndo,finishOptionFullScore]);
  }
;

+ DefaultGiveShowTopic, ShuffledEventList
  [
    'Ο ξένος κουνά το κεφάλι του με απογοήτευση. <q>Τι να το κάνω αυτό;.</q>',
    'Κοιτά το χέρι σου και αναστενάζει με θυμό. ',
    '<q>Θα έκανα μεγαλύτερη προσπάθεια αν ήμουν στη θέση σου,</q> μουρμουράει ο ξένος. '
  ]
;

+ strangerTalking : InConversationState
  stateDesc = "Στέκεται και συνομιλεί μαζί σου. " 
  specialDesc = "Ο ξένος, με το κεφάλι του σκυμμένο, σου μιλά. "
;

++ strangerWorking : ConversationReadyState
  stateDesc = "Ψάχνει με προσήλωση το έδαφος. "
  specialDesc = "Μια μοναχική φιγούρα περπατά σε κύκλους. "
  isInitState = true
 
;

+++ HelloTopic, StopEventList
  [
    '<q>Καλησπέρα,</q> λες εσύ προσπαθώντας να τραβήξεις την προσοχή της μοναχικής φιγούρας.<.p>
     {Ο ξένος/αυτός} περπατά τριγύρω, κοιτώντας επίμονα το έδαφος.
	 <q>Μη μου μιλάς αν δεν έχεις σκοπό να βοηθήσεις. Ψάχνω ένα δαχτυλίδι.</q>',
    '<q>Μη μου μιλάς και πήγαινε να ψάξεις.</q> φωνάζει ο ξένος πριν καν προλάβεις να μιλήσεις. '
  ]
;

+++ ByeTopic
  "<q>Αντίο, για τώρα.</q> του λες αλλά δεν σου δίνει σημασία.<.p>
   Η μόνη ένδειξη ότι σε άκουσε είναι ένα μικρό νεύμα του κεφαλιού του. "
;

+++ ImpByeTopic
  "Ο ξένος σε αγνοεί. "
;


++ DefaultAskTellTopic
   "<q>Ποια είναι η γνώμη σας σχετικά με <<gTopicText>>;</q> τον ρωτάς.<.p>
   <q><<rand('<q>Απλά άσε με ήσυχο,</q> εκείνος φωνάζει γυρνώντας σου την πλάτη.', 'Γιατί είσαι ακόμα εδώ;' , 'Άντε πήγαινε ψάξε!')>>.</q>"
;



///////////////////////////////////
darkForest : OutdoorRoom 'Μέσα στο Σκοτεινό Δάσος'
   "Μέσα στο πυκνό και σκοτεινό δάσος ένας δυνατός αέρας κάνει τα δέντρα να λυγίσουν, η κίνησή του ανάμεσά τους σαν μια συνεχόμενη κραυγή. 
   Εσύ βλέπεις ένα μονοπάτι να οδηγεί νότια, ένα δυτικά, ένα βορειοανατολικά και ένα βόρεια. "
    north = outsideHouse
    northeast = lake  
	south= clearing
	isIt=true
	
;
/////////////////////////////////
clearing : OutdoorRoom 'Ξέφωτο'    
   "Φτάνεις σε ένα ξέφωτο, ένα ήσυχο μέρος, όπου οι θόρυβοι των δέντρων κόβονται απότομα, σαν να διστάζουν να πλησιάσουν.
   Έμοιαζε με τόπο αιώνια παγιδευμένο ανάμεσα στη νύχτα και στη μέρα, με το ημίφως που σε περιτριγυρίζει την μόνη ένδειξη ζωής.
   Στο κέντρο του, υψώνεται ένα αρχαίο πηγάδι, με βρύα να καλύπτουν τις ρωγμές του. 
   <br>Ένα μονοπάτι οδηγεί προς τα βόρεια. "
    north = darkForest
    
	dobjFor(ClimbDown) remapTo(Down)
	isIt=true

	down : TravelMessage 
  {  
    destination = bottomOfWell 
    canTravelerPass(traveler) 
             { return rope.isAttachedTo(hook); }
           explainTravelBarrier(traveler) 
            { "Το πηγάδι είναι πολύ βαθύ. "; }  
			
			travelDesc =  "Δένεις το σχοινί στον γάντζο. Κρατώντας το σχοινί καταφέρνεις, σιγά, σιγά, να κατέβεις προς τα κάτω, μέσα στο πηγάδι.<.p>"
  }
    south : FakeConnector {"Αποφασίζεις να μην προχωρήσεις βαθύτερα στο δάσος, με τον φόβο ότι θα χαθείς. "}
;


+ well : Fixture, Thing 'πέτρινο παλιό πηγάδι' 'πέτριν[-ος-η-ο] παλι[-ός-ά-ό] πηγάδι'
    "Το πηγάδι φαίνεται αφύσικα βαθύ, και καμία αντανάκλαση νερού δεν φαίνεται στον πάτο του. 
	Σε έναν γάτζο πάνω στο πηγάδι, είναι δεμμένο ένα σχοινί. Φαίνεται σαν κάτι που θα μπορούσες να κατέβεις αν και το σχοινί δεν φαίνεται πολύ γερό. " 
	isIt = true
	;

++hook : Attachable,Fixture ,Thing  'σκουριασμένος γάντζος' 'σκουριασ[-μένος-μένη-μένο] γάντζος'
	"Είναι ένας σκουριασμένος γάτζος που, παρόλη την κακή του εμφάνιση, φαίνεται να είναι ακόμα λειτουργικός."
	isHim =true
	isMajorItemFor(obj) {return obj==rope; } 
;
	
	
/////////////////////////////////
bottomOfWell: Room 'Μέσα στο Πηγάδι'
   "Είναι σκοτεινά και η υγρασία σε πνίγει καθώς κρέμεσαι μέσα στο πηγάδι. Τα χέρια σου καίνε από την προσπάθεια σου να κρατηθείς από το σχοινί.
   Για μια στιγμή νιώθεις ότι αυτό που κάνεις δεν έχει νόημα, όταν ξαφνικά, μέσα στο σκοτάδι που σε περιτριγυρίζει, μια στιγμιαία λάμψη σου τραβάει την προσοχή. 
   Φαίνεται σαν μια αντανάκλαση του φωτός πάνω σε κάτι μεταλλικό. "
    out = clearing
	up asExit(out)
	down= mudRoom
	dobjFor(ClimbDown) remapTo(Down)
	dobjFor(Climb) remapTo(Up)
		isIt=true
	//dobjFor(ClimbUp) remapTo(Up)
;
///////////////////////////////////////
mudRoom: Room 'Στον Πάτο του Πηγαδιού'
   "Με τα πόδια σου να διστάζουν πολύ πριν ακουμπήσουν τον πάτο του πηγαδιού, παίρνεις την απόφαση και κατεβαίνεις από το σχοινί. Το έδαφος είναι λασπώδες και νιώθεις λες και προσπαθεί να σε τραβήξει προς τα κάτω, μέσα στο απύθμενο σκοτάδι του.
	Καλό θα ήταν να βιαστείς πριν κάτι τέτοιο γίνει πραγματικότητα. Γύρω σου το μόνο που διακρίνεις είναι η λάσπη."
    out = clearing
	up asExit(out)
	dobjFor(Climb) remapTo(Up)
	//dobjFor(ClimbUp) remapTo(Up)
	
;

+ ring : Thing 'πλατινένιο διαμαντένιο δαχτυλίδι' 'διαμαντένι[-ος-α-ο] δαχτυλίδι'
    "Το δαχτυλίδι αποτελείται από ένα αστραφτερό, μοναχικό διαμάντι τοποθετημένο σε πλατίνα. "
	isIt= true
;


//////////////////////////////////
lake : OutdoorRoom 'Λίμνη της Σιωπής'    
   "Μπροστά σου απλώνεται μια λίμνη, το νερό της πράσινο και θολό. Μια περίεργη ομίχλη την περιβάλλει, καλύπτοντας την επιφάνειά της σαν σύννεφο.
   Στην απέναντι όχθη βλέπεις κάτι που μοιάζει με σκάλα, πεσμένη στο έδαφος. Νιώθεις, όμως, ότι δεν είναι και πολύ καλή ιδέα να πας απέναντι.
	Στα νοτιοδυτικά βλέπεις ένα μονοπάτι που οδηγεί στο δάσος πίσω σου και άλλο ένα στα νότια. "
    southwest = darkForest
	isHer = true
    north : FakeConnector {"Αποφασίζεις να μην πας προς αυτήν την κατεύθυνση. Το φύλλωμα φαίνεται πολύ πιο πυκνό προς εκείνη την κατεύθυνση. "}
	
;

+water : Thing 'λίμνη' 'λίμνη'
"Η λίμνη φαίνεται πολύ επικίνδυνη"
isHer = true
dobjFor(Cross)
  {
	action()  
    {  
     "Προσπαθείς να περάσεις απέναντι αλλά νιώθεις το έδαφος του πυθμένα της λίμνης να υποχωρεί.
	 Με το επόμενό σου βήμα, χάνεσαι στο κενό.";  
        
      finishGameMsg(ftDeath, [finishOptionUndo]);  
	}
  }
  
  ;

+ chair : Chair 'ξύλινη παλιά καρέκλα[θ]/κάθισμα[ο]/καθίσματα[πο]' 'ξύλιν[-ος-η-ο] παλι[-ός-ά-ό] καρέκλα'
  "Είναι μια παλιά καρέκλα. Παρόλα τα χτυπήματα που έχει δεχθεί
	φαίνεται πως θα άντεχε να ανέβει κάποιος πάνω της. "
	initSpecialDesc = "Μία παλιά χτυπημένη καρέκλα βρίσκεται πεταμένη πάνω στα βράχια της λίμνης. "
	isHer =true
	dobjFor(Take)
  {
	action()  
    {  
      if(!isHeldBy(gActor))  
      {
		  addToScore(1, 'παίρνοντας την καρέκλα. ');
		  inherited;
	  }
	}
  }
	
  
;


////Επιπλέον Ρήματα

DefineTAction(Cross);

VerbRule(Cross)
    ('διάσχισε' | 'πέρνα') singleDobj
    : CrossAction
    verbPhrase = 'διάσχισεις/διασχίζεις (τι)'
;

