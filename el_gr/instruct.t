#charset "iso-8859-7"

/* 
 *   Copyright (c) 2000, 2006 Michael J. Roberts.  All Rights Reserved. 
 *   
 *   TADS 3 Library: Instructions for new players
 *   
 *   This module defines the INSTRUCTIONS command, which provides the
 *   player with an overview of how to play IF games in general.  These
 *   instructions are especially designed as an introduction to IF for
 *   inexperienced players.  The instructions given here are meant to be
 *   general enough to apply to most games that follow the common IF
 *   conventions. 
 *   
 *   This module defines the Greek version of the instructions.
 *   
 *   In most cases, each author should customize these general-purpose
 *   instructions at least a little for the specific game.  We provide a
 *   few hooks for some specific parameter-driven customizations that don't
 *   require modifying the original text in this file.  Authors should also
 *   feel free to make more extensive customizations as needed to address
 *   areas where the game diverges from the common conventions described
 *   here.
 *   
 *   One of the most important things you should do to customize these
 *   instructions for your game is to add a list of any special verbs or
 *   command phrasings that your game uses.  Of course, you might think
 *   you'll be spoiling part of the challenge for the player if you do
 *   this; you might worry that you'll give away a puzzle if you don't keep
 *   a certain verb secret.  Be warned, though, that many players - maybe
 *   even most - don't think "guess the verb" puzzles are good challenges;
 *   a lot of players feel that puzzles that hinge on finding the right
 *   verb or phrasing are simply bad design that make a game less
 *   enjoyable.  You should think carefully about exactly why you don't
 *   want to disclose a particular verb in the instructions.  If you want
 *   to withhold a verb because the entire puzzle is to figure out what
 *   command to use, then you have created a classic guess-the-verb puzzle,
 *   and most everyone in the IF community will feel this is simply a bad
 *   puzzle that you should omit from your game.  If you want to withhold a
 *   verb because it's too suggestive of a particular solution, then you
 *   should at least make sure that a more common verb - one that you are
 *   willing to disclose in the instructions, and one that will make as
 *   much sense to players as your secret verb - can achieve the same
 *   result.  You don't have to disclose every *accepted* verb or phrasing
 *   - as long as you disclose every *required* verb *and* phrasing, you
 *   will have a defense against accusations of using guess-the-verb
 *   puzzles.
 *   
 *   You might also want to mention the "cruelty" level of the game, so
 *   that players will know how frequently they should save the game.  It's
 *   helpful to point out whether or not it's possible for the player
 *   character to be killed; whether it's possible to get into situations
 *   where the game becomes "unwinnable"; and, if the game can become
 *   unwinnable, whether or not this will become immediately clear.  The
 *   kindest games never kill the PC and are always winnable, no matter
 *   what actions the player takes; it's never necessary to save these
 *   games except to suspend a session for later resumption.  The cruelest
 *   games kill the PC without warning (although if they offer an UNDO
 *   command from a "death" prompt, then even this doesn't constitute true
 *   cruelty), and can become unwinnable in ways that aren't readily and
 *   immediately apparent to the player, which means that the player could
 *   proceed for quite some time (and thus invest substantial effort) after
 *   the game is already effectively lost.  Note that unwinnable situations
 *   can often be very subtle, and might not even be intended by the
 *   author; for example, if the player needs a candle to perform an
 *   exorcism at some point, but the candle can also be used for
 *   illumination in dark areas, the player could make the game unwinnable
 *   simply by using up the candle early on while exploring some dark
 *   tunnels, and might not discover the problem until much further into
 *   the game.  
 */

#include "adv3.h"
#include "el_gr.h"

/*
 *   The INSTRUCTIONS command.  Make this a "system" action, because it's
 *   a meta-action outside of the story.  System actions don't consume any
 *   game time.  
 */
DefineSystemAction(Instructions)
    /*
     *   This property tells us how complete the verb list is.  By default,
     *   we'll assume that the instructions fail to disclose every required
     *   verb in the game, because the generic set we use here doesn't even
     *   try to anticipate the special verbs that most games include.  If
     *   you provide your own list of game-specific verbs, and your custom
     *   list (taken together with the generic list) discloses every verb
     *   required to complete the game, you should set this property to
     *   true; if you set this to true, the instructions will assure the
     *   player that they will not need to think of any verbs besides the
     *   ones listed in the instructions.  Authors are strongly encouraged
     *   to disclose a list of verbs that is sufficient by itself to
     *   complete the game, and to set this property to true once they've
     *   done so.  
     */
    allRequiredVerbsDisclosed = nil

    /* 
     *   A list of custom verbs.  Each game should set this to a list of
     *   single-quoted strings; each string gives an example of a verb to
     *   display in the list of sample verbs.  Something like this:
     *   
     *   customVerbs = ['brush my teeth', 'pick the lock'] 
     */
    customVerbs = []

    /* 
     *   Verbs relating specifically to character interaction.  This is in
     *   the same format as customVerbs, and has essentially the same
     *   purpose; however, we call these out separately to allow each game
     *   not only to supplement the default list we provide but to replace
     *   our default list.  This is desirable for conversation-related
     *   commands in particular because some games will not use the
     *   ASK/TELL conversation system at all and will thus want to remove
     *   any mention of the standard set of verbs.  
     */
    conversationVerbs =
    [
        'ΡΩΤΑ ΤΟΝ ΜΑΓΟ ΓΙΑ ΤΟ ΡΑΒΔΙ',
        'ΖΗΤΑ ΑΠΟ ΤΟΝ ΜΑΓΟ ΦΙΛΤΡΟ',
        'ΠΕΣ ΣΤΟΝ ΜΑΓΟ ΓΙΑ ΤΟΝ ΣΚΟΝΙΣΜΕΝΟ ΤΟΜΟ',
        'ΔΕΙΞΕ ΤΗΝ ΠΕΡΓΑΜΗΝΗ ΣΤΟΝ ΜΑΓΟ',
        'ΔΩΣΕ ΤΟ ΡΑΒΔΙ ΣΤΟΝ ΜΑΓΟ',
        'ΝΑΙ (ή ΟΧΙ)'
    ]

    /* conversation verb abbreviations */
    conversationAbbr = "\n\tΡΩΤΑ ΓΙΑ (θέμα) μπορεί να γραφτεί για συντομία ως
                        Ρ (θέμα)
                        \n\tΠΕΣ ΓΙΑ (θέμα) μπορεί να γραφτεί για συντομία ως Π (θέμα)"

    /*
     *   Truncation length. If the game's parser allows words to be
     *   abbreviated to some minimum number of letters, this should
     *   indicate the minimum length.  The English parser uses a truncation
     *   length of 6 letters by default.
     *   
     *   Set this to nil if the game doesn't allow truncation at all.  
     */
    truncationLength = 6

    /*
     *   This property should be set on a game-by-game basis to indicate
     *   the "cruelty level" of the game, which is a rough estimation of
     *   how likely it is that the player will encounter an unwinnable
     *   position in the game.
     *   
     *   Level 0 is "kind," which means that the player character can
     *   never be killed, and it's impossible to make the game unwinnable.
     *   When this setting is used, the instructions will reassure the
     *   player that saving is necessary only to suspend the session.
     *   
     *   Level 1 is "standard," which means that the player character can
     *   be killed, and/or that unwinnable positions are possible, but
     *   that there are no especially bad unwinnable situations.  When
     *   this setting is selected, we'll warn the player that they should
     *   save every so often.
     *   
     *   (An "especially bad" situation is one in which the game becomes
     *   unwinnable at some point, but this won't become apparent to the
     *   player until much later.  For example, suppose the first scene
     *   takes place in a location that can never be reached again after
     *   the first scene, and suppose that there's some object you can
     *   obtain in this scene.  This object will be required in the very
     *   last scene to win the game; if you don't have the object, you
     *   can't win.  This is an "especially bad" unwinnable situation: if
     *   you leave the first scene without getting the necessary object,
     *   the game is unwinnable from that point forward.  In order to win,
     *   you have to go back and play almost the whole game over again.
     *   Saved positions are almost useless in a case like this, since
     *   most of the saved positions will be after the fatal mistake; no
     *   matter how often you saved, you'll still have to go back and do
     *   everything over again from near the beginning.)
     *   
     *   Level 2 is "cruel," which means that the game can become
     *   unwinnable in especially bad ways, as described above.  If this
     *   level is selected, we'll warn the player more sternly to save
     *   frequently.
     *   
     *   We set this to 1 ("standard") by default, because even games that
     *   aren't intentionally designed to be cruel often have subtle
     *   situations where the game becomes unwinnable, because of things
     *   like the irreversible loss of an object, or an unrepeatable event
     *   sequence; it almost always takes extra design work to ensure that
     *   a game is always winnable.  
     */
    crueltyLevel = 1

    /*
     *   Does this game have any real-time features?  If so, set this to
     *   true.  By default, we'll explain that game time passes only in
     *   response to command input. 
     */
    isRealTime = nil

    /*
     *   Conversation system description.  Several different conversation
     *   systems have come into relatively widespread use, so there isn't
     *   any single convention that's generic enough that we can assume it
     *   holds for all games.  In deference to this variability, we
     *   provide this hook to make it easy to replace the instructions
     *   pertaining to the conversation system.  If the game uses the
     *   standard ASK/TELL system, it can leave this list unchanged; if
     *   the game uses a different system, it can replace this with its
     *   own instructions.
     *   
     *   We'll include information on the TALK TO command if there are any
     *   in-conversation state objects in the game; if not, we'll assume
     *   there's no need for this command.
     *   
     *   We'll mention the TOPICS command if there are any SuggestedTopic
     *   instances in the game; if not, then the game will never have
     *   anything to suggest, so the TOPICS command isn't needed.
     *   
     *   We'll include information on special topics if there are any
     *   SpecialTopic objects defined.  
     */
    conversationInstructions =
        "Μπορείτε να μιλήσετε με άλλους χαρακτήρες ρωτώντας τους ή 
		λέγοντάς τους πράγματα σχετικά με την ιστορία. 
		Για παράδειγμα, μπορείτε να πείτε ΡΩΤΑ ΤΟΝ ΜΑΓΟ ΓΙΑ ΤΟ ΡΑΒΔΙ ή ΠΕΣ ΣΤΟΝ ΦΡΟΥΡΟ ΓΙΑ ΤΟΝ ΣΥΝΑΓΕΡΜΟ.
		Πρέπει πάντα να χρησιμοποιείτε τις φράσεις ΡΩΤΑ ΓΙΑ ή ΠΕΣ ΓΙΑ. Το παιχνίδι δεν θα κατανοήσει άλλες μορφές, 
		επομένως δεν χρειάζεται να σκεφτείτε περίπλοκες ερωτήσεις όπως <q>ρώτα
        τον φρουρό πώς μπορείς να ανοίξεις το παράθυρο.</q>
        Στις περισσότερες περιπτώσεις, θα έχετε τα καλύτερα αποτελέσματα αν ρωτάτε για συγκεκριμένα αντικείμενα 
		ή άλλους χαρακτήρες που έχετε συναντήσει στην ιστορία, αντί για αφηρημένα θέματα όπως το ΝΟΗΜΑ ΤΗΣ ΖΩΗΣ. 
		Ωστόσο, εάν κάτι στην ιστορία σας οδηγεί στο συμπέρασμα ότι 
		θα <i>πρέπει</i> να ρωτήσετε για κάποιο συγκεκριμένο αφηρημένο θέμα, δεν υπάρχει λόγος να μην το δοκιμάσετε.

        \bΕάν θέλετε να ρωτήσετε ή να πείτε στον ίδιο χαρακτήρα πολλά πράγματα διαδοχικά, μπορείτε να συντομεύσετε τις 
		εντολές ΡΩΤΑ ΓΙΑ σε Ρ και ΠΕΣ ΓΙΑ σε Π. Για παράδειγμα, αφού αρχίσετε να μιλάτε με τον μάγο, μπορείτε να 
		συντομεύσετε την εντολή ΡΩΤΑ ΤΟΝ ΜΑΓΟ ΓΙΑ ΤΟ ΠΕΡΙΔΕΡΑΙΟ απλά σε Ρ ΠΕΡΙΔΕΡΑΙΟ. Αυτή η μορφή απευθύνεται στον 
		ίδιο χαρακτήρα όπως και η προηγούμενη εντολή ΡΩΤΑ ή ΠΕΣ.

        <<firstObj(InConversationState, ObjInstances) != nil ?
          "\bΓια να χαιρετήσετε έναν άλλο χαρακτήρα, πληκτρολογήστε ΜΙΛΑ ΣΤΟΝ/ΣΤΗΝ/ΣΤΟ (Όνομα Χαρακτήρα). 
		  Με αυτόν τον τρόπο προσπαθείτε να τραβήξετε την προσοχή του άλλου χαρακτήρα και να ξεκινήσετε μια συνομιλία. Η χρήση του ΜΙΛΑ ΣΤΟΝ/ΣΤΗΝ/ΣΤΟ είναι πάντα προαιρετική, 
		  καθώς μπορείτε να ξεκινήσετε απευθείας με ΡΩΤΑ ή ΠΕΣ εάν το προτιμάτε." : "">>

        <<firstObj(SpecialTopic, ObjInstances) != nil ?
          "\bΗ ιστορία μπορεί περιστασιακά να προτείνει κάποιες ειδικές 
		  εντολές συνομιλίας, όπως:

          \b\t(Θα μπορούσες να απολογηθείς, ή να εξηγήσεις σχετικά με τους εξωγήινους.)

          \bΕάν θέλετε, μπορείτε να χρησιμοποιήσετε μία από τις προτεινόμενες φράσεις πληκτρολογώντας 
		  την ακριβώς όπως εμφανίζεται. Μπορείτε συνήθως 
		  να συντομεύσετε αυτές τις φράσεις στις λίγες πρώτες λέξεις όταν είναι μεγάλες.

          \b\t&gt;ΑΠΟΛΟΓΗΣΟΥ
          \n\t&gt;ΕΞΗΓΗΣΕ ΣΧΕΤΙΚΑ ΜΕ ΤΟΥΣ ΕΞΩΓΗΙΝΟΥΣ

          \bΑυτές οι ειδικές προτάσεις ισχύουν μόνο τη συγκεκριμένη στιγμή που παρουσιάζονται, 
		  επομένως δεν χρειάζεται να τις απομνημονεύσετε ή να τις δοκιμάσετε σε άλλες τυχαίες 
		  στιγμές της ιστορίας. Δεν πρόκειται για νέες εντολές που πρέπει να μάθετε. Είναι απλώς επιπλέον 
		  επιλογές που έχετε στη διάθεσή σας σε συγκεκριμένες στιγμές και η ιστορία θα σας ενημερώνει πάντα όταν 
		  είναι διαθέσιμες. Όταν η ιστορία προτείνει τέτοιες επιλογές, δεν περιορίζουν τις εντολές που 
		  μπορείτε να δώσετε. Μπορείτε πάντα να πληκτρολογήσετε οποιαδήποτε άλλη εντολή αντί για μία από τις προτεινόμενες." : "">>

        <<firstObj(SuggestedTopic, ObjInstances) != nil ?
          "\bΕάν δεν είστε σίγουροι για το τι να συζητήσετε, μπορείτε να πληκτρολογήσετε 
		  ΘΕΜΑΤΑ ή ΘΕΜΑΤΑ ΣΥΖΗΤΗΣΗΣ κάθε φορά που μιλάτε με κάποιον. Αυτό θα σας εμφανίσει μια λίστα θεμάτων 
		  για τα οποία ενδέχεται ο χαρακτήρας σας να θέλει να συζητήσει με το άλλο πρόσωπο. Η εντολή ΘΕΜΑΤΑ συνήθως 
		  δεν εμφανίζει όλα τα θέματα συζήτησης, επομένως μπορείτε 
		  να εξερευνήσετε και άλλα θέματα ακόμα κι αν δεν περιλαμβάνονται στη λίστα." : "">>

        \bΜπορείτε επίσης να αλληλεπιδράσετε με άλλους χαρακτήρες χρησιμοποιώντας αντικείμενα. 
		Για παράδειγμα, μπορείτε να δώσετε κάτι σε κάποιον άλλο, όπως ΔΩΣΕ ΧΡΗΜΑΤΑ ΣΤΟΝ ΥΠΑΛΛΗΛΟ, ή να δείξετε ένα αντικείμενο 
		σε κάποιον, όπως ΔΕΙΞΕ ΤΟ ΕΙΔΩΛΙΟ ΣΤΟΝ ΚΑΘΗΓΗΤΗ. Μπορείτε επίσης να πολεμήσετε άλλους χαρακτήρες, 
		όπως ΚΑΝΕ ΕΠΙΘΕΣΗ ΣΤΟ ΤΡΟΛ ΜΕ ΤΟ ΣΠΑΘΙ ή ΡΙΞΕ ΤΟ ΤΣΕΚΟΥΡΙ ΣΤΟΝ ΝΑΝΟ.

        \bΣε ορισμένες περιπτώσεις, μπορείτε να ζητήσετε από έναν χαρακτήρα να κάνει κάτι για εσάς. 
		Αυτό γίνεται πληκτρολογώντας το όνομα του χαρακτήρα, ακολουθούμενο από κόμμα και στη συνέχεια την εντολή που θέλετε 
		ο χαρακτήρας να εκτελέσει, χρησιμοποιώντας την ίδια διατύπωση που 
		θα χρησιμοποιούσατε για μια εντολή προς τον δικό σας χαρακτήρα. Για παράδειγμα:

        \b\t&gt;ΡΟΜΠΟΤ, ΠΗΓΑΙΝΕ ΒΟΡΕΙΑ

        \bΝα θυμάστε ότι δεν υπάρχει καμία εγγύηση ότι οι άλλοι χαρακτήρες θα υπακούσουν πάντα στις εντολές σας. Οι περισσότεροι χαρακτήρες έχουν τη δική τους 
		προσωπικότητα και δεν θα κάνουν αυτόματα ό,τι τους ζητήσετε. "

    /* execute the command */
    execSystemAction()
    {
        local origElapsedTime;

        /* 
         *   note the elapsed game time on the real-time clock before we
         *   start, so that we can reset the game time when we're done; we
         *   don't want the instructions display to consume any real game
         *   time 
         */
        origElapsedTime = realTimeManager.getElapsedTime();

        /* show the instructions */
        showInstructions();

        /* reset the real-time game clock */
        realTimeManager.setElapsedTime(origElapsedTime);
    }

#ifdef INSTRUCTIONS_MENU
    /*
     *   Show the instructions, using a menu-based table of contents.
     */
    showInstructions()
    {
        /* run the instructions menu */
        topInstructionsMenu.display();

        /* show an acknowledgment */
        "Έγινε. ";
    }
    
#else /* INSTRUCTIONS_MENU */

    /*
     *   Show the instructions as a standard text display.  Give the user
     *   the option of turning on a SCRIPT file to capture the text.  
     */
    showInstructions()
    {
        local startedScript;

        /* presume we won't start a new script file */
        startedScript = nil;
        
        /* show the introductory message */
        "Η ιστορία πρόκειται να παρουσιάσει ένα πλήρες σύνολο οδηγιών,
		ειδικά σχεδιασμένο για άτομα που δεν είναι ήδη εξοικειωμένα
		με τα παιχνίδια διαδραστικής μυθοπλασίας. Οι οδηγίες είναι εκτενείς.";

        /*
         *   Check to see if we're already scripting.  If we aren't, offer
         *   to save the instructions to a file. 
         */
        if (scriptStatus.scriptFile == nil)
        {
            local str;
            
            /* 
             *   they're not already logging; ask if they'd like to start
             *   doing so 
             */
            ", ίσως θελήσετε να αποθηκεύσετε τις οδηγίες σε ένα αρχείο (για να τις εκτυπώσετε, για παράδειγμα). 
			Θέλετε να προχωρήσουμε;
            \n(Το <<aHref('ναι', 'Ν')>> αν δεν σας ενδιαφέρει η αποθήκευση των οδηγιών, ή πληκτρολογήστε
            <<aHref('σενάριο', 'ΣΕΝΑΡΙΟ')>> για να καταγραφούν σε ένα αρχείο) &gt; ";

            /* ask for input */
            str = inputManager.getInputLine(nil, nil);

            /* if they want to capture them to a file, set up scripting */
            if (rexMatch('<nocase><space>*σ(ε(ν(ά(ρ(ι(ο?)?)?)?)?)?)?<space>*', str)
                == str.length())
            {
                /* try setting up a scripting file */
                ScriptAction.setUpScripting(nil);

                /* if that failed, don't proceed */
                if (scriptStatus.scriptFile == nil)
                    return;
                
                /* note that we've started a script file */
                startedScript = true;
            }
            else if (rexMatch('<nocase><space>*ν.*', str) != str.length())
            {
                "Έγινε ακύρωση. ";
                return;
            }
        }
        else
        {
            /* 
             *   they're already logging; just confirm that they want to
             *   see the instructions 
             */
            ". Θα θέλατε να προχωρήσετε;
            \n(Ν για συμφωνία) &gt; ";

            /* stop if they don't want to proceed */
            if (!yesOrNo())
            {
                "Ακυρώθηκε. ";
                return;
            }
        }

        /* make sure we have something for the next "\b" to skip from */
        "\ ";

        /* show each chapter in turn */
        showCommandsChapter();
        showAbbrevChapter();
        showTravelChapter();
        showObjectsChapter();
        showConversationChapter();
        showTimeChapter();
        showSaveRestoreChapter();
        showSpecialCmdChapter();
        showUnknownWordsChapter();
        showAmbiguousCmdChapter();
        showAdvancedCmdChapter();
        showTipsChapter();

        /* if we started a script file, close it */
        if (startedScript)
            ScriptOffAction.turnOffScripting(nil);
    }

#endif /* INSTRUCTIONS_MENU */

    /* Entering Commands chapter */
    showCommandsChapter()
    {
        "\b<b>Εισαγωγή Εντολών</b>\b
        Πιθανότατα έχετε ήδη παρατηρήσει ότι αλληλεπιδράτε με την ιστορία πληκτρολογώντας μια εντολή κάθε φορά που βλέπετε την <q>υπόδειξη</q>, 
		η οποία συνήθως μοιάζει με αυτήν:
        \b";

        gLibMessages.mainCommandPrompt(rmcCommand);

        "\bΓνωρίζοντας αυτό, πιθανότατα σκέφτεστε ένα από τα δύο: <q>Υπέροχο, μπορώ να πληκτρολογήσω οτιδήποτε θέλω, στα ελληνικά, 
		και η ιστορία θα κάνει ό,τι της ζητήσω</q>, ή <q>Υπέροχο, τώρα πρέπει να μάθω ακόμα μία τρομερά περίπλοκη γλώσσα εντολών για ένα πρόγραμμα υπολογιστή. 
		Νομίζω καλύτερα να πάω να παίξω Ναρκαλιευτή</q>. Ωστόσο, και οι δύο αυτές γνώμες απέχουν από την πραγματικότητα.

        \bΣτην πραγματικότητα, θα χρειαστείτε μόνο ένα μικρό σύνολο εντολών, οι οποίες συνήθως εκφράζονται στα ελληνικά, επομένως 
		δεν έχετε πολλά να μάθετε ή να θυμάστε. Αν και η γραμμή εντολών μπορεί να φαίνεται 
		τρομακτική, μην αφήσετε να σας αποθαρρύνει - υπάρχουν μόνο λίγα απλά πράγματα που πρέπει να γνωρίζετε.

        \bΠρώτον, σπάνια θα χρειαστεί να αναφέρεστε σε κάτι που δεν αναφέρεται ρητά στην ιστορία. Εξάλλου, 
		πρόκειται για μια ιστορία, όχι για ένα παιχνίδι μαντεψιάς όπου πρέπει να σκεφτείτε τα πάντα που συνδέονται με κάποιο τυχαίο αντικείμενο. 
		Για παράδειγμα, εάν φοράτε ένα σακάκι, μπορεί να υποθέσετε ότι το σακάκι έχει τσέπες, κουμπιά ή 
		φερμουάρ - αλλά εάν η ιστορία δεν αναφέρει ποτέ αυτά τα στοιχεία, δεν χρειάζεται να ανησυχείτε γι' αυτά.

        \bΔεύτερον, δεν χρειάζεται να σκεφτείτε κάθε ενδεχόμενη ενέργεια που θα μπορούσατε να κάνετε. 
		Ο στόχος του παιχνιδιού δεν είναι να μαντέψετε ρήματα. Αντίθετα, θα χρειαστεί να χρησιμοποιήσετε μόνο ένα σχετικά μικρό αριθμό απλών, 
		συνηθισμένων ενεργειών. Για να σας δώσουμε μια ιδέα, 
		εδώ είναι μερικές από τις εντολές που μπορείτε να χρησιμοποιήσετε:";
        
        "\b
        \n\t ΚΟΙΤΑ ΤΡΙΓΥΡΩ
        \n\t ΑΠΟΘΕΜΑ
        \n\t ΠΗΓΑΙΝΕ ΒΟΡΕΙΑ (ή ΑΝΑΤΟΛΙΚΑ, ΝΟΤΙΟΑΝΑΤΟΛΙΚΑ, και πάει λέγοντας, ή ΠΑΝΩ, ΚΑΤΩ, ΜΕΣΑ, ΕΞΩ)
        \n\t ΠΕΡΙΜΕΝΕ
        \n\t ΠΑΡΕ ΤΟ ΚΟΥΤΙ
        \n\t ΑΦΗΣΕ ΤΟΝ ΔΙΣΚΟ
        \n\t ΚΟΙΤΑ ΤΟΝ ΔΙΣΚΟ
        \n\t ΔΙΑΒΑΣΕ ΤΟ ΒΙΒΛΙΟ
        \n\t ΑΝΟΙΞΕ ΤΟ ΚΟΥΤΙ
        \n\t ΚΛΕΙΣΕ ΤΟ ΚΟΥΤΙ
        \n\t ΚΟΙΤΑ ΜΕΣΑ ΣΤΟ ΚΟΥΤΙ
        \n\t ΚΟΙΤΑ ΜΕΣΑ ΑΠΟ ΤΟ ΠΑΡΑΘΥΡΟ
        \n\t ΒΑΛΕ ΤΟΝ ΔΙΣΚΟ ΜΕΣΑ ΣΤΟ ΚΟΥΤΙ
        \n\t ΒΑΛΕ ΤΟ ΚΟΥΤΙ ΠΑΝΩ ΣΤΟ ΤΡΑΠΕΖΙ
        \n\t ΦΟΡΑ ΤΟ ΚΑΠΕΛΟ
        \n\t ΒΓΑΛΕ ΤΟ ΚΑΠΕΛΟ
        \n\t ΑΝΑΨΕ ΤΟ ΦΑΝΑΡΑΚΙ
        \n\t ΑΝΑΨΕ ΤΟ ΚΕΡΙ ΜΕ ΤΟ ΣΠΙΡΤΟ
        \n\t ΠΙΕΣΕ ΤΟ ΚΟΥΜΠΙ
        \n\t ΤΡΑΒΑ ΤΟΝ ΜΟΧΛΟ
        \n\t ΓΥΡΝΑ ΤΟ ΧΕΡΟΥΛΙ
        \n\t ΓΥΡΝΑ ΤΟΝ ΔΕΙΚΤΗ ΣΤΟ 11
        \n\t ΦΑΕ ΤΟ ΜΠΙΣΚΟΤΟ
        \n\t ΠΙΕΣ ΤΟ ΓΑΛΑ
        \n\t ΡΙΞΕ ΤΗΝ ΠΙΤΑ ΣΤΟΝ ΚΛΟΟΥΝ
        \n\t ΚΑΝΕ ΕΠΙΘΕΣΗ ΣΤΟ ΤΡΟΛ ΜΕ ΤΟ ΣΠΑΘΙ
        \n\t ΞΕΚΛΕΙΔΩΣΕ ΤΗΝ ΠΟΡΤΑ ΜΕ ΤΟ ΚΛΕΙΔΙ
        \n\t ΚΛΕΙΔΩΣΕ ΤΗΝ ΠΟΡΤΑ ΜΕ ΤΟ ΚΛΕΙΔΙ
        \n\t ΣΚΑΡΦΑΛΩΣΕ ΤΗΝ ΣΚΑΛΑ
        \n\t ΜΠΕΣ ΜΕΣΑ ΣΤΟ ΑΥΤΟΚΙΝΗΤΟ
        \n\t ΚΑΤΣΕ ΣΤΗΝ ΚΑΡΕΚΛΑ
        \n\t ΑΝΕΒΑ ΣΤΟ ΤΡΑΠΕΖΙ
        \n\t ΣΤΑΣΟΥ ΜΕΣΑ ΣΤΟ ΠΑΡΤΕΡΙ
        \n\t ΞΑΠΛΩΣΕ ΣΤΟ ΚΡΕΒΑΤΙ
        \n\t ΠΛΗΚΤΡΟΛΟΓΙΣΕ ΓΕΙΑ ΣΤΟΝ ΥΠΟΛΟΓΙΣΤΗ
        \n\t ΑΝΑΖΗΤΗΣΕ ΤΟΝ ΜΠΟΜΠ ΣΤΟΝ ΤΗΛΕΦΩΝΙΚΟ ΚΑΤΑΛΟΓΟ";

        /* show the conversation-related verbs */
        foreach (local cur in conversationVerbs)
            "\n\t <<cur>>";

        /* show the custom verbs */
        foreach (local cur in customVerbs)
            "\n\t <<cur>>";

        /* 
         *   if the list is exhaustive, say so; otherwise, mention that
         *   there might be some other verbs to find 
         */
        if (allRequiredVerbsDisclosed)
            "\bΑυτά είναι όλα - κάθε ρήμα και κάθε διατύπωση εντολής που θα χρειαστείτε για να ολοκληρώσετε την ιστορία εμφανίζεται παραπάνω.
			Εάν ποτέ κολλήσετε και νιώσετε ότι η ιστορία περιμένει από εσάς να σκεφτείτε κάτι εντελώς απρόβλεπτο, θυμηθείτε αυτό: οτιδήποτε κι αν πρέπει να κάνετε, 
			μπορείτε να το κάνετε με μία ή περισσότερες από τις εντολές που εμφανίζονται παραπάνω.
			Μην ανησυχείτε ότι πρέπει να αρχίσετε να δοκιμάζετε τυχαίες εντολές για να βρείτε τη μαγική φράση, επειδή όλα όσα χρειάζεστε εμφανίζονται ξεκάθαρα παραπάνω. ";
        else
            "\bΤα περισσότερα από τα ρήματα που θα χρειαστείτε για να ολοκληρώσετε την ιστορία εμφανίζονται παραπάνω. Μπορεί να χρειαστείτε περιστασιακά και κάποιες επιπλέον 
			εντολές, αλλά θα ακολουθούν την ίδια απλή μορφή με τις εντολές που παρουσιάστηκαν παραπάνω.";

        "\bΜερικές από αυτές τις εντολές αξίζουν περισσότερη εξήγηση.
		Η εντολή ΚΟΙΤΑ ΤΡΙΓΥΡΩ (που μπορείτε να συντομεύσετε σε ΚΟΙΤΑ ή απλά σε Κ) εμφανίζει την περιγραφή της τρέχουσας τοποθεσίας.
		Μπορείτε να χρησιμοποιήσετε αυτήν την εντολή για να ανανεώσετε τη μνήμη σας σχετικά με το περιβάλλον του χαρακτήρα σας.
		Η εντολή ΑΠΟΘΕΜΑ (ή απλά ΑΠ) εμφανίζει μια λίστα με όλα όσα μεταφέρει ο χαρακτήρας σας.
		Η εντολή ΠΕΡΙΜΕΝΕ (ή Ζ) απλώς επιτρέπει τη πάροδο μικρού χρονικού διαστήματος στην ιστορία.";
    }

    /* Abbreviations chapter */
    showAbbrevChapter()
    {
        "\b<b>Συντομεύσεις</b>
        \bΘα χρησιμοποιείτε πιθανότατα μερικές εντολές πολύ συχνά, επομένως για να εξοικονομήσετε χρόνο πληκτρολόγησης, 
		μπορείτε να συντομεύσετε κάποιες από τις πιο συχνά χρησιμοποιούμενες εντολές:

        \b
        \n\t ΚΟΙΤΑ ΤΡΙΓΥΡΩ μπορεί να γραφτεί και ΚΟΙΤΑ ή για ακόμα μεγαλύτερη σύμπτυξη Κ
        \n\t ΑΠΟΘΕΜΑ μπορεί να γραφτεί ΑΠ
        \n\t ΠΗΓΑΙΝΕ ΒΟΡΕΙΑ μπορεί να γραφτεί ΒΟΡΕΙΑ, ή ακόμα και σκέτο Β (ομοίως Ν,Α,Δ,
            ΒΑ,ΒΔ,ΝΑ,ΝΔ,ΠΑ για το ΠΑΝΩ, ΚΑ για το ΚΑΤΩ)
        \n\t ΚΟΙΤΑ ΤΟΝ ΔΙΣΚΟ μπορεί να γραφτεί ως ΕΠΕΞΕΡΓΑΣΟΥ ΤΟΝ ΔΙΣΚΟ ή ΕΠ ΤΟΝ ΔΙΣΚΟ ή Χ ΤΟΝ ΔΙΣΚΟ
        \n\t ΠΕΡΙΜΕΝΕ μπορεί να γραφτεί Ζ
        <<conversationAbbr>>

        \b<b>Μερικές Ακόμα Λεπτομέρειες για τις Εντολές</b>
        \bΌταν εισάγετε εντολές, μπορείτε να χρησιμοποιείτε κεφαλαία ή πεζά γράμματα 
		ελεύθερα. Μπορείτε να χρησιμοποιείτε λέξεις όπως Ο/Η/ΤΟ και ΕΝΑΣ/ΜΙΑ/ΕΝΑ όταν είναι κατάλληλο, 
		αλλά μπορείτε να τις παραλείψετε εάν το προτιμάτε. ";

        if (truncationLength != nil)
        {
            "Μπορείτε να συμπτύξετε οποιαδήποτε λέξη στα αρχικά της <<
            spellInt(truncationLength)>> γραμματα, αλλά αν επιλέξετε να μην το κάνετε, 
			η ιστορία θα προσέξει το οτιδήποτε πληκτρολογήσετε. Αυτό σημαίνει, για παράδειγμα, 
			όρι εσείς μπορείτε να συμπτύξετε την λέξη ΣΚΟΥΛΗΚΟΜΥΡΜΗΓΚΟΤΡΥΠΑ σε <<
            'ΣΚΟΥΛΗΚΟΜΥΡΜΗΓΚΟΤΡΥΠΑ'.substr(1, truncationLength)
            >> ή <<
            'ΣΚΟΥΛΗΚΟΜΥΡΜΗΓΚΟΤΡΥΠΑ'.substr(1, truncationLength+2)
            >>, αλλά όχι σε <<
            'ΣΚΟΥΛΗΚΟΜΥΡΜΗΓΚΟΤΡΥΠΑ'.substr(1, truncationLength)
            >>SDF. ";
        }
    }

    /* Travel chapter */
    showTravelChapter()
    {
        "\b<b>Ταξίδι</b>
        \bΣε κάθε δεδομένη στιγμή της ιστορίας, ο χαρακτήρας σας βρίσκεται σε μια 
        <q>τοποθεσία.</q>  Η ιστορία περιγράφει την τοποθεσία όταν ο χαρακτήρας σας εισέρχεται 
		για πρώτη φορά και ξανά, κάθε φορά που πληκτρολογείτε ΚΟΙΤΑ. Κάθε τοποθεσία έχει συνήθως 
		ένα σύντομο όνομα που εμφανίζεται ακριβώς πριν από την πλήρη περιγραφή της. Το όνομα είναι χρήσιμο όταν σχεδιάζετε έναν χάρτη 
		και το σύντομο όνομα μπορεί να σας βοηθήσει να θυμηθείτε πού βρίσκεστε.

        \bΚάθε τοποθεσία είναι ένα ξεχωριστό δωμάτιο, ένας μεγάλος εξωτερικός χώρος ή κάτι παρόμοιο. (Μερικές φορές ένας ενιαίος 
		φυσικός χώρος χωρίζεται σε πολλές τοποθεσίες στο παιχνίδι, αλλά αυτό είναι σχετικά σπάνιο). Στις περισσότερες περιπτώσεις, 
		η μετάβαση σε μια τοποθεσία είναι το πιο συγκεκριμένο επίπεδο κίνησης. Μόλις ο χαρακτήρας σας βρίσκεται σε μια τοποθεσία, 
		συνήθως μπορεί να δει και να φτάσει σε όλα τα σημεία εντός της τοποθεσίας, επομένως δεν χρειάζεται να ανησυχείτε για το ακριβές 
		σημείο του χαρακτήρα σας εντός του χώρου. Περιστασιακά, μπορεί να διαπιστώσετε ότι κάτι είναι εκτός εμβέλειας, ίσως επειδή 
		βρίσκεται σε ένα ψηλό ράφι ή στην άλλη πλευρά μίας τάφρου. Σε αυτές τις περιπτώσεις, μπορεί να είναι χρήσιμο να είστε πιο 
		συγκεκριμένοι σχετικά με τη θέση του χαρακτήρα σας, 
		όπως για παράδειγμα να τον τοποθετήσετε πάνω σε κάτι (για παράδειγμα, ΑΝΕΒΑ ΣΤΟ ΤΡΑΠΕΖΙ).

        \bΓια να μετακινηθείτε από τη μία τοποθεσία στην άλλη, συνήθως χρησιμοποιούνται εντολές κατεύθυνσης: ΠΗΓΑΙΝΕ ΒΟΡΕΙΑ, ΠΗΓΑΙΝΕ ΒΟΡΕΙΟΑΝΑΤΟΛΙΚΑ, ΠΗΓΑΙΝΕ ΠΑΝΩ κ.τ.λ.
		(Μπορείτε να συντομεύσετε τις βασικές κατευθύνσεις σε ένα γράμμα - Β, Ν, Δ ,  - και τις διαγώνιες και πάνω και κάτω κατευθύνσεις σε δύο γράμματα - ΒΑ, ΒΔ, ΝΑ, ΝΔ, ΠΑ, ΚΑ).
		Η ιστορία θα σας ενημερώνει πάντα για τις διαθέσιμες κατευθύνσεις κατά την περιγραφή κάθε τοποθεσίας, επομένως δεν χρειάζεται να δοκιμάζετε όλες τις 
		πιθανές κατευθύνσεις για να δείτε αν οδηγούν κάπου.

        \bΣτις περισσότερες περιπτώσεις, η επιστροφή (με την αντίθετη κατεύθυνση από αυτήν που ακολουθήσατε για να φτάσετε σε μια τοποθεσία) θα σας οδηγήσει πίσω στην αρχική σας θέση, 
		αν και ορισμένες διόδους μπορεί να έχουν στροφές.

        \bΣτις περισσότερες περιπτώσεις, όταν η ιστορία περιγράφει μια πόρτα ή μια διάβαση, 
		δεν θα χρειαστεί να ανοίξετε την πόρτα για να περάσετε, καθώς η ιστορία θα το κάνει αυτό για εσάς. 
		Μόνο όταν η ιστορία αναφέρει ρητά ότι μια πόρτα εμποδίζει τη διέλευσή σας, 
		συνήθως θα πρέπει να αντιμετωπίσετε την πόρτα ρητά.";
    }

    /* Objects chapter */
    showObjectsChapter()
    {
        "\b<b>Διαχείριση Αντικειμένων</b>
        \bΜπορείτε να βρείτε στην ιστορία αντικείμενα που ο χαρακτήρας σας μπορεί να μεταφέρει ή να χειριστεί. 
		Εάν θέλετε να πάρετε κάτι, πληκτρολογήστε ΠΑΡΕ και το όνομα του αντικειμένου: ΠΑΡΕ ΤΟ ΒΙΒΛΙΟ. 
		Εάν θέλετε να ρίξετε κάτι που μεταφέρει ο χαρακτήρας σας, πληκτρολογήστε ΑΣΕ.

        \bΣυνήθως δεν χρειάζεται να είστε πολύ συγκεκριμένοι σχετικά με τον ακριβή τρόπο που ο χαρακτήρας σας κρατάει ή μεταφέρει ένα αντικείμενο. Δεν χρειάζεται να ανησυχείτε για το ποιο χέρι κρατάει ποιο αντικείμενο.
		Μπορεί μερικές φορές να είναι χρήσιμο να τοποθετήσετε ένα αντικείμενο μέσα ή πάνω σε ένα άλλο, για παράδειγμα: ΒΑΛΕ ΤΟ ΒΙΒΛΙΟ ΣΤΗΝ ΤΣΑΝΤΑ ή ΒΑΛΕ ΤΟ ΒΑΖΟ ΠΑΝΩ ΣΤΟ ΤΡΑΠΕΖΙ.
		Εάν τα χέρια του χαρακτήρα σας γεμίσουν, μπορεί να είναι χρήσιμο να τοποθετήσετε ορισμένα αντικείμενα που μεταφέρετε μέσα σε έναν δοχείο, όπως ακριβώς στη πραγματική ζωή μπορείτε να μεταφέρετε περισσότερα πράγματα εάν 
		βρίσκονται σε μια τσάντα ή ένα κουτί.

        \bΜπορείτε να αποκτήσετε πολλές επιπλέον πληροφορίες (και μερικές φορές ζωτικής σημασίας στοιχεία) 
		εξετάζοντας τα αντικείμενα, κάτι που μπορείτε να κάνετε με την εντολή ΚΟΙΤΑ (ή ισοδύναμα ΕΠΕΞΕΡΓΑΣΟΥ, 
		την οποία μπορείτε να συντομεύσετε απλά σε Χ ή ΕΠ, όπως στο Χ ΠΙΝΑΚΑ). Οι περισσότεροι έμπειροι 
		παίκτες έχουν την συνήθεια να εξετάζουν όλα τα αντικείμενα σε μια νέα τοποθεσία αμέσως. ";
    }

    /* show the Conversation chapter */
    showConversationChapter()
    {
        "\b<b>Αλληλεπίδραση με Χαρακτήρες</b>
        \bΟ χαρακτήρας σας μπορεί να συναντήσει άλλα άτομα ή πλάσματα μέσα στην ιστορία. 
		Μπορείτε, μερικές φορές, να αλληλεπιδράσετε με αυτούς τους χαρακτήρες.\b";

        /* show the customizable conversation instructions */
        conversationInstructions;
    }

    /* Time chapter */
    showTimeChapter()
    {
        "\b<b>Ώρα</b>";

        if (isRealTime)
        {
            "\bΟ χρόνος στην ιστορία προχωράει ανάλογα με τις εντολές που δίνετε. 
			Επιπλέον, ορισμένα μέρη της ιστορίας μπορεί να εξελιχθούν σε <q>πραγματικό χρόνο,</q>  που σημαίνει 
			ότι πράγματα ενδέχεται να συμβούν ακόμα και ενώ εσείς σκέφτεστε την επόμενη κίνησή σας.

            \bΕάν θέλετε να σταματήσετε τον χρόνο στο παιχνίδι ενώ απομακρύνεστε από τον υπολογιστή σας (ή απλά χρειάζεστε λίγο χρόνο για να σκεφτείτε), 
			μπορείτε να πληκτρολογήσετε ΠΑΥΣΗ.";
        }
        else
        {
            "\bΟ χρόνος στην ιστορία προχωράει μόνο όταν δίνετε εντολές. 
			Αυτό σημαίνει ότι τίποτα δεν συμβαίνει ενώ περιμένετε να πληκτρολογήσετε 
			την επόμενη εντολή σας. Κάθε εντολή διαρκεί περίπου τον ίδιο χρόνο στην ιστορία. 
			Εάν θέλετε να περάσει περισσότερος χρόνος στην ιστορία, για παράδειγμα επειδή πιστεύετε ότι πρόκειται να συμβεί κάτι, 
			μπορείτε να πληκτρολογήσετε ΠΕΡΙΜΕΝΕ ή ΑΝΑΜΟΝΗ (ή απλά Ζ). ";
        }
    }

    /* Saving, Restoring, and Undo chapter */
    showSaveRestoreChapter()
    {
        "\b<b>Αποθήκευση και Ανάκτηση</b>
        \bΜπορείτε να αποθηκεύσετε ένα στιγμιότυπο της τρέχουσας θέσης σας στην ιστορία ανά πάσα στιγμή, ώστε να μπορείτε 
		αργότερα να επαναφέρετε την ιστορία στην ίδια θέση. Το στιγμιότυπο θα αποθηκευτεί σε ένα αρχείο στον δίσκο του υπολογιστή σας και μπορείτε 
		να αποθηκεύσετε όσα διαφορετικά στιγμιότυπα επιθυμείτε (στο μέτρο που έχετε διαθέσιμο χώρο στον δίσκο σας).\b";

        switch (crueltyLevel)
        {
        case 0:
            "Σ' αυτήν την ιστορία, ο χαρακτήρας σας δεν θα πεθάνει ποτέ και δεν θα βρεθείτε ποτέ 
			σε μια κατάσταση όπου είναι αδύνατο να ολοκληρώσετε την ιστορία. Ό,τι κι αν συμβεί στον χαρακτήρα σας, 
			θα μπορείτε πάντα να βρείτε έναν τρόπο για να ολοκληρώσετε την ιστορία.
			Επομένως, σε αντίθεση με πολλά παιχνίδια κειμένου, δεν χρειάζεται να ανησυχείτε για την αποθήκευση 
			θέσεων για να προστατευτείτε από το να κολλήσετε σε αδιέξοδα.
			Φυσικά, μπορείτε ακόμα να αποθηκεύετε όσο συχνά θέλετε, για να διακόψετε τη συνεδρία σας και να επιστρέψετε αργότερα ή για να αποθηκεύσετε 
			θέσεις που νομίζετε ότι μπορεί να θέλετε να επισκεφθείτε ξανά.";
            break;

        case 1:
        case 2:
            "Είναι πιθανό ο χαρακτήρας σας να πεθάνει στην ιστορία ή να βρεθείτε σε μια αδύνατη κατάσταση όπου δεν 
			θα μπορείτε να ολοκληρώσετε την ιστορία.
			Επομένως, θα πρέπει να αποθηκεύετε τη θέση σας 
            <<crueltyLevel == 1 ? 'ανά διαστήματα' : 'συχνά'>>
            ώστε να μην χρειαστεί να επιστρέψετε πολύ πίσω αν συμβεί κάτι τέτοιο. ";

            if (crueltyLevel == 2)
                "(Θα πρέπει να διατηρείτε όλα τα παλιά αποθηκευμένα παιχνίδια σας, καθώς μπορεί να μην συνειδητοποιήσετε αμέσως ότι μια κατάσταση έχει γίνει αδύνατη. 
				Μπορεί να διαπιστώσετε ότι χρειάζεται να επιστρέψετε σε ένα σημείο πολύ πιο παλιό από αυτό που <i>νομίζατε</i> ότι ήταν ασφαλές.)";

            break;
        }

        "\bΓια να αποθηκεύσετε τη τρέχουσα θέση σας, πληκτρολογήστε ΑΠΟΘΗΚΕΥΣΗ στην γραμμή εντολών.
			Η ιστορία θα σας ζητήσει το όνομα του αρχείου στο οποίο θέλετε να αποθηκευτεί το παιχνίδι.
			Πρέπει να καθορίσετε ένα όνομα αρχείου κατάλληλο για το σύστημά σας και ο δίσκος θα πρέπει να έχει αρκετό ελεύθερο χώρο για να αποθηκευτεί το αρχείο.
			Θα ειδοποιηθείτε αν υπάρχει κάποιο πρόβλημα κατά την αποθήκευση.
			Πρέπει να χρησιμοποιήσετε ένα όνομα αρχείου που δεν υπάρχει ήδη στον υπολογιστή σας, 
			καθώς το νέο αρχείο θα αντικαταστήσει οποιοδήποτε υπάρχον αρχείο με το ίδιο όνομα.

        \bΜπορείτε να επαναφέρετε μια προηγουμένως αποθηκευμένη θέση πληκτρολογώντας ΑΝΑΚΤΗΣΗ σε οποιαδήποτε γραμμή εντολών.
		Η ιστορία θα σας ζητήσει το όνομα του αρχείου που θέλετε να επαναφέρετε.
		Αφού ο υπολογιστής διαβάσει το αρχείο, όλα στην ιστορία θα είναι ακριβώς όπως ήταν όταν αποθηκεύσατε αυτό το αρχείο.";

        "\b<b>Αναίρεση</b>
        \bΑκόμα κι αν δεν έχετε αποθηκεύσει πρόσφατα τη θέση σας, συνήθως μπορείτε να ανακαλέσετε τις τελευταίες εντολές σας χρησιμοποιώντας την εντολή ΑΝΑΙΡΕΣΗ.
		Κάθε φορά που πληκτρολογείτε ΑΝΑΙΡΕΣΗ, η ιστορία ανατρέπει την επίδραση μιας εντολής, επαναφέροντας την ιστορία όπως ήταν πριν πληκτρολογήσετε αυτήν την εντολή.
		Η εντολή ΑΝΑΙΡΕΣΗ περιορίζεται στην ανάκληση των τελευταίων εντολών, επομένως δεν αποτελεί υποκατάστατο της αποθήκευσης/επαναφοράς (ΑΠΟΘΗΚΕΥΣΗ/ΑΝΑΚΤΗΣΗ), αλλά είναι πολύ χρήσιμη εάν βρεθείτε απροσδόκητα σε 
		μια επικίνδυνη κατάσταση ή κάνετε ένα λάθος που θέλετε να διορθώσετε.";
    }

    /* Other Special Commands chapter */
    showSpecialCmdChapter()
    {
        "\b<b>Κάποιες άλλες Ειδικές Εντολές</b>
        \bΗ ιστορία καταλαβαίνει μερικές ακόμα ειδικές εντολές που μπορεί να σας φανούν χρήσιμες.

        \bΞΑΝΑ (ή απλά Ξ):  Επαναλαμβάνει την τελευταία εντολή. (Εάν η τελευταία γραμμή εισόδου περιείχε πολλές εντολές, 
		επαναλαμβάνεται μόνο η τελευταία εντολή της γραμμής.)
        \bΑΠΟΘΕΜΑ (ή απλά ΑΠ): Δείχνει τι κουβαλά ο χαρακτήρας σας.
        \bΚΟΙΤΑ (ή απλά Κ): Δείχνει την πλήρη περιγραφή του τόπου στον οποίο βρίσκεται ο χαρακτήρας σας.";

        /* if the exit lister module is active, mention the EXITS command */
        if (gExitLister != nil)
            "\bΕΞΟΔΟΙ: Δείχνει την λίστα όλων των πιθανών εξόδων  από την τρέχουσα τοποθεσία.      location.
            \bΕΞΟΔΟΙ ΕΝΕΡΓΕΣ/ΑΝΕΝΕΡΓΕΣ/ΚΑΤΑΣΤΑΣΗ/ΚΟΙΤΑ: Ελέγχει τον τρόπο με τον οποίο το παιχνίδι
            εμφανίζει τη λίστα με τις εξόδους. ΕΞΟΔΟΙ ΕΝΕΡΓΕΣ Εμφανίζει μια λίστα εξόδων στη γραμμή κατάστασης και επίσης εμφανίζει τις εξόδους σε κάθε περιγραφή δωματίου.  EXITS OFF turns off both of these listings.
            ΕΞΟΔΟΙ ΚΑΤΑΣΤΑΣΗ ενεργοποιεί μόνο τη λίστα εξόδων στη γραμμή κατάστασης και
            ΕΞΟΔΟΙ ΔΩΜΑΤΙΑ ενεργοποιεί μόνο τις λίστες εξόδων στις περιγραφές δωματίων.";
        
        "\bΟΥΠΣ:Διορθώνει μία λανθασμένη λέξη σε μια εντολή, χωρίς να χρειάζεται να πληκτρολογήσετε ξανά ολόκληρη την εντολή. Μπορείτε να χρησιμοποιήσετε την εντολή ΟΥΠΣ μόνο αμέσως μετά την ειδοποίηση του παιχνιδιού ότι δεν αναγνώρισε μια λέξη στην προηγούμενη εντολή σας. Πληκτρολογήστε ΟΥΠΣ ακολουθόμενο από τη διορθωμένη λέξη.
        \bΤΕΡΜΑΤΙΣΜΟΣ (ή απλά Τ): Τερματίζει την ιστορία.
        \bΕΠΑΝΕΚΚΙΝΗΣΗ: Ξεκινάει την ιστορία από την αρχή.
        \bΑΝΑΚΤΗΣΗ: Επαναφέρει μια θέση ενός αρχείου που προηγουμένως είχε αποθηκευτεί με την εντολή ΑΠΟΘΗΚΕΥΣΗ.
        \bΑΠΟΘΗΚΕΥΣΗ: Αποθηκεύει την τρέχουσα θέση μέσα στο αρχίο δίσκου.
        \bΣΕΝΑΡΙΟ: Ξεκινά την καταγραφή της συνεδρίας σας στην ιστορία, αποθηκεύοντας όλο το εμφανιζόμενο κείμενο σε ένα αρχείο στον δίσκο, 
		ώστε να μπορείτε να το διαβάσετε αργότερα ή να το εκτυπώσετε.
        \bΣΕΝΑΡΙΟ ΑΝΕΝΕΡΓΟ: Τερματίζει την καταγραφή που ξεκινήσατε με την εντολή ΣΕΝΑΡΙΟ.
        \bΑΝΑΙΡΕΣΗ: Ανακαλεί την τελευταία εντολή.
        \bΑΠΟΘΗΚΕΥΣΗ ΠΡΟΕΠΙΛΟΓΩΝ:  Αποθηκεύει τις τρέχουσες ρυθμίσεις σας για στοιχεία όπως ΕΙΔΟΠΟΙΗΣΕΙΣ, ΕΞΟΔΟΙ και ΥΠΟΣΗΜΕΙΩΣΕΙΣ ως προεπιλογές. Αυτό σημαίνει ότι οι ρυθμίσεις σας θα επαναφέρονται αυτόματα 
		την επόμενη φορά που θα ξεκινήσετε ένα νέο παιχνίδι ή θα κάνετε ΕΠΑΝΕΚΚΙΝΗΣΗ σε αυτό.
        \bΑΝΑΚΤΗΣΗ ΠΡΟΕΠΙΛΟΓΩΝ: Επαναφέρει ρητά τις ρυθμίσεις επιλογών που αποθηκεύσατε προηγουμένως με την εντολή ΑΠΟΘΗΚΕΥΣΗ ΠΡΟΕΠΙΛΟΓΩΝ. ";
    }
    
    /* Unknown Words chapter */
    showUnknownWordsChapter()
    {
        "\b<b>¶γνωστες Λέξεις</b>
        \bΗ ιστορία δεν γνωρίζει όλες τις λέξεις της Ελληνικής γλώσσας.
		Μπορεί ακόμη και περιστασιακά να χρησιμοποιήσει λέξεις στις δικές της περιγραφές τις οποίες δεν κατανοεί ως εντολές.
		Εάν πληκτρολογήσετε μια εντολή με μια λέξη που η ιστορία δεν γνωρίζει, η ιστορία θα σας ενημερώσει για τη μη αναγνωρισμένη λέξη.
		Εάν η ιστορία δεν γνωρίζει μια λέξη για κάτι που περιέγραψε και δεν γνωρίζει κανένα συνώνυμο για αυτό το πράγμα, μπορείτε πιθανώς 
		να υποθέσετε ότι το αντικείμενο είναι απλώς μια λεπτομέρεια της σκηνής και δεν είναι σημαντικό για την ιστορία. ";
    }

    /* Ambiguous Commands chapter */
    showAmbiguousCmdChapter()
    {
        "\b<b>Ασαφείς Εντολές</b>
        \bΑν πληκτρολογήσετε μια εντολή που παραλείπει κάποιες σημαντικές πληροφορίες, η ιστορία θα προσπαθήσει να καταλάβει τι εννοείτε.
			Όταν είναι λογικά προφανές από το πλαίσιο τι εννοείτε, η ιστορία θα κάνει μια υπόθεση για τις ελλείπουσες πληροφορίες και θα προχωρήσει με την εντολή.
			Η ιστορία θα σας ενημερώσει για τις υποθέσεις της σε αυτές τις περιπτώσεις, για να αποφευχθεί οποιαδήποτε σύγχυση μεταξύ των υποθέσεων της ιστορίας και των δικών σας.
			Για παράδειγμα:

        \b
        \n\t &gt;ΔΕΣΕ ΤΟ ΣΧΟΙΝΙ
        \n\t (στον γάτζο)
        \n\t Το σχοινί είναι τώρα δεμένο στον γάτζο. Η άκρη του σχοινιού
        \n\t σχεδόν φτάνει στον πάτο του λάκου.
        
        \bΕάν η εντολή σας είναι αρκετά ασαφής ώστε η ιστορία να μην μπορεί να κάνει με ασφάλεια κάποια υπόθεση, θα σας ζητηθεί περισσότερη πληροφορία. 
		Μπορείτε να απαντήσετε σε αυτές τις ερωτήσεις πληκτρολογώντας τις ελλείπουσες πληροφορίες.

        \b
        \n\t &gt;ΞΕΚΛΕΙΔΩΣΕ ΤΗΝ ΠΟΡΤΑ
        \n\t Με τι θέλεις να την ξεκλειδώσεις;
        \b
        \n\t &gt;ΚΛΕΙΔΙ
        \n\t Ποιο κλειδί εννοείς, το χρυσό κλειδί ή το ασημένιο κλειδί;
        \b
        \n\t &gt;ΧΡΥΣΟ
        \n\t ΞΕΚΛΕΙΔΩΤΗ.

        \bΕάν η ιστορία σας θέσει μία από αυτές τις ερωτήσεις και αποφασίσετε ότι δεν θέλετε να προχωρήσετε με την αρχική εντολή, 
		μπορείτε απλώς να πληκτρολογήσετε μία νέα εντολή αντί να απαντήσετε στην ερώτηση.";
    }

    /* Advance Command Formats chapter */
    showAdvancedCmdChapter()
    {
        "\b<b>Προγμένες Δομές Εντολών</b>
        \bΜόλις εξοικειωθείτε με την εισαγωγή εντολών, 
		μπορεί να σας ενδιαφέρουν και πιο σύνθετες μορφές εντολών που το 
		παιχνίδι υποστηρίζει. Αυτές οι προχωρημένες εντολές είναι εντελώς προαιρετικές, 
		καθώς μπορείτε πάντα να κάνετε τα ίδια πράγματα με τις απλούστερες μορφές που 
		έχουμε ήδη συζητήσει. Ωστόσο, έμπειροι παίκτες συχνά προτιμούν τις προχωρημένες 
		μορφές εντολών επειδή μπορούν να εξοικονομήσουν χρόνο πληκτρολόγησης.

        \b<b>Χρήση Πολλών Αντικειμένων Ταυτόχρονα</b>
        \bΣτις περισσότερες εντολές, μπορείτε να δράσετε πάνω σε πολλά αντικείμενα 
		μέσα σε μία εντολή. Χρησιμοποιήστε την λέξη ΚΑΙ, ή ένα κόμμα, για να διαχωρίσετε
        το ένα αντικείμενο από το άλλο:

        \b
        \n\t ΠΑΡΕ ΤΟ ΚΟΥΤΙ, ΤΟΝ ΔΙΣΚΟ ΚΑΙ ΤΟ ΣΧΟΙΝΙ
        \n\t ΒΑΛΕ ΤΟΝ ΔΙΣΚΟ ΚΑΙ ΤΟ ΣΧΟΙΝΙ ΜΕΣΑ ΣΤΟ ΚΟΥΤΙ
        \n\t ΑΣΕ ΤΟ ΚΟΥΤΙ ΚΑΙ ΤΟ ΣΧΟΙΝΙ
        
        \bΜπορείτε να χρησιμοποιήσετε την λέξη ΟΛΟΥΣ/ΟΛΕΣ/ΟΛΑ και ΤΑ ΠΑΝΤΑ για να αναφερθείτε σε όλα
        τα αντικείμενα που είναι συμβατά με την εντολή, και μπορείτε να χρησιμοποιήσετε την λέξη ΕΚΤΟΣ ή ΕΚΤΟΣ ΑΠΟ ή ΜΕ ΕΞΑΙΡΕΣΗ ή ΑΛΛΑ ΟΧΙ
        (αμέσως μετά την λέξη ΟΛΟΥΣ/ΟΛΕΣ/ΟΛΑ) για να εξαιρεθεί κάποιο αντικείμενο:

        \b
        \n\t ΠΑΡΕ ΤΑ ΟΛΑ
        \n\t ΒΑΛΕ ΤΑ ΠΑΝΤΑ ΕΚΤΟΣ ΑΠΟ ΤΟΝ ΔΙΣΚΟ ΚΑΙ ΤΟ ΣΧΟΙΝΙ ΜΕΣΑ ΣΤΟ ΚΟΥΤΙ
        \n\t ΠΑΡΕ ΤΑ ΠΑΝΤΑ ΑΠΟ ΤΟ ΚΟΥΤΙ
        \n\t ΠΑΡΕ ΤΑ ΠΑΝΤΑ ΑΠΟ ΤΟ ΡΑΦΙ

        \bΗ εντολή ΟΛΑ αναφέρεται σε όλα τα αντικείμενα που μπορούν λογικά να επηρεαστούν από την εντολή σας, 
		εξαιρουμένων των αντικειμένων που βρίσκονται μέσα σε άλλα αντικείμενα. Για παράδειγμα, εάν κρατάτε ένα κουτί 
		και ένα σχοινί και το κουτί περιέχει έναν δίσκο, η εντολή ΑΣΕ ΤΑ ΟΛΑ 
		θα ρίξει το κουτί και το σχοινί, αλλά η δισκέτα θα παραμείνει μέσα στο κουτί.

        \b<b><q>Αυτόν, Αυτήν , Αυτό, Τον, Την, Το</q> και <q>Αυτούς, Αυτές, Αυτά, Τους, Τις, Τα</q></b>
        \bΜπορείτε να χρησιμοποιήσετε τα ΑΥΤΟΝ/ΑΥΤΗΝ/ΑΥΤΟ/ΤΟΝ/ΤΗΝ/ΤΟ και ΑΥΤΟΥΣ/ΑΥΤΕΣ/ΑΥΤΑ/ΤΟΥΣ/ΤΙΣ/ΤΑ για να αναφερθείτε στο τελευταίο αντικείμενο ή αντικείμενα
        που χρησιμοποιήθηκαν σε μια εντολή:

        \b
        \n\t ΠΑΡΕ ΤΟ ΚΟΥΤΙ
        \n\t ΑΝΟΙΞΕ ΤΟ
        \n\t ΠΑΡΕ ΤΟΝ ΔΙΣΚΟ ΚΑΙ ΤΟ ΣΧΟΙΝΙ
        \n\t ΒΑΛΕ ΤΑ ΜΕΣΑ ΣΤΟ ΚΟΥΤΙ

        \b<b>Πολλές Εντολές Ταυτόχρονα</b>
        \bΜπορείτε να εισάγετε πολλαπλές εντολές σε μία γραμμή διαχωρίζοντάς τες με τελείες
		ή με την λέξη ΜΕΤΑ, ή με την λέξη ΕΠΕΙΤΑ, ή με την λέξη ΥΣΤΕΡΑ, ή με κόμμα, ή με κόμμα και μία από αυτές τις λέξεις, ή με ΚΑΙ 
		με μία από αυτές τις λέξεις. Για παράδειγμα:

        \b
        \n\t ΠΑΡΕ ΤΟΝ ΔΙΣΚΟ ΚΑΙ ΒΑΛΕ ΤΟΝ ΜΕΣΑ ΣΤΟ ΚΟΥΤΙ
        \n\t ΠΑΡΕ ΚΟΥΤΙ. ΑΝΟΙΞΕ ΤΟ.
        \n\t ΞΕΚΛΕΙΔΩΣΕ ΤΗΝ ΠΟΡΤΑ ΜΕ ΤΟ ΚΛΕΙΔΙ. ΑΝΟΙΞΕ ΤΗΝ, ΜΕΤΑ ΠΗΓΑΙΝΕ ΒΟΡΕΙΑ.

        \b Εάν το παιχνίδι δεν καταλαβαίνει μία από τις εντολές σας, 
		θα σας ενημερώσει για την άγνωστη εντολή και θα αγνοήσει το υπόλοιπο της γραμμής.";
    }

    /* General Tips chapter */
    showTipsChapter()
    {
        "\b<b>Μερικά Μυστικά</b>
        \bΤώρα που γνωρίζετε τις τεχνικές λεπτομέρειες για την εισαγωγή 
		εντολών, μπορεί να σας ενδιαφέρουν μερικές στρατηγικές συμβουλές. 
		Ακολουθούν μερικές τεχνικές που χρησιμοποιούν οι έμπειροι παίκτες παιχνιδιών Διαδραστικής Μυθοπλασίας 
		όταν προσεγγίζουν μια ιστορία.

        \bΕΠΕΞΕΡΓΑΣΟΥ τα πάντα, Ειδικά όταν εισέρχεστε σε μια νέα τοποθεσία, εξετάστε προσεκτικά τα αντικείμενα. 
		Συχνά θα ανακαλύψετε λεπτομέρειες που δεν αναφέρονται στην γενική περιγραφή της τοποθεσίας. Εάν η εξέταση 
		ενός αντικειμένου αναφέρει λεπτομερή μέρη του αντικειμένου, εξετάστε και αυτά.

        \bΔημιουργήστε έναν χάρτη της περιοχής, εάν το παιχνίδι περιλαμβάνει περισσότερες από λίγες τοποθεσίες. 
		Όταν συναντάτε μια νέα τοποθεσία για πρώτη φορά, σημειώστε όλες τις εξόδους της. Αυτό θα σας βοηθήσει 
		να δείτε εύκολα αν υπάρχουν έξοδοι που δεν έχετε εξερευνήσει ακόμα. Εάν κολλήσετε, μπορείτε να εξετάσετε 
		τον χάρτη σας για τυχόν ανεξερεύνητες περιοχές, όπου μπορεί να βρείτε αυτό που αναζητάτε.

        \bΕάν το παιχνίδι δεν αναγνωρίζει μια λέξη ή κάποιο συνώνυμό της, το αντικείμενο που προσπαθείτε να χειριστείτε 
		μάλλον δεν είναι σημαντικό για την ιστορία. Αν προσπαθήσετε να αλληλεπιδράσετε με κάτι και το παιχνίδι απαντήσει 
		με κάτι σαν <q>αυτό δεν είναι σημαντικό</q>, μπορείτε να αγνοήσετε το αντικείμενο. Πιθανότατα υπάρχει μόνο για να 
		περιγράψει καλύτερα το περιβάλλον.

        \bIΕάν προσπαθείτε να καταφέρετε κάτι και τίποτα από όσα κάνετε δεν φαίνεται να λειτουργεί, δώστε προσοχή στο τι πηγαίνει στραβά. 
		Εάν κάθε προσπάθειά σας απορρίπτεται κατηγορηματικά (<q>δεν συμβαίνει τίποτα</q> ή <q>αυτό δεν είναι κάτι που μπορείς να ανοίξεις</q>), 
		ίσως βρίσκεστε στο λάθος δρόμο. Βγείτε από τη συγκεκριμένη προσέγγιση και 
		σκεφτείτε άλλους τρόπους για να αντιμετωπίσετε το πρόβλημα. Εάν η απάντηση είναι 
		πιο συγκεκριμένη, μπορεί να αποτελεί ένα σημαντικό στοιχείο. Για παράδειγμα, 
		η φράση <q>TΟ φρουρός λέει <q>δεν μπορείς να το ανοίξεις αυτό εδώ!</q>\ και αρπάζει το κουτί από τα χέρια σου</q> &mdash;
        μπορεί να υποδεικνύει ότι πρέπει να κάνετε τον φρουρό να φύγει ή 
        ότι πρέπει να πάρετε το κουτί κάπου αλλού πριν το ανοίξετε.

        \bΕάν κολλήσετε εντελώς, δοκιμάστε να αφήσετε στην άκρη το τρέχον 
		πρόβλημα και να εργαστείτε σε κάτι άλλο για λίγο. Μπορείτε ακόμη και 
		να αποθηκεύσετε τη θέση σας και να κάνετε ένα διάλειμμα από το παιχνίδι. 
		Η λύση στο πρόβλημα που σας δυσκολεύει μπορεί να σας έρθει ξαφνικά σε μια 
		στιγμή έμπνευσης, και αυτές οι στιγμές έμπνευσης μπορούν να είναι εξαιρετικά ικανοποιητικές. 
		Μερικές ιστορίες απολαμβάνονται καλύτερα όταν παίζονται σε διάστημα ημερών, εβδομάδων ή ακόμα και μηνών. 
		Εάν απολαμβάνετε την ιστορία, γιατί να βιαστείτε;

        \bΤέλος, εάν όλα τα άλλα αποτύχουν, μπορείτε να ζητήσετε βοήθεια. Μια εξαιρετική πηγή για συμβουλές 
		είναι η ομάδα συζητήσεων Usenet
        <a href='news:rec.games.int-fiction'>rec.games.int-fiction</a>. ";

        "\n";
    }

    /* INSTRUCTIONS doesn't affect UNDO or AGAIN */
    isRepeatable = nil
    includeInUndo = nil
;


/* ------------------------------------------------------------------------ */
/*
 *   define the INSTRUCTIONS command's grammar 
 */
VerbRule(instructions) 'οδηγίες' : InstructionsAction
;


/* ------------------------------------------------------------------------ */
/*
 *   The instructions, rendered in menu form.  The menu format helps break
 *   up the instructions by dividing the instructions into chapters, and
 *   displaying a menu that lists the chapters.  This way, players can
 *   easily go directly to the chapters they're most interested in, but
 *   can also still read through the whole thing fairly easily.
 *   
 *   To avoid creating an unnecessary dependency on the menu subsystem for
 *   games that don't want the menu-style instructions, we'll only define
 *   the menu objects if the preprocessor symbol INSTRUCTIONS_MENU is
 *   defined.  So, if you want to use the menu-style instructions, just
 *   add -D INSTRUCTIONS_MENU to your project makefile.  
 */
#ifdef INSTRUCTIONS_MENU

/* a base class for the instruction chapter menus */
class InstructionsMenu: MenuLongTopicItem
    /* 
     *   present the instructions in "chapter" format, so that we can
     *   navigate from one chapter directly to the next 
     */
    isChapterMenu = true

    /* the InstructionsAction property that we invoke to show our chapter */
    chapterProp = nil

    /* don't use a heading, as we provide our own internal chapter titles */
    heading = ''

    /* show our chapter text */
    menuContents = (InstructionsAction.(self.chapterProp)())
;

InstructionsMenu template 'τίτλος' ->chapterProp;

/*
 *   The main instructions menu.  This can be used as a top-level menu;
 *   just call the 'display()' method on this object to display the menu.
 *   This can also be used as a sub-menu of any other menu, simply by
 *   inserting this menu into a parent menu's 'contents' list.  
 */
topInstructionsMenu: MenuItem 'Πώς να Παίξετε Παιχνίδι Διαδραστικής Μυθοπλασίας';

/* the chapter menus */
+ MenuLongTopicItem
    isChapterMenu = true
    title = 'Εισαγωγή'
    heading = nil
    menuContents()
    {
        "\b<b>Introduction</b>
        \bΚαλώς ήρθατε! Αν δεν έχετε παίξει ποτέ πριν παιχνίδια Διαδραστικής Μυθοπλασίας
        , αυτές οι οδηγίες θα σας βοηθήσουν να ξεκινήσετε. Εάν γνωρίζετε ήδη πώς να παίζετε 
		αυτό το είδος παιχνιδιού, μπορείτε πιθανώς να παραλείψετε τις πλήρεις οδηγίες, αλλά 
		μπορεί να θέλετε να πληκτρολογήσετε ABOUT στη γραμμή εντολών για μια περίληψη των ειδικών χαρακτηριστικών αυτής της ιστορίας.
        \b
        Για να διευκολυνθεί η πλοήγηση στις οδηγίες, αυτές έχουν χωριστεί σε κεφάλαια. ";

        if (curKeyList != nil && curKeyList.length() > 0)
            "Στο τέλος κάθε κεφαλαίου, πατήστε
            <b><<curKeyList[M_SEL][1].toUpper()>></b> 
			για να προχωρήσετε στο επόμενο κεφάλαιο ή <b><<curKeyList[M_PREV][1].toUpper()>></b>
            για να επιστρέψετε στη λίστα κεφαλαίων. ";
        else
            "Για να μετακινηθείτε μεταξύ των κεφαλαίων, κάντε κλικ στους συνδέσμους 
		ή χρησιμοποιήστε τα πλήκτρα βελών αριστερά/δεξιά. ";
    }
;

+ InstructionsMenu 'Εντολές Εισόδου' ->(&showCommandsChapter);
+ InstructionsMenu 'Συντομογραφίες Εντολών' ->(&showAbbrevChapter);
+ InstructionsMenu 'Ταξίδι' ->(&showTravelChapter);
+ InstructionsMenu 'Διαχείριση Αντικειμένων' ->(&showObjectsChapter);
+ InstructionsMenu 'Αλληλεπίδραση με άλλους Χαρακτήρες'
    ->(&showConversationChapter);
+ InstructionsMenu 'Ώρα' ->(&showTimeChapter);
+ InstructionsMenu 'Αποθήκευση και Ανάκτηση' ->(&showSaveRestoreChapter);
+ InstructionsMenu '¶λλες Ειδικές Εντολές' ->(&showSpecialCmdChapter);
+ InstructionsMenu '¶γνωστες λέξεις' ->(&showUnknownWordsChapter);
+ InstructionsMenu 'Ασαφείς Εντολές' ->(&showAmbiguousCmdChapter);
+ InstructionsMenu 'Προηγμένες Διατάξεις Εντολών' ->(&showAdvancedCmdChapter);
+ InstructionsMenu 'Μερικά Μυστικά' ->(&showTipsChapter);

#endif /* INSTRUCTIONS_MENU */

