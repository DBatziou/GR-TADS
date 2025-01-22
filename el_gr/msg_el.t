#charset "iso-8859-7"

/* 
 *   Copyright (c) 2000, 2006 Michael J. Roberts.  All Rights Reserved. 
 *
 *   TADS 3 Library - "neutral" messages for US English
 *
 *   This module provides standard library messages with a parser/narrator 
 *   that's as invisible (neutral) as possible.  These messages are designed 
 *   to reduce the presence of the computer as mediator in the story, to 
 *   give the player the most direct contact that we can with the scenario.
 *
 *   The parser almost always refers to itself in the third person (by 
 *   calling itself something like "this story") rather than in the first 
 *   person, and, whenever possible, avoids referring to itself in the first 
 *   place.  Our ideal phrasing is either second-person, describing things 
 *   directly in terms of the player character's experience, or "no-person," 
 *   simply describing things without mentioning the speaker or listener at 
 *   all.  For example, rather than saying "I don't see that here," we say 
 *   "you don't see that here," or "that's not here."  We occasionally stray 
 *   from this ideal where achieving it would be too awkward.
 *
 *   In the earliest days of adventure games, the parser was usually a 
 *   visible presence: the early parsers frequently reported things in the 
 *   first person, and some even had specific personalities.  This 
 *   conspicuous parser style has become less prevalent in modern games, 
 *   though, and authors now usually prefer to treat the parser as just 
 *   another part of the user interface, which like all good UI's is best 
 *   when the user doesn't notice it.  
 */

#include "adv3.h"
#include "el_gr.h"

/* ------------------------------------------------------------------------ */
/*
 *   Build a message parameter string with the given parameter type and
 *   name.
 *   
 *   This is useful when we have a name from a variable, and we need to
 *   build the message substitution string for embedding in a larger
 *   string.  We can't just embed the name variable using <<var>>, because
 *   that would process the output piecewise - the output filter needs to
 *   see the whole {typ var} expression in one go.  So, instead of writing
 *   this:
 *   
 *.     {The/he <<var>>} {is} ...
 *   
 *   write this:
 *   
 *.     <<buildParam('The/he', var)>> {is} ...
 */
buildParam(typeString, nm)
{
    return '{' + typeString + ' ' + nm + '}';
}

/*
 *   Synthesize a message parameter, and build it into a parameter string
 *   with the given substitution type.
 *   
 *   For example, buildSynthParam('abc', obj) returns '{abc xxx}', where
 *   'xxx' is a synthesized message parameter name (created using
 *   gSynthMessageParam) for the object obj.  
 */
buildSynthParam(typeString, obj)
{
    return '{' + typeString + ' ' + gSynthMessageParam(obj) + '}';
}


/* ------------------------------------------------------------------------ */
/*
 *   Library Messages 
 */
libMessages: MessageHelper
    /*
     *   The pronoun to use for the objective form of the personal
     *   interrogative pronoun.  Strictly speaking, the right word for
     *   this usage is "whom"; but regardless of what the grammar books
     *   say, most American English speakers these days use "who" for both
     *   the subjective and objective cases; to many ears, "whom" sounds
     *   old-fashioned, overly formal, or even pretentious.  (Case in
     *   point: a recent television ad tried to make a little kid look
     *   ultra-sophisticated by having him answer the phone by asking
     *   "*whom* may I ask is calling?", with elaborate emphasis on the
     *   "whom."  Of course, the correct usage in this case is "who," so
     *   the ad only made the kid look pretentious.  It goes to show that,
     *   at least in the mind of the writer of the ad, "whom" is just the
     *   snooty, formal version of "who" that serves only to signal the
     *   speaker's sophistication.)
     *   
     *   By default, we distinguish "who" and "whom."  Authors who prefer
     *   to use "who" everywhere can do so by changing this property's
     *   value to 'who'.  
     */
    whomPronoun = 'ποιον' //Αντί για το whom

    /*
     *   Flag: offer an explanation of the "OOPS" command when it first
     *   comes up.  We'll only show this the first time the player enters
     *   an unknown word.  If you never want to offer this message at all,
     *   simply set this flag to nil initially.
     *   
     *   See also oopsNote() below.  
     */
    offerOopsNote = true

    /*
     *   some standard commands for insertion into <a> tags - these are in
     *   the messages so they can translated along with the command set
     */
    commandLookAround = 'κοίτα τριγύρω'//αντί για look around
    commandFullScore = 'πλήρες σκορ'//αντί για full score
    
    /* announce a completely remapped action */
    announceRemappedAction(action)
    {
        return '<./p0>\n<.assume>' + action.getParticiplePhrase()
            + '<./assume>\n';
    }

    /*
     *   Get a string to announce an implicit action.  This announces the
     *   current global action.  'ctx' is an ImplicitAnnouncementContext
     *   object describing the context in which the message is being
     *   displayed.  
     */
    announceImplicitAction(action, ctx)
    {
        /* build the announcement from the basic verb phrase */
		
        return ctx.buildImplicitAnnouncement(action.getImplicitPhrase(ctx));
    }

    /*
     *   Announce a silent implied action.  This allows an implied action
     *   to work exactly as normal (including the suppression of a default
     *   response message), but without any announcement of the implied
     *   action. 
     */
    silentImplicitAction(action, ctx) { return ''; }

    /*
     *   Get a string to announce that we're implicitly moving an object to
     *   a bag of holding to make room for taking something new.  If
     *   'trying' is true, it means we want to phrase the message as merely
     *   trying the action, not actually performing it.  
     */
    announceMoveToBag(action, ctx)
    {
        /* build the announcement, adding an explanation */
        return ctx.buildImplicitAnnouncement(
            action.getImplicitPhrase(ctx) + ', για να δημιουργηθεί χώρος');
    }

    /* show a library credit (for a CREDITS listing) */
    showCredit(name, byline) { "<<name>> <<byline>>"; }

    /* show a library version number (for a VERSION listing) */
    showVersion(name, version) { "<<name>> version <<version>>"; }

    /* there's no "about" information in this game */
    noAboutInfo = "<.parser>Αυτή η ιστορία δεν έχει ΠΛΗΡΟΦΟΡΙΕΣ.<./parser> "

    /*
     *   Show a list state name - this is extra state information that we
     *   show for an object in a listing involving the object.  For
     *   example, a light source might add a state like "(providing
     *   light)".  We simply show the list state name in parentheses.  
     */
    showListState(state) { " (<<state>>)"; }

    /* a set of equivalents are all in a given state */
    allInSameListState(lst, stateName)
        { " (<<lst.length() == 2 ? 'και τα δύο' : 'όλα'>> <<stateName>>)"; }// αντί για both έβαλα 'και τα δύο' και αντί για all έβαλα 'όλα'
 
    /* generic long description of a Thing from a distance */
    distantThingDesc(obj)
    {
        gMessageParams(obj);
        "{Εσύ/Αυτός} δεν {βλέπω} τόσο μακριά για να γίνει διακριτή κάποια λεπτομέρεια. ";
    }
	
    /* generic long description of a Thing under obscured conditions */
    obscuredThingDesc(obj, obs)
    {
        gMessageParams(obj, obs);
        "{Εσύ/Αυτός} δεν {βλέπω} λεπτομέρειες μέσα από το {τον obs/αυτόν}. ";
    }

    /* generic "listen" description of a Thing at a distance */
    distantThingSoundDesc(obj)
        { "{Εσύ/Αυτός} δεν {ακούω} με λεπτομέρεια από αυτήν την απόσταση. "; }

    /* generic obscured "listen" description */
    obscuredThingSoundDesc(obj, obs)
    {
        gMessageParams(obj, obs);
        "{Εσύ/Αυτός} δεν {ακούω} με λεπτομέρεια μέσα από {τον obs/αυτόν}. ";
    }

    /* generic "smell" description of a Thing at a distance */
    distantThingSmellDesc(obj)
        { "{Εσύ/Αυτός} δεν {μυρίζω} κάτι από αυτήν την απόσταση. "; }

    /* generic obscured "smell" description */
    obscuredThingSmellDesc(obj, obs)
    {
        gMessageParams(obj, obs);
        "{Εσύ/Αυτός} δεν {μυρίζω} μέσα από {το obs/αυτόν}. ";
    }

    /* generic "taste" description of a Thing */
    thingTasteDesc(obj)
    {
        gMessageParams(obj);
        "{ο obj/αυτός} {έχει|είχε} την αναμενόμενη γεύση. ";
    }

    /* generic "feel" description of a Thing */
    thingFeelDesc(obj)
        { "{Εσύ/Αυτός} δεν {νιώθει} κάτι ασυνήθιστο. "; }

    /* obscured "read" description */
    obscuredReadDesc(obj)
    {
        gMessageParams(obj);
        "{Εσύ/Αυτός} δεν {βλέπω} {τον obj/αυτόν} αρκετά καλά για να {το/τον} {διαβάζω}. ";
    }

    /* dim light "read" description */
    dimReadDesc(obj)
    {
        gMessageParams(obj);
        "Δεν υπάρχει αρκετό φως για να {διαβάζω} {τον obj/αυτόν}. ";
    }

    /* lit/unlit match description */
    litMatchDesc(obj) { "\^<<obj.oName>> <<obj.verbEimai>> αναμ{-μένος-μένη-μένο}. "; }
    unlitMatchDesc(obj) { "\^<<obj.oName>> <<obj.verbEimai>> ένα κοινό σπίρτο. "; }

    /* lit candle description */
    litCandleDesc(obj) { "\^<<obj.oName>> <<obj.verbEimai>>> αναμ{-μένος-μένη-μένο}. "; }

    /*
     *   Prepositional phrases for putting objects into different types of
     *   objects. 
     */
    putDestContainer(obj) { return 'μέσα ' + obj.stonNameObj; }
    putDestSurface(obj) { return 'πάνω ' + obj.stonNameObj; }
    putDestUnder(obj) { return 'κάτω από ' + obj.tonNameObj; }
    putDestBehind(obj) { return 'πίσω από ' + obj.tonNameObj; }
    putDestFloor(obj) { return ' ' + obj.stonNameObj; }
    putDestRoom(obj) { return 'μέσα ' + obj.stonNameObj; }

    /* the list separator character in the middle of a list */
    listSepMiddle = ", "

    /* the list separator character for a two-element list */
    listSepTwo = " και "

    /* the list separator for the end of a list of at least three elements */
    listSepEnd = " και "

    /*
     *   the list separator for the middle of a long list (a list with
     *   embedded lists not otherwise set off, such as by parentheses) 
     */
    longListSepMiddle = "· " //the ; in greek is used for questions. 

    /* the list separator for a two-element list of sublists */
    longListSepTwo = " και "

    /* the list separator for the end of a long list */
    longListSepEnd = " και "

    /* show the basic score message */
    showScoreMessage(points, maxPoints, turns)
    {
        "Σε <<turns>> <<turns == 1 ? 'κίνηση' : 'κινήσεις'>>, 
		έχεις μαζέψει <<points>> από το μέγιστο που είναι <<maxPoints>> 
		<<maxPoints == 1 ? 'πόντος' : 'πόντοι'>>. ";
    }

    /* show the basic score message with no maximum */
    showScoreNoMaxMessage(points, turns)
    {
        "Σε <<turns>> <<turns == 1 ? 'κίνηση' : 'κινήσεις'>>, έχεις μαζέψει 
		<<points>> <<points == 1 ? 'πόντο' : 'πόντους'>>. ";
    }

    /* show the full message for a given score rank string */
    showScoreRankMessage(msg) { "Αυτό σε κάνει <<msg>>. "; }

    /*
     *   show the list prefix for the full score listing; this is shown on
     *   a line by itself before the list of full score items, shown
     *   indented and one item per line 
     */
    showFullScorePrefix = "Το σκορ σου αποτελείται από:"

    /*
     *   show the item prefix, with the number of points, for a full score
     *   item - immediately after this is displayed, we'll display the
     *   description message for the achievement 
     */
    fullScoreItemPoints(points)
    {
        "<<points>> <<points == 1 ? 'πόντος' : 'πόντοι'>> για ";
    }

    /* score change - first notification */
    firstScoreChange(delta)
    {
        scoreChange(delta);
        scoreChangeTip.showTip();
    }

    /* score change - notification other than the first time */
    scoreChange(delta)
    {
        "<.commandsep><.notification><<
        basicScoreChange(delta)>><./notification> ";
    }

    /*
     *   basic score change notification message - this is an internal
     *   service routine for scoreChange and firstScoreChange 
     */
    basicScoreChange(delta)
    {
        "Το <<aHref(commandFullScore, 'σκορ', 'Δείξε το πλήρες σκορ')>>
        σου <<delta > 0 ? 'αυξήθηκε' : 'μειώθηκε'>> κατά
        <<spellInt(delta > 0 ? delta : -delta)>>
        <<delta is in (1, -1) ? 'πόντο' : 'πόντους'>>.";
    }

    /* acknowledge turning tips on or off */
    acknowledgeTipStatus(stat)
    {
        "<.parser>Οι υποδείξεις <<stat ? 'ενεργοποιήθηκαν' : 'απενεργοποιήθηκαν'>>.<./parser> ";
    }

    /* describe the tip mode setting */
    tipStatusShort(stat)
    {
        "ΥΠΟΔΕΙΞΕΙΣ <<stat ? 'ΕΝΕΡΓΟΠΟΙΗΜΕΝΕΣ' : 'ΑΠΕΝΕΡΓΟΠΟΙΗΜΕΝΕΣ'>>";
    }

    /* get the string to display for a footnote reference */
    footnoteRef(num)
    {
        /* set up a hyperlink for the note that enters the "note n" command */
        return '<sup>[<<aHref('υποσημείωση ' + num, toString(num))>>]</sup>';
    }

    /* first footnote notification */
    firstFootnote()
    {
        footnotesTip.showTip();
    }

    /* there is no such footnote as the given number */
    noSuchFootnote(num)
    {
        "<.parser>Η ιστορία δεν έχει αναφερθεί ποτέ σε τέτοια υποσημείωση.<./parser> ";
    }

    /* show the current footnote status */
    showFootnoteStatus(stat)
    {
        "Η τρέχουσα ρύθμιση είναι ΥΠΟΣΗΜΕΙΩΣΕΙΣ ";
        switch(stat)
        {
        case FootnotesOff:
            "ΑΝΕΝΕΡΓΟ, που κρύβει όλες τις αναφορές σε υποσημειώσεις.
            Πληκτρολόγησε <<aHref('υποσημειώσεις στο μέτριο', 'ΥΠΟΣΗΜΕΙΩΣΕΙΣ ΣΤΟ ΜΕΤΡΙΟ', 'Θέσε τις υποσημειώσεις στο Μέτριο')>> 
			ώστε να βλέπεις τις αναφορές σε υποσημειώσεις εκτός από αυτές που έχεις ήδη δει, 
			or <<aHref('υποσημειώσεις στο πλήρες', 'ΥΠΟΣΗΜΕΙΩΣΕΙΣ ΣΤΟ ΠΛΗΡΕΣ', 'Θέσε τις υποσημειώσεις στο Πλήρες')>>
			για να εμφανίζονται όλες οι αναφορές, ακόμα και για υποσημειώσεις που έχουν ήδη διαβαστεί. ";
            break;

        case FootnotesMedium:
            "ΜΕΤΡΙΟ, το οποίο δείχνει αναφορές σε υποσημειώσεις που δεν έχουν διαβαστεί ήδη, αλλά
            κρύβει αναφορές σε αυτές που έχουν ήδη διαβαστεί.  
			Πληκτρολόγησε <<aHref('υποσημειώσεις στο ανενεργό', 'ΥΠΟΣΗΜΕΙΩΣΕΙΣ ΣΤΟ ΑΝΕΝΕΡΓΟ', 'Απενεργοποίησε τις υποσημειώσεις')>>  
			για να κρύψεις πλήρως τις αναφορές σε υποσημειώσεις,
			or <<aHref('υποσημειώσεις στο πλήρες', 'ΥΠΟΣΗΜΕΙΩΣΕΙΣ ΣΤΟ ΠΛΗΡΕΣ', 'Θέσε τις υποσημειώσεις στο Πλήρες')>> 
			για να εμφανίζονται όλες οι αναφορές, ακόμα και για υποσημειώσεις που έχουν ήδη διαβαστεί. ";
            break;

        case FootnotesFull:
            "ΠΛΗΡΕΣ, το οποίο δείχνει όλες τις αναφορές σε υποσημειώσεις, ακόμα και υποσημειώσεις που έχουν ήδη διαβαστεί.  
			Πληκτρολόγησε <<aHref('υποσημειώσεις στο μέτριο', 'ΥΠΟΣΗΜΕΙΩΣΕΙΣ ΣΤΟ ΜΕΤΡΙΟ', 'Θέσε τις υποσημειώσεις στο Μέτριο')>> 
			ώστε να βλέπεις τις αναφορές σε υποσημειώσεις εκτός από αυτές που έχουν ήδη διαβαστεί, 
			or <<aHref('υποσημειώσεις στο ανενεργό', 'ΥΠΟΣΗΜΕΙΩΣΕΙΣ ΣΤΟ ΑΝΕΝΕΡΓΟ', 'Απενεργοποίησε τις υποσημειώσεις')>> 
			για να κρύψεις πλήρως τις αναφορές σε υποσημειώσεις. ";
            break;
        }
    }

    /* acknowledge a change in the footnote status */
    acknowledgeFootnoteStatus(stat)
    {
        "<.parser>Η τρέχουσα ρύθμιση είναι
        <<shortFootnoteStatus(stat)>>.<./parser> ";
    }

    /* show the footnote status, in short form */
    shortFootnoteStatus(stat)
    {
        "ΥΠΟΣΗΜΕΙΩΣΕΙΣ <<
          stat == FootnotesOff ? 'ΑΝΕΝΕΡΓΟ'
          : stat == FootnotesMedium ? 'ΜΕΤΡΙΟ'
          : 'ΠΛΗΡΕΣ' >>";
    }

    /*
     *   Show the main command prompt.
     *   
     *   'which' is one of the rmcXxx phase codes indicating what kind of
     *   command we're reading.  This default implementation shows the
     *   same prompt for every type of input, but games can use the
     *   'which' value to show different prompts for different types of
     *   queries, if desired.  
     */
    mainCommandPrompt(which) { "\b&gt;"; }

    /*
     *   Show a pre-resolved error message string.  This simply displays
     *   the given string.  
     */
    parserErrorString(actor, msg) { say(msg); }

    /* show the response to an empty command line */
    emptyCommandResponse = "<.parser>Συγνώμη, τι είπες?<./parser> "

    /* invalid token (i.e., punctuation) in command line */
    invalidCommandToken(ch)
    {
        "<.parser>Η ιστορία δεν ξέρει πώς να χρησιμοποιήσει τον χαρακτήρα
        &lsquo;<<ch>>&rsquo; σε μια εντολή.<./parser> ";
    }

    /*
     *   Command group prefix - this is displayed after a command line and
     *   before the first command results shown after the command line.
     *   
     *   By default, we'll show the "zero-space paragraph" marker, which
     *   acts like a paragraph break in that it swallows up immediately
     *   following paragraph breaks, but doesn't actually add any space.
     *   This will ensure that we don't add any space between the command
     *   input line and the next text.  
     */
    commandResultsPrefix = '<.p0>'

    /*
     *   Command "interruption" group prefix.  This is displayed after an
     *   interrupted command line - a command line editing session that
     *   was interrupted by a timeout event - just before the text that
     *   interrupted the command line.
     *   
     *   By default, we'll show a paragraph break here, to set off the
     *   interrupting text from the command line under construction.  
     */
    commandInterruptionPrefix = '<.p>'

    /*
     *   Command separator - this is displayed after the results from a
     *   command when another command is about to be executed without any
     *   more user input.  That is, when a command line contains more than
     *   one command, this message is displayed between each successive
     *   command, to separate the results visually.
     *   
     *   This is not shown before the first command results after a
     *   command input line, and is not shown after the last results
     *   before a new input line.  Furthermore, this is shown only between
     *   adjacent commands for which output actually occurs; if a series
     *   of commands executes without any output, we won't show any
     *   separators between the silent commands.
     *   
     *   By default, we'll just start a new paragraph.  
     */
    commandResultsSeparator = '<.p>'

    /*
     *   "Complex" result separator - this is displayed between a group of
     *   messages for a "complex" result set and adjoining messages.  A
     *   command result list is "complex" when it's built up out of
     *   several generated items, such as object identification prefixes
     *   or implied command prefixes.  We use additional visual separation
     *   to set off these groups of messages from adjoining messages,
     *   which is especially important for commands on multiple objects,
     *   where we would otherwise have several results shown together.  By
     *   default, we use a paragraph break.  
     */
    complexResultsSeparator = '<.p>'

    /*
     *   Internal results separator - this is displayed to visually
     *   separate the results of an implied command from the results for
     *   the initiating command, which are shown after the results from
     *   the implied command.  By default, we show a paragraph break.
     */
    internalResultsSeparator = '<.p>'

    /*
     *   Command results suffix - this is displayed just before a new
     *   command line is about to be read if any command results have been
     *   shown since the last command line.
     *   
     *   By default, we'll show nothing extra.  
     */
    commandResultsSuffix = ''

    /*
     *   Empty command results - this is shown when we read a command line
     *   and then go back and read another without having displaying
     *   anything.
     *   
     *   By default, we'll return a message indicating that nothing
     *   happened.  
     */
    commandResultsEmpty =
        ('Δεν {συμβαίνει|συνέβη} τίποτα εμφανές ' + '.<.p>')

    /*
     *   Intra-command report separator.  This is used to separate report
     *   messages within a single command's results.  By default, we show
     *   a paragraph break.  
     */
    intraCommandSeparator = '<.p>'

    /*
     *   separator for "smell" results - we ordinarily show each item's
     *   odor description as a separate paragraph 
     */
    smellDescSeparator()
    {
        "<.p>";
    }

    /*
     *   separator for "listen" results 
     */
    soundDescSeparator()
    {
        "<.p>";
    }

    /* a command was issued to a non-actor */
    cannotTalkTo(targetActor, issuingActor)
    {
        "\^<<issuingActor.oName>> δεν μπορεί να μιλήσει <<targetActor.stonName>>. ";
    }

    /* greeting actor while actor is already talking to us */
    alreadyTalkingTo(actor, greeter)
    {
        "\^<<greeter.oName>> ήδη <<greeter.verbExo>>
        την προσοχή <<actor.touName>>. ";
    }

    /* no topics to suggest when we're not talking to anyone */
    noTopicsNotTalking = "<.parser>{Εσύ/Αυτός} δεν {μιλάω} σε κάποιον αυτήν την στιγμή.<./parser> "

    /*
     *   Show a note about the OOPS command.  This is, by default, added
     *   to the "I don't know that word" error the first time that error
     *   occurs.  
     */
    oopsNote()
    {
        oopsTip.showTip();
    }

    /* can't use OOPS right now */
    oopsOutOfContext = "<.parser>Μπορείς να χρησιμοποιήσεις την εντολή ΟΥΠΣ μόνο 
	για να διορθώσεις κάποιο ορθογραφικό λάθος αμέσως μετά την στιγμή 
	στην οποία η ιστορία δεν αναγνωρίζει μία λέξη.<./parser> "

    /* OOPS in context, but without the word to correct */
    oopsMissingWord = "<.parser>Για να χρησιμοποιήσεις την εντολή ΟΥΠΣ για να διορθώσεις ένα ορθογραφικό λάθος,
        βάλε την σωστή λέξη μετά το ΟΥΠΣ, όπως για παράδειγμα: ΟΥΠΣ βιβλίο.<./parser> "

    /* acknowledge setting VERBOSE mode (true) or TERSE mode (nil) */
    acknowledgeVerboseMode(verbose)
    {
        if (verbose)
            "<.parser>Η ΑΝΑΛΥΤΙΚΗ λειτουργία είναι επιλεγμένη.<./parser> ";
        else
            "<.parser>Η ΣΥΝΟΠΤΙΚΗ λειτουργία είναι επιλεγμένη.<./parser> ";
    }

    /* show the current VERBOSE setting, in short form */
    shortVerboseStatus(stat) { "<<stat ? 'ΑΝΑΛΥΤΙΚΗ' : 'ΣΥΝΟΠΤΙΚΗ'>> mode"; }

    /* show the current score notify status */
    showNotifyStatus(stat)
    {
        "<.parser>Οι ειδοποιήσεις για το σκορ είναι <<stat ? 'Ενεργοποιημένες' : 'Απενεργοποιημένες'>>.<./parser> ";
    }

    /* show the current score notify status, in short form */
    shortNotifyStatus(stat) { "ΕΙΔΟΠΟΙΗΣΗ <<stat ? 'ΕΝΕΡΓΟΠΟΙΗΜΕΝΗ' : 'ΑΠΕΝΕΡΓΟΠΟΙΗΜΕΝΗ'>>"; }

    /* acknowledge a change in the score notification status */
    acknowledgeNotifyStatus(stat)
    {
        "<.parser>Οι ειδοποιήσεις για το σκορ είναι πλέον
        <<stat ? 'Ενεργοποιημένες' : 'Απενεργοποιημένες'>>.<./parser> ";
    }

    /*
     *   Announce the current object of a set of multiple objects on which
     *   we're performing an action.  This is used to tell the player
     *   which object we're acting upon when we're iterating through a set
     *   of objects specified in a command targeting multiple objects.  
     */
    announceMultiActionObject(obj, whichObj, action)
    {
        /* 
         *   get the display name - we only need to differentiate this
         *   object from the other objects in the iteration 
         */
        local nm = obj.getAnnouncementDistinguisher(
            action.getResolvedObjList(whichObj)).name(obj);

        /* build the announcement */
        return '<./p0>\n<.announceObj>' + nm + ':<./announceObj> <.p0>';
    }

    /*
     *   Announce a singleton object that we selected from a set of
     *   ambiguous objects.  This is used when we disambiguate a command
     *   and choose an object over other objects that are also logical but
     *   are less likely.  In such cases, it's courteous to tell the
     *   player what we chose, because it's possible that the user meant
     *   one of the other logical objects - announcing this type of choice
     *   helps reduce confusion by making it immediately plain to the
     *   player when we make a choice other than what they were thinking.  
     */
    announceAmbigActionObject(obj, whichObj, action)
    {
        /* 
         *   get the display name - distinguish the object from everything
         *   else in scope, since we chose from a set of ambiguous options 
         */
        local nm = obj.getAnnouncementDistinguisher(gActor.scopeList())
            .tonName(obj);

        /* announce the object in "assume" style, ending with a newline */
        return '<.assume>' + nm + '<./assume>\n';
    }

    /*
     *   Announce a singleton object we selected as a default for a
     *   missing noun phrase.
     *   
     *   'resolvedAllObjects' indicates where we are in the command
     *   processing: this is true if we've already resolved all of the
     *   other objects in the command, nil if not.  We use this
     *   information to get the phrasing right according to the situation.
     */
    announceDefaultObject(obj, whichObj, action, resolvedAllObjects)
    {
        /*
         *   put the action's default-object message in "assume" style,
         *   and start a new line after it 
         */
        return '<.assume>'
            + action.announceDefaultObject(obj, whichObj, resolvedAllObjects)
            + '<./assume>\n';
    }

    /* 'again' used with no prior command */
    noCommandForAgain()
    {
        "<.parser>Δεν υπάρχει κάτι που μπορεί να επαναληφθεί.<./parser> ";
    }

    /* 'again' cannot be directed to a different actor */
    againCannotChangeActor()
    {
        "<.parser>Για να επαναληφθεί μια εντολή όπως π.χ. <q>turtle, go north,</q>
        απλά γράψε <q>again,</q> και όχι <q>turtle, again.</q><./parser> ";
    }

    /* 'again': can no longer talk to target actor */
    againCannotTalkToTarget(issuer, target)
    {
        "\^<<issuer.theName>> <<issuer.verbCannot>> να επαναλάβεις αυτήν την εντολή. ";
    }

    /* the last command cannot be repeated in the present context */
    againNotPossible(issuer)
    {
        "Αυτή η εντολή δεν μπορεί να επαναληφθεί τώρα. ";
    }

    /* system actions cannot be directed to non-player characters */
    systemActionToNPC()
    {
        "<.parser>Αυτή η εντολή δεν μπορεί να απευθύνεται σε άλλον χαρακτήρα της ιστορίας.<./parser> ";
    }

    /* confirm that we really want to quit */
    confirmQuit()
    {
        "Θες όντως να αποχωρήσεις;\ (<<aHref('ν', 'Ν', 'Επιβεβαίωση αποχώρησης')
        >> για να συμφωνήσεις) >\ ";
    }

    /*
     *   QUIT message.  We display this to acknowledge an explicit player
     *   command to quit the game.  This is the last message the game
     *   displays on the way out; there is no need to offer any options at
     *   this point, because the player has decided to exit the game.
     *   
     *   By default, we show nothing; games can override this to display an
     *   acknowledgment if desired.  Note that this isn't a general
     *   end-of-game 'goodbye' message; the library only shows this to
     *   acknowledge an explicit QUIT command from the player.  
     */
    okayQuitting() { }

    /*
     *   "not terminating" confirmation - this is displayed when the
     *   player doesn't acknowledge a 'quit' command with an affirmative
     *   response to our confirmation question 
     */
    notTerminating()
    {
        "<.parser>Η ιστορία συνεχίζεται.<./parser> ";
    }

    /* confirm that they really want to restart */
    confirmRestart()
    {
        "Θες όντως να επανεκκινήσεις το παιχνίδι;\ (<<aHref('ν', 'Ν',
        'Επιβεβαίωση επανεκκίνησης')>> για να συμφωνήσεις) >\ ";
    }

    /* "not restarting" confirmation */
    notRestarting() { "<.parser>Η ιστορία συνεχίζεται.<./parser> "; }

    /*
     *   Show a game-finishing message - we use the conventional "*** You
     *   have won! ***" format that text games have been using since the
     *   dawn of time. 
     */
    showFinishMsg(msg) { "<.p>*** <<msg>>\ ***<.p>"; }

    /* standard game-ending messages for the common outcomes */
    finishDeathMsg = '{Εσύ/Αυτός pc} <<withTenseAoristos>>{πεθαίνω}'
    finishVictoryMsg = ('{Εσύ/Αυτός pc} ' + tSel('<<withTenseParak>>{κερδίζω}','<<withTenseAoristos>>{κερδίζω}'))
    finishFailureMsg = ('{Εσύ/Αυτός pc} ' + tSel('<<withTenseParak>>{αποτυγχάνω}','<<withTenseAoristos>>{αποτυγχάνω}'))
    finishGameOverMsg = 'ΤΕΛΟΣ ΠΑΙΧΝΙΔΙΟΥ'

    /*
     *   Get the save-game file prompt.  Note that this must return a
     *   single-quoted string value, not display a value itself, because
     *   this prompt is passed to inputFile(). 
     */
    getSavePrompt = 'Αποθήκευση του παιχνιδιού στον φάκελο'

    /* get the restore-game prompt */
    getRestorePrompt = 'Επαναφορά παιχνιδιού από τον φάκελο'

    /* successfully saved */
    saveOkay() { "<.parser>Αποθηκεύτηκε.<./parser> "; }

    /* save canceled */
    saveCanceled() { "<.parser>Ακυρώθηκε.<./parser> "; }

    /* saved failed due to a file write or similar error */
    saveFailed(exc)
    {
        "<.parser>Αποτυχία. Ο χώρος στον δίσκο του υπολογιστή σου μπορεί να εξαντλείται 
		, ή ενδέχεται να μην έχεις τα απαραίτητα δικαιώματα για να γράψεις αυτό το αρχείο.<./parser> ";
    }

    /* save failed due to storage server request error */
    saveFailedOnServer(exc)
    {
        "<.parser>Απέτυχε, λόγω αδυναμίας πρόσβασης στον διακομιστή αποθήκευσης:
        <<makeSentence(exc.errMsg)>><./parser>";
    }

    /* 
     *   make an error message into a sentence, by capitalizing the first
     *   letter and adding a period at the end if it doesn't already have
     *   one 
     */
    makeSentence(msg)
    {
        return rexReplace(
            ['^<space>*[a-z]', '(?<=[^.?! ])<space>*$'], msg,
            [{m: m.toUpper()}, '.']);
    }

    /* note that we're restoring at startup via a saved-position launch */
    noteMainRestore() { "<.parser>Επαναφορά αποθηκευμένου παιχνιδιού...<./parser>\n"; }

    /* successfully restored */
    restoreOkay() { "<.parser>Αποκαταστάθηκε.<./parser> "; }

    /* restore canceled */
    restoreCanceled() { "<.parser>Ακυρώθηκε.<./parser> "; }

    /* restore failed due to storage server request error */
    restoreFailedOnServer(exc)
    {
        "<.parser>Απέτυχε, λόγω αδυναμίας πρόσβασης στον διακομιστή αποθήκευσης:
        <<makeSentence(exc.errMsg)>><./parser>";
    }

    /* restore failed because the file was not a valid saved game file */
    restoreInvalidFile()
    {
        "<.parser>Αποτυχία: αυτό δεν είναι έγκυρο αποθηκευμένο αρχείο θέσης.<./parser> ";
    }

    /* restore failed because the file was corrupted */
    restoreCorruptedFile()
    {
        "<.parser>Αποτυχία: Το αρχείο κατάστασης που αποθηκεύτηκε φαίνεται να είναι
        κατεστραμμένο. Αυτό μπορεί να συμβεί εάν το αρχείο τροποποιήθηκε από κάποιο άλλο
        πρόγραμμα, ή το αρχείο αντιγράφηκε μεταξύ υπολογιστών σε μη δυαδική
        λειτουργία μεταφοράς, ή τα φυσικά μέσα αποθήκευσης του αρχείου
        έχουν υποστεί βλάβη.<./parser> ";
    }

    /* restore failed because the file was for the wrong game or version */
    restoreInvalidMatch()
    {
        "<.parser>Αποτυχία: Το αρχείο δεν αποθηκεύτηκε από αυτήν τη
        ιστορία (ή αποθηκεύτηκε από μια μη συμβατή έκδοση της
        ιστορίας).<./parser> ";
    }

    /* restore failed for some reason other than those distinguished above */
    restoreFailed(exc)
    {
        "<.parser>Αποτυχία: Δεν ήταν δυνατή η ανάκτηση
        της θέσης.<./parser> ";
    }

    /* error showing the input file dialog (or character-mode equivalent) */
    filePromptFailed()
    {
        "<.parser>Συνέβη σφάλμα συστήματος κατά την αίτηση ονόματος αρχείου.
        Ο υπολογιστής σου ενδέχεται να έχει περιορισμένη διαθέσιμη μνήμη ή
        να υπάρχει πρόβλημα διαμόρφωσης.<./parser> ";
    }

    /* error showing the input file dialog, with a system error message */
    filePromptFailedMsg(msg)
    {
        "<.parser>Αποτυχία: <<makeSentence(msg)>><./parser> ";
    }

    /* Web UI inputFile error: uploaded file is too large */
    webUploadTooBig = 'Το επιλεγμένο αρχείο είναι πολύ μεγάλο για μεταφόρτωση.'

    /* PAUSE prompt */
    pausePrompt()
    {
        "<.parser>Η ιστορία είναι σε παύση. Παρακαλώ πίεσε το πλήκτρο
		διαστήματος όταν είσαι έτοιμος να συνεχίσεις την ιστορία, ή πίεσε το πλήκτρο &lsquo;S&rsquo;
		για να αποθηκεύσεις την τρέχουσα θέση.<./parser><.p>";
    }

    /* saving from within a pause */
    pauseSaving()
    {
        "<.parser>Αποθήκευση της ιστορίας...<./parser><.p>";
    }

    /* PAUSE ended */
    pauseEnded()
    {
        "<.parser>Η ιστορία συνεχίζεται.<./parser> ";
    }

    /* acknowledge starting an input script */
    inputScriptOkay(fname)
    {
        "<.parser>Ανάγνωση εντολών από <q><<
          File.getRootName(fname).htmlify()>></q>...<./parser>\n ";
    }

    /* error opening input script */
    inputScriptFailed = "<.parser>Αποτυχία: το αρχείο εισόδου σεναρίου δεν ήταν δυνατό να ανοίξει.<./parser> "
        
    /* exception opening input script */
    inputScriptFailedException(exc)
    {
        "<.parser>Αποτυχία: <<exc.displayException>><./parser> ";
    }

    /* get the scripting inputFile prompt message */
    getScriptingPrompt = 'Παρακαλώ επίλεξε ένα όνομα για το νέο αρχείο σεναρίου'

    /* acknowledge scripting on */
    scriptingOkay()
    {
        "<.parser>Το αποτέλεσμα θα αποθηκευτεί στο αρχείο.
        Πληκτρολόγησε <<aHref('σενάριο ανενεργό', 'ΣΕΝΑΡΙΟ ΑΝΕΝΕΡΓΟ', 'Απενεργοποίηση σεναρίου')>> για διακοπή 
		του σεναρίου.<./parser> ";
    }

    scriptingOkayWebTemp()
    {
        "<.parser>Το αποτέλεσμα θα αποθηκευτεί.
        Πληκτρολόγησε <<aHref('ανενεργό σενάριο', 'ΑΝΕΝΕΡΓΟ ΣΕΝΑΡΙΟ', 'Απενεργοποίηση σεναρίου')>> για διακοπή 
		του σεναρίου και για κατέβασμα του αποθηκευμένου αντιγράφου.<./parser> ";
    }

    /* scripting failed */
    scriptingFailed = "<.parser>Αποτυχία: συνέβη ένα σφάλμα κατά το άνοιγμα του αρχείου σεναρίου.<./parser> "

    /* scripting failed with an exception */
    scriptingFailedException(exc)
    {
        "<.parser>Αποτυχία: <<exc.displayException>><./parser>";
    }

    /* acknowledge cancellation of script file dialog */
    scriptingCanceled = "<.parser>Άκυρο.<./parser> "

    /* acknowledge scripting off */
    scriptOffOkay = "<.parser>Το σενάριο τερματίστηκε.<./parser> "

    /* SCRIPT OFF ignored because we're not in a script file */
    scriptOffIgnored = "<.parser>Δεν καταγράφεται κανένα σενάριο αυτή τη στιγμή.<./parser> "

    /* get the RECORD prompt */
    getRecordingPrompt = 'Παρακαλώ επίλεξε ένα όνομα για το νέο αρχείο καταγραφής εντολών'

    /* acknowledge recording on */
    recordingOkay = "<.parser>Οι εντολές τώρα θα καταγράφονται.  Πληκτρολόγησε
                     <<aHref('εγγραφή ανενεργή', 'ΕΓΓΡΑΦΗ ΑΝΕΝΕΡΓΗ',
                             'Απενεργοποίηση της εγγραφής')>>
                     για τερματισμό της εγγραφής.<.parser> "

    /* recording failed */
    recordingFailed = "<.parser>Αποτυχία: συνέβη ένα σφάλμα κατά το άνοιγμα 
	του αρχείου καταγραφής εντολών.<./parser> "

    /* recording failed with exception */
    recordingFailedException(exc)
    {
        "<.parser>Απέτυχε: <<exc.displayException()>><./parser> ";
    }

    /* acknowledge cancellation */
    recordingCanceled = "<.parser>Ακυρώθηκε.<./parser> "

    /* recording turned off */
    recordOffOkay = "<.parser>Η καταγραφή εντολών τερματίστηκε.<./parser> "

    /* RECORD OFF ignored because we're not recording commands */
    recordOffIgnored = "<.parser>Δεν γίνεται καμία καταγραφή εντολών αυτή τη στιγμή.<./parser> "

    /* REPLAY prompt */
    getReplayPrompt = 'Παρακαλώ επίλεξε το αρχείο καταγραφής εντολών που θα αναπαραχθεί.'

    /* REPLAY file selection canceled */
    replayCanceled = "<.parser>Ακυρώθηκε.<./parser> "

    /* undo command succeeded */
    undoOkay(actor, cmd)
    {
        "<.parser>Πηγαίνοντας ένα βήμα πίσω: <q>";

        /* show the target actor prefix, if an actor was specified */
        if (actor != nil)
            "<<actor>>, ";

        /* show the command */
        "<<cmd>></q>.<./parser><.p>";
    }

    /* undo command failed */
    undoFailed()
    {
        "<.parser>Δεν υπάρχουν περισσότερες πληροφορίες διαθέσιμες για προηγούμενες καταστάσεις.<./parser> ";
    }

    /* comment accepted, with or without transcript recording in effect */
    noteWithScript = "<.parser>Το σχόλιο καταγράφηκε.<./parser> "
    noteWithoutScript = "<.parser>Το σχόλιο <b>δεν</b> καταγράφηκε.<./parser> "

    /* on the first comment without transcript recording, warn about it */
    noteWithoutScriptWarning = "<.parser>Το σχόλιο <b>δεν</b> καταγράφηκε.
        Χρησιμοποίησε <<aHref('σενάριο', 'ΣΕΝΑΡΙΟ', 'Ξεκίνα την αποθήκευση του αντιγράφου')
          >> αν θέλεις να ξεκινήσεις την καταγραφή του εγγράφου.<./parser> "

    /* invalid finishGame response */
    invalidFinishOption(resp)
    {
        "\bΑυτή δεν είναι μία από τις επιλογές. ";
    }

    /* acknowledge new "exits on/off" status */
    exitsOnOffOkay(stat, look)
    {
        if (stat && look)
            "<.parser>Η λίστα των εξόδων θα εμφανίζεται τώρα τόσο στη γραμμή κατάστασης 
		όσο και σε κάθε περιγραφή δωματίου.<./parser> ";
        else if (!stat && !look)
            "<.parser>Η λίστα των εξόδων δεν θα εμφανίζεται πλέον ούτε στη γραμμή κατάστασης 
		ούτε στην περιγραφή του δωματίου.<./parser> ";
        else
            "<.parser>Η λίστα των εξόδων <<stat ? 'θα' : 'δεν θα'>> 
		εμφανίζεται τώρα στη γραμμή κατάστασης, και <<look ? 'θα' : 'δεν θα'>> 
		περιέχεται στην περιγραφή του δωματίου.<./parser> ";
    }

    /* explain how to turn exit display on and off */
    explainExitsOnOff()
    {
        exitsTip.showTip();
    }

    /* describe the current EXITS settings */
    currentExitsSettings(statusLine, roomDesc)
    {
        "ΕΞΟΔΟΙ ";
        if (statusLine && roomDesc)
            "ΕΝΕΡΓΟ";
        else if (statusLine)
            "ΓΡΑΜΜΗ ΚΑΤΑΣΤΑΣΗΣ";
        else if (roomDesc)
            "ΧΩΡΟΣ";
        else
            "ΑΝΕΝΕΡΓΟ";
    }

    /* acknowledge HINTS OFF */
    hintsDisabled = '<.parser>Η βοήθεια είναι πλέον ανενεργή.<./parser> '

    /* rebuff a request for hints when they've been previously disabled */
    sorryHintsDisabled = '<.parser>Συγνώμη, αλλά η βοήθεια έχει απενεργοποιηθεί για αυτήν τη συνεδρία, όπως ζήτησες. 
	Αν έχεις αλλάξει γνώμη, θα πρέπει να αποθηκεύσεις την τρέχουσα θέση, 
	να βγεις από τον διερμηνέα TADS και να ξεκινήσεις μια νέα συνεδρία διερμηνέα. <./parser> '

    /* this game has no hints */
    hintsNotPresent = '<.parser>Συγνώμη, αυτή η ιστορία δεν έχει καμία ενσωματωμένη βοήθεια.<./parser> '

    /* there are currently no hints available (but there might be later) */
    currentlyNoHints = '<.parser>Συγνώμη, δεν υπάρχει διαθέσιμη βοήθεια αυτή τη στιγμή. Παρακαλώ έλεγξε ξανά αργότερα.<./parser> '

    /* show the hint system warning */
    showHintWarning =
       "<.notification>Προειδοποίηση: Μερικοί άνθρωποι δεν συμπαθούν την ενσωματωμένη βοήθεια,
       καθώς δεν μπορούν να αντισταθούν στον πειρασμό του να ρωτήσουν για βοήθεια εκ των προτέρων
       όταν τα στοιχεία είναι τόσο εύκολα προσβάσιμα. Αν πιστεύεις ότι
       η αυτοσυγκράτησή σου δεν είναι ισχυρή, μπορείς να απενεργοποιήσεις την βοήθεια
	   για το υπόλοιπο αυτής της συνεδρίας πληκτρολογώντας <<aHref('βοήθεια ανενεργή ', 'ΒΟΗΘΕΙΑ ΑΝΕΝΕΡΓΗ')
       >>.  Αν ακόμα θέλεις να δείς την βοήθεια, πληκτρολόγησε
       <<aHref('βοήθεια', 'ΒΟΗΘΕΙΑ')>>.<./notification> "

    /* done with hints */
    hintsDone = '<.parser>Ολοκληρώθηκε.<./parser> '

    /* optional command is not supported in this game */
    commandNotPresent = "<.parser>Αυτή η εντολή δεν είναι χρήσιμη σε αυτήν την ιστορία.<./parser> "

    /* this game doesn't use scoring */
    scoreNotPresent = "<.parser>Αυτή η ιστορία δεν καταγράφει σκορ.<./parser> "

    /* mention the FULL SCORE command */
    mentionFullScore()
    {
        fullScoreTip.showTip();
    }

    /* SAVE DEFAULTS successful */
    savedDefaults()
    {
        "<.parser>Οι τρέχουσες ρυθμίσεις έχουν αποθηκευτεί 
		ως οι προεπιλεγμένες ρυθμίσεις για νέα παιχνίδια. 
		Οι αποθηκευμένες ρυθμίσεις είναι: ";

        /* show all of the settings */
        settingsUI.showAll();

        ".  Τα περισσότερα νεότερα παιχνίδια θα εφαρμόζουν αυτές τις ρυθμίσεις αυτόματα κάθε φορά που ξεκινάς (ή ΕΠΑΝΕΚΚΙΝΕΙΣ) το παιχνίδι, 
		αλλά έχε υπόψη ότι τα παλαιότερα παιχνίδια δεν θα κάνουν το ίδιο.<./parser> ";
    }

    /* RESTORE DEFAULTS successful */
    restoredDefaults()
    {
        "<.parser>Οι αποθηκευμένες προεπιλεγμένες ρυθμίσεις έχουν τεθεί σε ισχύ. 
		Οι νέες ρυθμίσεις είναι: ";

        /* show all of the settings */
        settingsUI.showAll();

        ".<./parser> ";
    }

    /* show a separator for the settingsUI.showAll() list */
    settingsItemSeparator = "; "

    /* SAVE/RESTORE DEFAULTS not supported (old interpreter version) */
    defaultsFileNotSupported = "<.parser>Συγνώμη, αλλά η έκδοση του διερμηνέα TADS που χρησιμοποιείτε δεν υποστηρίζει την αποθήκευση ή ανάκτηση των προεπιλεγμένων ρυθμίσεων. 
	Πρέπει να εγκαταστήσεΙς μια πιο πρόσφατη έκδοση για να χρησιμοποιήσεις αυτήν τη λειτουργία.<./parser> "

    /* RESTORE DEFAULTS file open/read error */
    defaultsFileReadError(exc)
    {
        "<.parser>Παρουσιάστηκε σφάλμα κατά την ανάγνωση του αρχείου προεπιλεγμένων ρυθμίσεων. 
		Οι γενικές προεπιλεγμένες ρυθμίσεις δεν μπορούν να ανακτηθούν.<./parser> ";
    }

    /* SAVE DEFAULTS file creation error */
    defaultsFileWriteError = "<.parser>Παρουσιάστηκε σφάλμα κατά την εγγραφή του αρχείου προεπιλεγμένων ρυθμίσεων.  
	Οι προεπιλεγμένες ρυθμίσεις δεν έχουν αποθηκευτεί. Μπορεί να υπάρχει έλλειψη χώρου στον δίσκο σου, 
	ή ενδέχεται να μην έχεις τα απαραίτητα δικαιώματα για να εγγράψεις το αρχείο.<./parser> "

    /*
     *   Command key list for the menu system.  This uses the format
     *   defined for MenuItem.keyList in the menu system.  Keys must be
     *   given as lower-case in order to match input, since the menu
     *   system converts input keys to lower case before matching keys to
     *   this list.  
     *   
     *   Note that the first item in each list is what will be given in
     *   the navigation menu, which is why the fifth list contains 'ENTER'
     *   as its first item, even though this will never match a key press.
     */
    menuKeyList = [
                   ['q'],
                   ['p', '[left]', '[bksp]', '[esc]'],
                   ['u', '[up]'],
                   ['d', '[down]'],
                   ['ENTER', '\n', '[right]', ' ']
                  ]

    /* link title for 'previous menu' navigation link */
    prevMenuLink = '<font size=-1>Προηγούμενο</font>'

    /* link title for 'next topic' navigation link in topic lists */
    nextMenuTopicLink = '<font size=-1>Επόμενο</font>'

    /*
     *   main prompt text for text-mode menus - this is displayed each
     *   time we ask for a keystroke to navigate a menu in text-only mode 
     */
    textMenuMainPrompt(keylist)
    {
        "\bΕπιλέξτε έναν αριθμό θέματος, ή πιέστε &lsquo;<<
        keylist[M_PREV][1]>>&rsquo; για το προηγούμενο μενού ή 
		&lsquo;<<keylist[M_QUIT][1]>>&rsquo; για τερματισμό:\ ";
    }

    /* prompt text for topic lists in text-mode menus */
    textMenuTopicPrompt()
    {
        "\bΠιέστε το πλήκτρο κενού διαστήματος για την εμφάνιση της επόμενης γραμμής,
        &lsquo;<b>P</b>&rsquo; για να πάτε στο προηγούμενο μενού, ή
        &lsquo;<b>Q</b>&rsquo; για τερματισμό.\b";
    }

    /*
     *   Position indicator for topic list items - this is displayed after
     *   a topic list item to show the current item number and the total
     *   number of items in the list, to give the user an idea of where
     *   they are in the overall list.  
     */
    menuTopicProgress(cur, tot) { " [<<cur>>/<<tot>>]"; }

    /*
     *   Message to display at the end of a topic list.  We'll display
     *   this after we've displayed all available items from a
     *   MenuTopicItem's list of items, to let the user know that there
     *   are no more items available.  
     */
    menuTopicListEnd = '[Τέλος]'

    /*
     *   Message to display at the end of a "long topic" in the menu
     *   system.  We'll display this at the end of the long topic's
     *   contents.  
     */
    menuLongTopicEnd = '[Τέλος]'

    /*
     *   instructions text for banner-mode menus - this is displayed in
     *   the instructions bar at the top of the screen, above the menu
     *   banner area 
     */
    menuInstructions(keylist, prevLink)
    {
        "<tab align=right ><b>\^<<keylist[M_QUIT][1]>></b>=Quit <b>\^<<
        keylist[M_PREV][1]>></b>=Προηγούμενο Μενού<br>
        <<prevLink != nil ? aHrefAlt('προηγούμενο', prevLink, '') : ''>>
        <tab align=right ><b>\^<<keylist[M_UP][1]>></b>=Πάνω <b>\^<<
        keylist[M_DOWN][1]>></b>=Κάτω <b>\^<<
        keylist[M_SEL][1]>></b>=Επιλογή<br>";
    }

    /* show a 'next chapter' link */
    menuNextChapter(keylist, title, hrefNext, hrefUp)
    {
        "Επόμενο: <<aHref(hrefNext, title)>>;
        <b>\^<<keylist[M_PREV][1]>></b>=<<aHref(hrefUp, 'Μενού')>>";
    }

    /*
     *   cannot reach (i.e., touch) an object that is to be manipulated in
     *   a command - this is a generic message used when we cannot
     *   identify the specific reason that the object is in scope but
     *   cannot be touched 
     */
    cannotReachObject(obj)
    {
        "{Εσύ/Αυτός} δεν {φτάνω} <<obj.tonNameObj>>. ";
    }

    /*
     *   cannot reach an object, because the object is inside the given
     *   container 
     */
    cannotReachContents(obj, loc)
    {
        gMessageParams(obj, loc);
        return '{Εσύ/Αυτός} δεν {φτάνω} {το obj/αυτόν} μέσα από '
               + '{the loc/αυτόν}. ';
    }

    /* cannot reach an object because it's outisde the given container */
    cannotReachOutside(obj, loc)
    {
        gMessageParams(obj, loc);
        return '{Εσύ/Αυτός} δεν {φτάνω} {το obj/αυτόν} μέσα από '
               + '{the loc/αυτόν}. ';
    }

    /* sound is coming from inside/outside a container */
    soundIsFromWithin(obj, loc)
    {
        "\^<<obj.oName>> {έρχομαι} μέσα από <<loc.tonNameObj>>. ";
		
		//appear<<obj.verbEndingSEd>> to be
        //coming from inside <<loc.theNameObj>>. ";
    }
    soundIsFromWithout(obj, loc)
    {
        "\^<<obj.oName>> {έρχομαι} έξω από <<loc.tonNameObj>>. ";
    }

    /* odor is coming from inside/outside a container */
    smellIsFromWithin(obj, loc)
    {
        "\^<<obj.oName>> {έρχομαι} μέσα από <<loc.tonNameObj>>. ";
    }
    smellIsFromWithout(obj, loc)
    {
        "\^<<obj.oName>> {έρχομαι} έξω από <<loc.tonNameObj>>. ";
    }

    /* default description of the player character */
    pcDesc(actor)
    {
        "\^<<actor.oName>> {φαίνομαι} ίδι{-ος-α-ο} όπως συνήθως. ";
    }

    /*
     *   Show a status line addendum for the actor posture, without
     *   mentioning the actor's location.  We won't mention standing, since
     *   this is the default posture.  
     */
    roomActorStatus(actor)
    {
        /* mention any posture other than standing */
        if (actor.posture != standing)
            " (<<actor.posture.participle>>)";
    }

    /* show a status line addendum: standing in/on something */
    actorInRoomStatus(actor, room)
        { " (<<actor.posture.participle>> <<room.actorInName>>)"; }

    /* generic short description of a dark room */
    roomDarkName = 'Μέσα στο σκοτάδι'

    /* generic long description of a dark room */
    roomDarkDesc = "{Είναι|Ήταν} σκοτεινά. "

    /*
     *   mention that an actor is here, without mentioning the enclosing
     *   room, as part of a room description 
     */
    roomActorHereDesc(actor)
    {
        "\^<<actor.nameIs>> <<actor.posture.participle>>
        <<tSel('εδώ', 'εκεί')>>. ";
    }

    /*
     *   mention that an actor is visible at a distance or remotely,
     *   without mentioning the enclosing room, as part of a room
     *   description 
     */
    roomActorThereDesc(actor)
    {
        "\^<<actor.nameIs>> <<actor.posture.participle>> κάπου κοντά. ";
    }

    /*
     *   Mention that an actor is in a given local room, as part of a room
     *   description.  This is used as a default "special description" for
     *   an actor.  
     */
    actorInRoom(actor, cont)
    {
        "\^<<actor.nameIs>> <<actor.posture.participle>>
        <<cont.actorInName>>. ";
    }

    /*
     *   Describe an actor as standing/sitting/lying on something, as part
     *   of the actor's EXAMINE description.  This is additional
     *   information added to the actor's description, so we refer to the
     *   actor with a pronoun ("He's standing here").  
     */
    actorInRoomPosture(actor, room)
    {
        "\^<<actor.itIs>> <<actor.posture.participle>>
        <<room.actorInName>>. ";
    }

    /*
     *   Describe an actor's posture, as part of an actor's "examine"
     *   description.  If the actor is standing, don't bother mentioning
     *   anything, as standing is the trivial default condition.  
     */
    roomActorPostureDesc(actor)
    {
        if (actor.posture != standing)
            "\^<<actor.itIs>> <<actor.posture.participle>>. ";
    }

    /*
     *   mention that the given actor is visible, at a distance or
     *   remotely, in the given location; this is used in room
     *   descriptions when an NPC is visible in a remote or distant
     *   location 
     */
    actorInRemoteRoom(actor, room, pov)
    {
        /* say that the actor is in the room, using its remote in-name */
        "\^<<actor.nameIs>> <<actor.posture.participle>>
        <<room.inRoomName(pov)>>. ";
    }

    /*
     *   mention that the given actor is visible, at a distance or
     *   remotely, in the given nested room within the given outer
     *   location; this is used in room descriptions 
     */
    actorInRemoteNestedRoom(actor, inner, outer, pov)
    {
        /*
         *   say that the actor is in the nested room, in the current
         *   posture, and add then add that we're in the outer room as
         *   well 
         */
        "\^<<actor.nameIs>> <<outer.inRoomName(pov)>>,
        <<actor.posture.participle>> <<inner.actorInName>>. ";
    }

    /*
     *   Prefix/suffix messages for listing actors in a room description,
     *   for cases when the actors are in the local room in a nominal
     *   container that we want to mention: "Bob and Bill are sitting on
     *   the couch."  
     */
    actorInGroupPrefix(posture, cont, lst) { "\^"; }
    actorInGroupSuffix(posture, cont, lst)
    {
        " <<lst.length() == 1 ? tSel('είναι', 'ήταν') : tSel('είναι', 'ήταν')>>
        <<posture.participle>> <<cont.actorInName>>. ";
    }

    /*
     *   Prefix/suffix messages for listing actors in a room description,
     *   for cases when the actors are inside a nested room that's inside
     *   a remote location: "Bob and Bill are in the courtyard, sitting on
     *   the bench." 
     */
    actorInRemoteGroupPrefix(pov, posture, cont, remote, lst) { "\^"; }
    actorInRemoteGroupSuffix(pov, posture, cont, remote, lst)
    {
        " <<lst.length() == 1 ? tSel('είναι', 'ήταν') : tSel('είναι', 'ήταν')>>
        <<remote.inRoomName(pov)>>, <<posture.participle>>
        <<cont.actorInName>>. ";
    }

    /*
     *   Prefix/suffix messages for listing actors in a room description,
     *   for cases when the actors' nominal container cannot be seen or is
     *   not to be stated: "Bob and Bill are standing here."
     *   
     *   Note that we don't always want to state the nominal container,
     *   even when it's visible.  For example, when actors are standing on
     *   the floor, we don't bother saying that they're on the floor, as
     *   that's stating the obvious.  The container will decide whether or
     *   not it wants to be included in the message; containers that don't
     *   want to be mentioned will use this form of the message.  
     */
    actorHereGroupPrefix(posture, lst) { "\^"; }
    actorHereGroupSuffix(posture, lst)
    {
        " <<lst.length() == 1 ? tSel('είναι', 'ήταν') : tSel('είναι', 'ήταν')>>
        <<posture.participle>> <<tSel('εδώ', 'εκεί')>>. ";
    }

    /*
     *   Prefix/suffix messages for listing actors in a room description,
     *   for cases when the actors' immediate container cannot be seen or
     *   is not to be stated, and the actors are in a remote location:
     *   "Bob and Bill are in the courtyard."  
     */
    actorThereGroupPrefix(pov, posture, remote, lst) { "\^"; }
    actorThereGroupSuffix(pov, posture, remote, lst)
    {
        " <<lst.length() == 1 ? tSel('είναι', 'ήταν') : tSel('είναι', 'ήταν')>>
        <<posture.participle>> <<remote.inRoomName(pov)>>. ";
    }

    /* a traveler is arriving, but not from a compass direction */
    sayArriving(traveler)
    {
        "\^<<traveler.travelerName(true)>> <<traveler.verbMpeno>>
        <<traveler.stonTravelerLocName>>. ";
    }

    /* a traveler is departing, but not in a compass direction */
    sayDeparting(traveler)
    {
        "\^<<traveler.travelerName(nil)>> <<traveler.verbFevgo>> από
        <<traveler.tonTravelerLocName>>. ";
    }

    /*
     *   a traveler is arriving locally (staying within view throughout the
     *   travel, and coming closer to the PC) 
     */
    sayArrivingLocally(traveler, dest)
    {
        "\^<<traveler.travelerName(true)>> <<traveler.verbMpeno>>
        <<traveler.stonTravelerLocName>>. ";
    }

    /*
     *   a traveler is departing locally (staying within view throughout
     *   the travel, and moving further away from the PC) 
     */
    sayDepartingLocally(traveler, dest)
    {
        "\^<<traveler.travelerName(true)>> <<traveler.verbFevgo>> από
        <<traveler.tonTravelerLocName>>. ";
    }

    /*
     *   a traveler is traveling remotely (staying within view through the
     *   travel, and moving from one remote top-level location to another) 
     */
    sayTravelingRemotely(traveler, dest)
    {
        "\^<<traveler.travelerName(true)>> <<traveler.verbPigaino>>
        <<traveler.stonTravelerLocName>>. ";
    }

    /* a traveler is arriving from a compass direction */
    sayArrivingDir(traveler, dirName)
    {
        "\^<<traveler.travelerName(true)>> <<traveler.verbMpeno>>
        <<traveler.stonTravelerRemoteLocName>> από τα <<dirName>>. ";
    }

    /* a traveler is leaving in a given compass direction */
    sayDepartingDir(traveler, dirName)
    {
        local nm = traveler.travelerRemoteLocName;
        
        "\^<<traveler.travelerName(nil)>> <<traveler.verbFevgo>>
        προς <<dirName>><<nm != '' ? ' από ' + nm : ''>>. ";
    }
    
    /* a traveler is arriving from a shipboard direction */
    sayArrivingShipDir(traveler, dirName)
    {
        "\^<<traveler.travelerName(true)>> enter<<traveler.verbEndingSEd>>
        <<traveler.travelerRemoteLocName>> από <<dirName>>. ";
    }

    /* a traveler is leaving in a given shipboard direction */
    sayDepartingShipDir(traveler, dirName)
    {
        local nm = traveler.tonTravelerRemoteLocName;
        
        "\^<<traveler.travelerName(nil)>> <<traveler.verbFevgo>>
        προς τα <<dirName>><<nm != '' ? ' από ' + nm : ''>>. ";
    }

    /* a traveler is going aft */
    sayDepartingAft(traveler)
    {
        local nm = traveler.tonTravelerRemoteLocName;
        
        "\^<<traveler.travelerName(nil)>> <<traveler.verbPigaino>>
        πίσω<<nm != '' ? ' από ' + nm : ''>>. ";
    }

    /* a traveler is going fore */
    sayDepartingFore(traveler)
    {
        local nm = traveler.tonTravelerRemoteLocName;

        "\^<<traveler.travelerName(nil)>> <<traveler.verbPigaino>>
         μπροστά<<nm != '' ? ' από ' + nm : ''>>. ";
    }

    /* a shipboard direction was attempted while not onboard a ship */
    notOnboardShip = "Αυτή η κατεύθυνση δεν {έχει|είχε} καμία σημασία σε {αυτό|εκείνο} το σημείο. "

    /* a traveler is leaving via a passage */
    sayDepartingThroughPassage(traveler, passage)
    {
        "\^<<traveler.travelerName(nil)>> <<traveler.verbFevgo>> από
        <<traveler.tonTravelerRemoteLocName>> μέσα από <<passage.tonNameObj>>. ";
    }

    /* a traveler is arriving via a passage */
    sayArrivingThroughPassage(traveler, passage)
    {
        "\^<<traveler.travelerName(true)>> <<traveler.verbMpeno>>
        <<traveler.stonTravelerRemoteLocName>> μέσα από <<passage.tonNameObj>>. ";
    }

    /* a traveler is leaving via a path */
    sayDepartingViaPath(traveler, passage)
    {
        "\^<<traveler.travelerName(nil)>> <<traveler.verbFevgo>> από
        <<traveler.tonTravelerRemoteLocName>> μέσω <<passage.touNameObj>>. ";
    }

    /* a traveler is arriving via a path */
    sayArrivingViaPath(traveler, passage)
    {
        "\^<<traveler.travelerName(true)>> <<traveler.verbMpeno>>
        <<traveler.stonTravelerRemoteLocName>> μέσω <<passage.touNameObj>>. ";
    }

    /* a traveler is leaving up a stairway */
    sayDepartingUpStairs(traveler, stairs)
    {
        "\^<<traveler.travelerName(nil)>> <<traveler.verbAnebaino>>
        <<stairs.tonNameObj>>. ";
    }

    /* a traveler is leaving down a stairway */
    sayDepartingDownStairs(traveler, stairs)
    {
        "\^<<traveler.travelerName(nil)>> <<traveler.verbKatebaino>>
        <<stairs.tonNameObj>>. ";
    }

    /* a traveler is arriving by coming up a stairway */
    sayArrivingUpStairs(traveler, stairs)
    {
        local nm = traveler.tontravelerRemoteLocName;

        "\^<<traveler.travelerName(true)>> <<traveler.verbAnebaino>>
        <<stairs.tonNameObj>> προς <<nm != '' ?  nm : ''>>. ";
    }

    /* a traveler is arriving by coming down a stairway */
    sayArrivingDownStairs(traveler, stairs)
    {
        local nm = traveler.tonTravelerRemoteLocName;

        "\^<<traveler.travelerName(true)>> <<traveler.verbKatebaino>>
        <<stairs.tonNameObj>> προς <<nm != '' ? nm : ''>>. ";
    }

    /* acompanying another actor on travel */
    sayDepartingWith(traveler, lead)
    {
        "\^<<traveler.travelerName(nil)>> {έρχομαι traveler}
        με <<lead.tonNameObj>>. ";
    }

    /*
     *   Accompanying a tour guide.  Note the seemingly reversed roles:
     *   the lead actor is the one initiating the travel, and the tour
     *   guide is the accompanying actor.  So, the lead actor is
     *   effectively following the accompanying actor.  It seems
     *   backwards, but really it's not: the tour guide merely shows the
     *   lead actor where to go, but it's up to the lead actor to actually
     *   initiate the travel.  
     */
    sayDepartingWithGuide(guide, lead)
    {
        "\^<<lead.oName>> {αφήνω lead}
        <<guide.tonNameObj>> να {δείχνω guide} τον σωστό δρόμο. ";
    }

    /* note that a door is being opened/closed remotely */
    sayOpenDoorRemotely(door, stat)
    {
        "Κάποιος <<stat ? '' + tSel('ανοίγει', 'άνοιξε')
                        : '' + tSel('κλείνει', 'έκλεισε')>>
        <<door.tonNameObj>> από την άλλη πλευρά. ";
    }

    /*
     *   open/closed status - these are simply adjectives that can be used
     *   to describe the status of an openable object 
     */
    openMsg(obj) { return obj.replaceEndings('ανοιχτ[-ός-ή-ό]'); }
    closedMsg(obj) { return obj.replaceEndings('κλειστ[-ός-ή-ό]'); }

    /* object is currently open/closed */
    currentlyOpen = '{Αυτός dobj} είναι ανοιχτ{-ός-ή-ό} αυτήν την στιγμή. '
    currentlyClosed = '{Αυτός dobj} είναι κλειστ{-ός-ή-ό} αυτήν την στιγμή. '

    /* stand-alone independent clause describing current open status */
    openStatusMsg(obj) { return obj.itIsContraction + ' ' + obj.openDesc; }
    /* locked/unlocked status - adjectives describing lock states */
    lockedMsg(obj) { return obj.replaceEndings('κλειδωμέν[-ος-η-ο]'); }
    unlockedMsg(obj) { return obj.replaceEndings('ξεκλείδωτ[-ος-η-ο]'); }

    /* object is currently locked/unlocked */
    currentlyLocked = '{Ο dobj/αυτός} {είμαι} αυτήν τη στιγμή κλειδωμέν{-ος-η-ο}. '
    currentlyUnlocked = '{Ο dobj/αυτός} {είμαι} αυτήν τη στιγμή ξεκλείδωτ{-ος-η-ο}. '

    /*
     *   on/off status - these are simply adjectives that can be used to
     *   describe the status of a switchable object 
     */
    onMsg(obj) { return obj.replaceEndings('ενεργ[-ός-ή-ό]'); }
    offMsg(obj) { return obj.replaceEndings('ανενεργ[-ός-ή-ό]'); }

    /* daemon report for burning out a match */
    matchBurnedOut(obj)
    {
        gMessageParams(obj);
        "{Ο obj/αυτός} σταμάτησε να καίγεται, και εξαφανίζεται σε ένα σύννεφο στάχτης. ";
    }

    /* daemon report for burning out a candle */
    candleBurnedOut(obj)
    {
        gMessageParams(obj);
        "{Ο obj/αυτός} έχει καεί σχεδόν ολοκληρωτικά για να μπορεί να ξαναχρησιμοποιηθεί, και τελικά σβήνει. ";
    }

    /* daemon report for burning out a generic fueled light source */
    objBurnedOut(obj)
    {
        gMessageParams(obj);
        "{Ο obj/αυτός} {σβήνω}. ";
    }

    /* 
     *   Standard dialog titles, for the Web UI.  These are shown in the
     *   title bar area of the Web UI dialog used for inputDialog() calls.
     *   These correspond to the InDlgIconXxx icons.  The conventional
     *   interpreters use built-in titles when titles are needed at all,
     *   but in the Web UI we have to generate these ourselves. 
     */
    dlgTitleNone = 'Σημείωση'
    dlgTitleWarning = 'Προειδοποίηση'
    dlgTitleInfo = 'Σημείωση'
    dlgTitleQuestion = 'Ερώτηση'
    dlgTitleError = 'Σφάλμα'

    /*
     *   Standard dialog button labels, for the Web UI.  These are built in
     *   to the conventional interpreters, but in the Web UI we have to
     *   generate these ourselves.  
     */
    dlgButtonOk = 'OK'
    dlgButtonCancel = 'Άκυρο'
    dlgButtonYes = 'Ναι'
    dlgButtonNo = 'Όχι'

    /* web UI alert when a new user has joined a multi-user session */
    webNewUser(name) { "\b[<<name>> έχει ενταχθεί στην συνεδρία.]\n"; }

    /*
     *   Warning prompt for inputFile() warnings generated when reading a
     *   script file, for the Web UI.  The interpreter normally displays
     *   these warnings directly, but in Web UI mode, the program is
     *   responsible, so we need localized messages.  
     */
    inputFileScriptWarning(warning, filename)
    {
        /* remove the two-letter error code at the start of the string */
        warning = warning.substr(3);

        /* build the message */
        return warning + ' Θέλετε να συνεχίσετε;';
    }
    inputFileScriptWarningButtons = [
        '&Ναι, να γίνει χρήση αυτού του φακέλου', '&Επιλογή άλλου φακέλου', '&Τερματισμός του σεναρίου']
;

/* ------------------------------------------------------------------------ */
/*
 *   Player Character messages.  These messages are generated when the
 *   player issues a regular command to the player character (i.e.,
 *   without specifying a target actor).  
 */
playerMessages: libMessages
    /* invalid command syntax */
    commandNotUnderstood(actor)
    {
        "<.parser>Η ιστορία δεν καταλαβαίνει αυτήν την εντολή.<./parser> ";
    }

    /* a special topic can't be used right now, because it's inactive */
    specialTopicInactive(actor)
    {
        "<.parser>Αυτή η εντολή δεν μπορεί να χρησιμοποιηθεί αυτήν τη στιγμή.<./parser> ";
    }

    /* no match for a noun phrase */
    noMatch(actor, action, txt) { action.noMatch(self, actor, txt); }

    /*
     *   No match message - we can't see a match for the noun phrase.  This
     *   is the default for most verbs. 
     */
    noMatchCannotSee(actor, txt)
        { "<<actor.oName>> δεν <<actor.verbBlepo>> <<txt>> {εδώ|εκεί}. "; }

    /*
     *   No match message - we're not aware of a match for the noun phrase.
     *   Some sensory actions, such as LISTEN TO and SMELL, use this
     *   variation instead of the normal version; the things these commands
     *   refer to tend to be intangible, so "you can't see that" tends to
     *   be nonsensical. 
     */
    noMatchNotAware(actor, txt)
        { "{Εσύ/Αυτός} δεν {γνωρίζω} κάτι σχετικό με <<txt>> {εδώ|εκεί}. "; }

    /* 'all' is not allowed with the attempted action */
    allNotAllowed(actor)
    {
        "<.parser>Η εντολή <q>Όλα</q> δεν μπορεί να χρησιμοποιηθεί με αυτό το ρήμα.<./parser> ";
    }

    /* no match for 'all' */
    noMatchForAll(actor)
    {
        "<.parser>{Εσύ/Αυτός} δεν {βλέπω} κάτι κατάλληλο {εδώ|εκεί}.<./parser> ";
    }

    /* nothing left for 'all' after removing 'except' items */
    noMatchForAllBut(actor)
    {
        "<.parser>{Εσύ/Αυτός} δεν {βλέπω} κάτι άλλο {εδώ|εκεί}.<./parser> ";
    }

    /* nothing left in a plural phrase after removing 'except' items */
    noMatchForListBut(actor) { noMatchForAllBut(actor); }

    /* no match for a pronoun */
    noMatchForPronoun(actor, typ, pronounWord)
    {
        /* show the message */
        "<.parser>Η λέξη <q><<pronounWord>></q> δεν αναφέρεται σε κάτι αυτήν τη στιγμή.<./parser> ";
    }

    /*
     *   Ask for a missing object - this is called when a command is
     *   completely missing a noun phrase for one of its objects.  
     */
    askMissingObject(actor, action, which)
    {
        reportQuestion('<.parser>\^' + action.whatObj(which)
                       + ' θέλεις '
                       + (actor.referralPerson == ThirdPerson
                          ? actor.oName : '')
                       + ' να '
                       + action.getQuestionInf(which) + ';<./parser> ');
    }

    /*
     *   An object was missing - this is called under essentially the same
     *   circumstances as askMissingObject, but in cases where interactive
     *   resolution is impossible and we simply wish to report the problem
     *   and do not wish to ask for help.
     */
    missingObject(actor, action, which)
    {
        "<.parser>Πρέπει να πεις πιο ξεκάθαρα για το <<action.whatObj(which)>> θέλεις
        <<actor.referralPerson == ThirdPerson ? actor.oName : ''>>
        να <<action.getQuestionInf(which)>>.<./parser> ";
    }

    /*
     *   Ask for a missing literal phrase. 
     */
    askMissingLiteral(actor, action, which)
    {
        /* use the standard missing-object message */
        askMissingObject(actor, action, which);
    }

    /*
     *   Show the message for a missing literal phrase.
     */
    missingLiteral(actor, action, which)
    {
        "<.parser>Παρακαλώ κάνε πιο ξεκάθαρο 
        το <<action.whatObj(which)>> να
        <<action.getQuestionInf(which)>>.  Προσπάθησε, για παράδειγμα,
        <<action.getQuestionInf(which)>> <q>κάτι</q>.<./parser> ";
    }

    /* reflexive pronoun not allowed */
    reflexiveNotAllowed(actor, typ, pronounWord)
    {
        "<.parser>Η ιστορία δεν καταλαβαίνει πως να χρησιμοποιήσει την λέξη
        <q><<pronounWord>></q> κατά αυτόν τον τρόπο.<./parser> ";
    }

    /*
     *   a reflexive pronoun disagrees in gender, number, or something
     *   else with its referent 
     */
    wrongReflexive(actor, typ, pronounWord)
    {
        "<.parser>Η ιστορία δεν καταλαβαίνει σε τι αναφέρεται η λέξη <q><<pronounWord>></q>.<./parser> ";
    }

    /* no match for a possessive phrase */
    noMatchForPossessive(actor, owner, txt)
    {
        "<.parser>\^{Ο owner/αυτός}
        δεν φαίνεται να έχει κάποιο τέτοιο αντικείμενο.<./parser> ";
    }

    /* no match for a plural possessive phrase */
    noMatchForPluralPossessive(actor, txt)
    {
        "<.parser>\^Αυτοί δεν <<tSel('φαίνεται', 'φάνηκε')>> να έχουν τέτοιο αντικείμενο.<./parser> ";
    }

    /* no match for a containment phrase */
    noMatchForLocation(actor, loc, txt)
    {
        "<.parser>\^{O actor/αυτός} δεν βλέπει <<loc.childInName(txt)>>.<./parser> ";
    }

    /* nothing in a container whose contents are specifically requested */
    nothingInLocation(actor, loc)
    {
        "<.parser>\^{O actor/αυτός} δεν βλέπει
        <<loc.childInName('τίποτα ασυνήθιστο')>>.<./parser> ";
    }

    /* no match for the response to a disambiguation question */
    noMatchDisambig(actor, origPhrase, disambigResponse)
    {
        /*
         *   show the message, leaving the <.parser> tag mode open - we
         *   always show another disambiguation prompt after this message,
         *   so we'll let the prompt close the <.parser> mode 
         */
        "<.parser>Αυτή δεν ήταν μία από τις επιλογές. ";
    }

    /* empty noun phrase ('take the') */
    emptyNounPhrase(actor)
    {
        "<.parser>Φαίνεται ότι κάποιες λέξεις έχουν παραληφθεί.<./parser> ";
    }

    /* 'take zero books' */
    zeroQuantity(actor, txt)
    {
        "<.parser>\^<<actor.oName>> δεν <<actor.verbBoro>> να κάνει κάτι τέτοιο σε μηδενική ποσότητα από κάτι.<./parser> ";
    }

    /* insufficient quantity to meet a command request ('take five books') */
    insufficientQuantity(actor, txt, matchList, requiredNum)
    {
        "<.parser>\^{O actor/αυτός} δεν βλέπει τόσα πολλά
        <<txt>> <<tSel('εδώ', 'εκεί')>>.<./parser> ";
    }

    /* a unique object is required, but multiple objects were specified */
    uniqueObjectRequired(actor, txt, matchList)
    {
        "<.parser>Δεν μπορείς να χρησιμοποιήσεις πολλά αντικείμενα {εδώ|εκεί}.<./parser> ";
    }

    /* a single noun phrase is required, but a noun list was used */
    singleObjectRequired(actor, txt)
    {
        "<.parser>Δεν επιτρέπονται πολλά αντικείμενα σε αυτήν την εντολή.<./parser> ";
    }

    /*
     *   The answer to a disambiguation question specifies an invalid
     *   ordinal ("the fourth one" when only three choices were offered).
     *   
     *   'ordinalWord' is the ordinal word entered ('fourth' or the like).
     *   'originalText' is the text of the noun phrase that caused the
     *   disambiguation question to be asked in the first place.  
     */
    disambigOrdinalOutOfRange(actor, ordinalWord, originalText)
    {
        /* leave the <.parser> tag open, for the re-prompt that will follow */
        "<.parser>Δεν υπήρχαν τόσες πολλές επιλογές. ";
    }

    /*
     *   Ask the canonical disambiguation question: "Which x do you
     *   mean...?".  'matchList' is the list of ambiguous objects with any
     *   redundant equivalents removed; and 'fullMatchList' is the full
     *   list, including redundant equivalents that were removed from
     *   'matchList'.
     *   
     *   If askingAgain is true, it means that we're asking the question
     *   again because we got an invalid response to the previous attempt
     *   at the same prompt.  We will have explained the problem, and now
     *   we're going to give the user another crack at the same response.
     *   
     *   To prevent interactive disambiguation, do this:
     *   
     *   throw new ParseFailureException(&ambiguousNounPhrase,
     *.  originalText, matchList, fullMatchList); 
     */
    askDisambig(actor, originalText, matchList, fullMatchList,
                requiredNum, askingAgain, dist)
    {
        /* mark this as a question report with a dummy report */
        reportQuestion('');
        
        /*
         *   Open the "<.parser>" tag, if we're not "asking again."  If we
         *   are asking again, we will already have shown a message
         *   explaining why we're asking again, and that message will have
         *   left us in <.parser> tag mode, so we don't need to open the
         *   tag again. 
         */
        if (!askingAgain)
            "<.parser>";
        
        /*
         *   the question varies depending on whether we want just one
         *   object or several objects in the final result 
         */
        if (requiredNum == 1)
        {
            /*
             *   One object needed - use the original text in the query.
             *   
             *   Note that if we're "asking again," we will have shown an
             *   additional message first explaining *why* we're asking
             *   again, and that message will have left us in <.parser>
             *   tag mode; so we need to close the <.parser> tag in this
             *   case, but we don't need to show a new one. 
             */
            if (askingAgain)
                "Ποιό εννοούσες,
                <<askDisambigList(matchList, fullMatchList, nil, dist)>>;";
            else
                "Ποιό <<originalText>> εννοείς,
                <<askDisambigList(matchList, fullMatchList, nil, dist)>>;";
        }
        else
        {
            /*
             *   Multiple objects required - ask by number, since we can't
             *   easily guess what the plural might be given the original
             *   text.
             *   
             *   As above, we only need to *close* the <.parser> tag if
             *   we're asking again, because we will already have shown a
             *   prompt that opened the tag in this case.  
             */
            if (askingAgain)
                "Ποιό <<spellInt(requiredNum)>> (από τα
                <<askDisambigList(matchList, fullMatchList, true, dist)>>)
                εννοείς;";
            else
                "Ποιο <<spellInt(requiredNum)>>
                (από τα <<askDisambigList(matchList, fullMatchList,
                                      true, dist)>>) εννοείς;";
        }

        /* close the <.parser> tag */
        "<./parser> ";
    }

    /*
     *   we found an ambiguous noun phrase, but we were unable to perform
     *   interactive disambiguation 
     */
    ambiguousNounPhrase(actor, originalText, matchList, fullMatchList)
    {
        "<.parser>Η ιστορία δεν γνωρίζει ποιο
        <<originalText>> εννοείς.<./parser> ";
    }

    /* the actor is missing in a command */
    missingActor(actor)
    {
        "<.parser>Πρέπει να είναι πιο ξεκάθαρο σε <<
        whomPronoun>> {θέλεις|ήθελες} να αναφερθείς.<./parser> ";
    }

    /* only a single actor can be addressed at a time */
    singleActorRequired(actor)
    {
        "<.parser>Μπορείτε να απευθυνθείτε μόνο σε ένα άτομο την φορά.<./parser> ";
    }

    /* cannot change actor mid-command */
    cannotChangeActor()
    {
        "<.parser>Δεν μπορείτε να απευθυνθείτε σε πάνω από έναν χαρακτήρα σε μία γραμμή εντολών σε αυτήν την ιστορία.<./parser> ";
    }

    /*
     *   tell the user they entered a word we don't know, offering the
     *   chance to correct it with "oops" 
     */
    askUnknownWord(actor, txt)
    {
        /* start the message */
        "<.parser>Η λέξη <q><<txt>></q> δεν είναι απαραίτητη σε αυτήν την ιστορία.<./parser> ";

        /* mention the OOPS command, if appropriate */
        oopsNote();
    }

    /*
     *   tell the user they entered a word we don't know, but don't offer
     *   an interactive way to fix it (i.e., we can't use OOPS at this
     *   point) 
     */
    wordIsUnknown(actor, txt)
    {
        "<.parser>Η ιστορία δεν καταλαβαίνει αυτήν την εντολή.<./parser> ";
    }

    /* the actor refuses the command because it's busy with something else */
    refuseCommandBusy(targetActor, issuingActor)
    {
        "\^<<targetActor.nameIs>> είναι απασχολημένος. ";
    }

    /* cannot speak to multiple actors */
    cannotAddressMultiple(actor)
    {
        "<.parser>\^<<actor.oName>> δεν μπορεί να αναφερθεί σε πολλά άτομα
		ταυτόχρονα.<./parser> ";
    }

    /* 
     *   Remaining actions on the command line were aborted due to the
     *   failure of the current action.  This is just a hook for the game's
     *   use, if it wants to provide an explanation; by default, we do
     *   nothing.  Note that games that override this will probably want to
     *   use a flag property so that they only show this message once -
     *   it's really only desirable to explain the the mechanism, not to
     *   flag it every time it's used.  
     */
    explainCancelCommandLine()
    {
    }
;

/* ------------------------------------------------------------------------ */
/*
 *   Non-Player Character (NPC) messages - parser-mediated format.  These
 *   versions of the NPC messages report errors through the
 *   parser/narrator.
 *   
 *   Note that a separate set of messages can be selected to report
 *   messages in the voice of the NPC - see npcMessagesDirect below.  
 */

/*
 *   Standard Non-Player Character (NPC) messages.  These messages are
 *   generated when the player issues a command to a specific non-player
 *   character. 
 */
npcMessages: playerMessages
    /* the target cannot hear a command we gave */
    commandNotHeard(actor)
    {
        "\^{O actor/αυτός} δεν απαντά. ";
    }

    /* no match for a noun phrase */
    noMatchCannotSee(actor, txt)
        { "\^{O actor/αυτός} δεν βλέπει <<txt>>. "; }
    noMatchNotAware(actor, txt)
        { "\^{O actor/αυτός} δεν ξέρει τίποτα για κανένα <<txt>>. "; }

    /* no match for 'all' */
    noMatchForAll(actor)
    {
        "<.parser>\^{O actor/αυτός} δεν βλέπει τίποτα κατάλληλο.<./parser> ";
    }

    /* nothing left for 'all' after removing 'except' items */
    noMatchForAllBut(actor)
    {
        "<.parser>\^{O actor/αυτός} δεν βλέπει τίποτα
        else.<./parser> ";
    }

    /* insufficient quantity to meet a command request ('take five books') */
    insufficientQuantity(actor, txt, matchList, requiredNum)
    {
        "<.parser>\^{O actor/αυτός} δεν βλέπει τόσ{-ος-η-ο} <<txt>>.<./parser> ";
    }

    /*
     *   we found an ambiguous noun phrase, but we were unable to perform
     *   interactive disambiguation 
     */
    ambiguousNounPhrase(actor, originalText, matchList, fullMatchList)
    {
        "<.parser>\^{O actor/αυτός} δεν ξέρει {ποιός}
        <<originalText>> εννοείς.<./parser> ";
    }

    /*
     *   Missing object query and error message templates 
     */
    askMissingObject(actor, action, which)
    {
        reportQuestion('<.parser>\^' + action.whatObj(which)
                       + ' θέλεις ' + actor.oNameObj + ' να '
                       + action.getQuestionInf(which) + ';<./parser> ');
    }
    missingObject(actor, action, which)
    {
        "<.parser>Πρέπει να κάνεις πιο σαφές <<action.whatObj(which)>> θέλεις <<actor.toNameObj>> να
        <<action.getQuestionInf(which)>>.<./parser> ";
    }

    /* missing literal phrase query and error message templates */
    missingLiteral(actor, action, which)
    {
        "<.parser>Πρέπει να κάνεις πιο σαφές για το <<action.whatObj(which)>>
        θέλεις <<actor.oNameObj>> να <<action.getQuestionInf(which)>>.
        Για παράδειγμα: <<actor.oName>>, <<action.getQuestionInf(which)>>
        <q>κάτι</q>.<./parser> ";
    }
;

/*
 *   Deferred NPC messages.  We use this to report deferred messages from
 *   an NPC to the player.  A message is deferred when a parsing error
 *   occurs, but the NPC can't talk to the player because there's no sense
 *   path to the player.  When this happens, the NPC queues the message
 *   for eventual delivery; when a sense path appears later that lets the
 *   NPC talk to the player, we deliver the message through this object.
 *   Since these messages describe conditions that occurred in the past,
 *   we use the past tense to phrase the messages.
 *   
 *   This default implementation simply doesn't report deferred errors at
 *   all.  The default message voice is the parser/narrator character, and
 *   there is simply no good way for the parser/narrator to say that a
 *   command failed in the past for a given character: "Bob looks like he
 *   didn't know which box you meant" just doesn't work.  So, we'll simply
 *   not report these errors at all.
 *   
 *   To report messages in the NPC's voice directly, modify the NPC's
 *   Actor object, or the Actor base class, to return
 *   npcDeferredMessagesDirect rather than this object from
 *   getParserMessageObj().  
 */
npcDeferredMessages: object
;

/* ------------------------------------------------------------------------ */
/*
 *   NPC messages, reported directly in the voice of the NPC.  These
 *   messages are not selected by default, but a game can use them instead
 *   of the parser-mediated versions by modifying the actor object's
 *   getParserMessageObj() to return these objects.  
 */

/*
 *   Standard Non-Player Character (NPC) messages.  These messages are
 *   generated when the player issues a command to a specific non-player
 *   character. 
 */
npcMessagesDirect: npcMessages
    /* no match for a noun phrase */
    noMatchCannotSee(actor, txt)
    {
        "\^<<actor.nameVerb('κοίτα')>> τριγύρω. <q>Δεν βλέπω καθόλου <<txt>>.</q> ";
    }
    noMatchNotAware(actor, txt)
    {
        "<q>Δεν γνωρίζω κάτι για  <<txt>>,</q> <<actor.nameSays>>. ";
    }

    /* no match for 'all' */
    noMatchForAll(actor)
    {
        "\^<<actor.nameSays>>, <q>Δεν βλέπω τίποτα κατάλληλο.</q> ";
    }

    /* nothing left for 'all' after removing 'except' items */
    noMatchForAllBut(actor)
    {
        "\^<<actor.nameSays>>, <q>Δεν βλέπω κάτι άλλο εδώ.</q> ";
    }

    /* 'take zero books' */
    zeroQuantity(actor, txt)
    {
        "\^<<actor.nameSays>>,
        <q>Δεν μπορώ να το κάνω αυτό όταν έχω μηδενική ποσότητα από ένα αντικείμενο.</q> ";
    }

    /* insufficient quantity to meet a command request ('take five books') */
    insufficientQuantity(actor, txt, matchList, requiredNum)
    {
        "\^<<actor.nameSays>>,
        <q>Δεν βλέπω τόσα πολλά <<txt>> εδώ.</q> ";
    }

    /* a unique object is required, but multiple objects were specified */
    uniqueObjectRequired(actor, txt, matchList)
    {
        "\^<<actor.nameSays>>,
        <q>Δεν μπορώ να χρησιμοποιήσω τόσα πολλά αντικείμενα κατά αυτόν τον τρόπο.</q> ";
    }

    /* a single noun phrase is required, but a noun list was used */
    singleObjectRequired(actor, txt)
    {
        "\^<<actor.nameSays>>,
        <q>Δεν μπορώ να χρησιμοποιήσω τόσα πολλά αντικείμενα κατά αυτόν τον τρόπο.</q> ";
    }

    /* no match for the response to a disambiguation question */
    noMatchDisambig(actor, origPhrase, disambigResponse)
    {
        /* leave the quote open for the re-prompt */
        "\^<<actor.nameSays>>,
        <q>Αυτή δεν ήταν μία από τις επιλογές. ";
    }

    /*
     *   The answer to a disambiguation question specifies an invalid
     *   ordinal ("the fourth one" when only three choices were offered).
     *   
     *   'ordinalWord' is the ordinal word entered ('fourth' or the like).
     *   'originalText' is the text of the noun phrase that caused the
     *   disambiguation question to be asked in the first place.  
     */
    disambigOrdinalOutOfRange(actor, ordinalWord, originalText)
    {
        /* leave the quote open for the re-prompt */
        "\^<<actor.nameSays>>,
        <q>Δεν υπήρχαν τόσες πολλές επιλογές. ";
    }

    /*
     *   Ask the canonical disambiguation question: "Which x do you
     *   mean...?".  'matchList' is the list of ambiguous objects with any
     *   redundant equivalents removed, and 'fullMatchList' is the full
     *   list, including redundant equivalents that were removed from
     *   'matchList'.  
     *   
     *   To prevent interactive disambiguation, do this:
     *   
     *   throw new ParseFailureException(&ambiguousNounPhrase,
     *.  originalText, matchList, fullMatchList); 
     */
    askDisambig(actor, originalText, matchList, fullMatchList,
                requiredNum, askingAgain, dist)
    {
        /* mark this as a question report */
        reportQuestion('');

        /* the question depends on the number needed */
        if (requiredNum == 1)
        {
            /* one required - ask with the original text */
            if (!askingAgain)
                "\^<<actor.nameVerb('ask')>>, <q>";
            
            "Ποιο <<originalText>> εννοείτε, <<
            askDisambigList(matchList, fullMatchList, nil, dist)>>?</q> ";
        }
        else
        {
            /*
             *   more than one required - we can't guess at the plural
             *   given the original text, so just use the number 
             */
            if (!askingAgain)
                "\^<<actor.nameVerb('ask')>>, <q>";
            
            "Ποια <<spellInt(requiredNum)>> (από <<
            askDisambigList(matchList, fullMatchList, true, dist)>>)
            εννοείς?</q> ";
        }
    }

    /*
     *   we found an ambiguous noun phrase, but we were unable to perform
     *   interactive disambiguation 
     */
    ambiguousNounPhrase(actor, originalText, matchList, fullMatchList)
    {
        "\^<<actor.nameSays>>,
        <q>Δεν ξέρω ποιο <<originalText>> εννοείς.</q> ";
    }

    /*
     *   Missing object query and error message templates 
     */
    askMissingObject(actor, action, which)
    {
        reportQuestion('\^' + actor.nameSays
                       + ', <q>\^' + action.whatObj(which)
                       + ' θέλεις να '
                       + action.getQuestionInf(which) + ';</q> ');
    }
    missingObject(actor, action, which)
    {
        "\^<<actor.nameSays>>,
        <q>Δεν γνωρίζω <<action.whatObj(which)>>
        που θέλεις να <<action.getQuestionInf(which)>>.</q> ";
    }
    missingLiteral(actor, action, which)
    {
        /* use the same message we use for a missing ordinary object */
        missingObject(actor, action, which);
    }

    /* tell the user they entered a word we don't know */
    askUnknownWord(actor, txt)
    {
        "\^<<actor.nameSays>>,
        <q>Δεν γνωρίζω τη λέξη <q><<txt>></q>.</q> ";
    }

    /* tell the user they entered a word we don't know */
    wordIsUnknown(actor, txt)
    {
        "\^<<actor.nameSays>>,
        <q>Έγινε χρήση μιας λέξης που δεν γνωρίζω.</q> ";
    }
;

/*
 *   Deferred NPC messages.  We use this to report deferred messages from
 *   an NPC to the player.  A message is deferred when a parsing error
 *   occurs, but the NPC can't talk to the player because there's no sense
 *   path to the player.  When this happens, the NPC queues the message
 *   for eventual delivery; when a sense path appears later that lets the
 *   NPC talk to the player, we deliver the message through this object.
 *   Since these messages describe conditions that occurred in the past,
 *   we use the past tense to phrase the messages.
 *   
 *   Some messages will never be deferred:
 *   
 *   commandNotHeard - if a command is not heard, it will never enter an
 *   actor's command queue; the error is given immediately in response to
 *   the command entry.
 *   
 *   refuseCommandBusy - same as commandNotHeard
 *   
 *   noMatchDisambig - interactive disambiguation will not happen in a
 *   deferred response situation, so it is impossible to have an
 *   interactive disambiguation failure.  
 *   
 *   disambigOrdinalOutOfRange - for the same reason noMatchDisambig can't
 *   be deferred.
 *   
 *   askDisambig - if we couldn't display a message, we definitely
 *   couldn't perform interactive disambiguation.
 *   
 *   askMissingObject - for the same reason that askDisambig can't be
 *   deferred
 *   
 *   askUnknownWord - for the same reason that askDisambig can't be
 *   deferred.  
 */
npcDeferredMessagesDirect: npcDeferredMessages
    commandNotUnderstood(actor)
    {
        "\^<<actor.nameSays>>,
        <q>Δεν κατάλαβα τι εννοούσες.</q> ";
    }

    /* no match for a noun phrase */
    noMatchCannotSee(actor, txt)
    {
        "\^<<actor.nameSays>>, <q>Δεν είδα καθόλου <<txt>>.</q> ";
    }
    noMatchNotAware(actor, txt)
    {
        "\^<<actor.nameSays>>, <q>Δεν γνώριζα κανένα <<txt>>.</q> ";
    }

    /* no match for 'all' */
    noMatchForAll(actor)
    {
        "\^<<actor.nameSays>>, <q>Δεν είδα κάτι κατάλληλο.</q> ";
    }

    /* nothing left for 'all' after removing 'except' items */
    noMatchForAllBut(actor)
    {
        "\^<<actor.nameSays>>,
        <q>Δεν είδα αυτό στο οποίο αναφερόσουν.</q> ";
    }

    /* empty noun phrase ('take the') */
    emptyNounPhrase(actor)
    {
        "\^<<actor.nameSays>>,
        <q>Κάποιες λέξεις παραλήφθηκαν.</q> ";
    }

    /* 'take zero books' */
    zeroQuantity(actor, txt)
    {
        "\^<<actor.nameSays>>,
        <q>Δεν κατάλαβα τι εννοούσες.</q> ";
    }

    /* insufficient quantity to meet a command request ('take five books') */
    insufficientQuantity(actor, txt, matchList, requiredNum)
    {
        "\^<<actor.nameSays>>,
        <q>Δεν είδα αρκετά <<txt>>.</q> ";
    }

    /* a unique object is required, but multiple objects were specified */
    uniqueObjectRequired(actor, txt, matchList)
    {
        "\^<<actor.nameSays>>,
        <q>Δεν κατάλαβα τι εννοούσες.</q> ";
    }

    /* a unique object is required, but multiple objects were specified */
    singleObjectRequired(actor, txt)
    {
        "\^<<actor.nameSays>>,
        <q>Δεν κατάλαβα τι θέλεις να πείς.</q> ";
    }

    /*
     *   we found an ambiguous noun phrase, but we were unable to perform
     *   interactive disambiguation 
     */
    ambiguousNounPhrase(actor, originalText, matchList, fullMatchList)
    {
        "\^<<actor.nameSays>>,
        <q>Δεν μπορούσα να καταλάβω σε ποιο <<originalText>> αναφερόσουν.</q> ";
    }

    /* an object phrase was missing */
    askMissingObject(actor, action, which)
    {
        reportQuestion('\^' + actor.nameSays
                       + ', <q>Δεν ήξερα '
                       + action.whatObj(which) + ' που ήθελες να '
                       + action.getQuestionInf(which) + '.</q> ');
    }

    /* tell the user they entered a word we don't know */
    wordIsUnknown(actor, txt)
    {
        "\^<<actor.nameSays>>,
        <q>Έγινε χρήση λέξης που δεν γνωρίζω.</q> ";
    }
;

/* ------------------------------------------------------------------------ */
/*
 *   Verb messages for standard library verb implementations for actions
 *   performed by the player character.  These return strings suitable for
 *   use in VerifyResult objects as well as for action reports
 *   (defaultReport, mainReport, and so on).
 *   
 *   Most of these messages are generic enough to be used for player and
 *   non-player character alike.  However, some of the messages either are
 *   too terse (such as the default reports) or are phrased awkwardly for
 *   NPC use, so the NPC verb messages override those.  
 */
playerActionMessages: MessageHelper
    /*
     *   generic "can't do that" message - this is used when verification
     *   fails because an object doesn't define the action ("doXxx")
     *   method for the verb 
     */
    cannotDoThatMsg = '{Εσύ/Αυτός} δεν {μπορώ} να  {κάνω} κάτι τέτοιο.<<withTensePresent>> '

    /* must be holding something before a command */
    mustBeHoldingMsg(obj)
    {
        gMessageParams(obj);
        return '{Εσύ/Αυτός} πρέπει να  {κρατάω} {τον obj/αυτόν} για να {κάνω} κάτι τέτοιο.<<withTensePresent>> ';
    }

    /* it's too dark to do that */
    tooDarkMsg = 'Είναι πολύ σκοτείνα για να πραγματοποιηθεί κάτι τέτοιο. '

    /* object must be visible */
    mustBeVisibleMsg(obj)
    {
        gMessageParams(obj);
        return '{Εσύ/Αυτός} δεν {μπορώ} να  {βλέπω} {τον obj/αυτόν}.<<withTensePresent>> ';
    }

    /* object can be heard but not seen */
    heardButNotSeenMsg(obj)
    {
        gMessageParams(obj);
        return '{Εσύ/Αυτός} {μπορώ} να  {ακούω} {έναν/μία obj}, αλλά δεν {μπορώ} να {τον/την/το obj}  {βλέπω}.<<withTensePresent>> ';
    }

    /* object can be smelled but not seen */
    smelledButNotSeenMsg(obj)
    {
        gMessageParams(obj);
        return '{Εσύ/Αυτός} {μπορώ} να  {μυρίζω} {έναν/μία obj}, αλλά δεν {μπορώ} να {τον/την/το obj}  {βλέπω}.<<withTensePresent>>. ';
    }

    /* cannot hear object */
    cannotHearMsg(obj)
    {
        gMessageParams(obj);
        return 'Δεν {μπορώ} να  {ακούω} {τον obj/αυτόν}.<<withTensePresent>> ';
    }

    /* cannot smell object */
    cannotSmellMsg(obj)
    {
        gMessageParams(obj);
        return 'Δεν {μπορώ} να  {μυρίζω} {τον obj/αυτόν}.<<withTensePresent>> ';
    }

    /* cannot taste object */
    cannotTasteMsg(obj)
    {
        gMessageParams(obj);
        return 'Δεν {μπορώ} να  {γεύομαι} {τον obj/αυτόν}.<<withTensePresent>> ';
    }

    /* must remove an article of clothing before a command */
    cannotBeWearingMsg(obj)
    {
        gMessageParams(obj);
        return '{Εσύ/Αυτός} πρέπει να  {βγάζω} {τον obj/αυτόν}
                πρωτού να {μπορώ actor} να {κάνω actor} κάτι τέτοιο.<<withTensePresent>> ';
    }

    /* all contents must be removed from object before doing that */
    mustBeEmptyMsg(obj)
    {
        gMessageParams(obj);
        return '{Εσύ/Αυτός} πρέπει να  {βγάζω} ό,τι υπάρχει μέσα {στον obj/σεαυτόν}
                πρωτού να {μπορώ actor} να {κάνω actor} κάτι τέτοιο.<<withTensePresent>>  ';
    }

    /* object must be opened before doing that */
    mustBeOpenMsg(obj)
    {
        gMessageParams(obj);
        return '{Εσύ/Αυτός} πρέπει να  {ανοίγω} {τον obj/αυτόν}
                πρωτού να {μπορώ actor} να {κάνω actor} κάτι τέτοιο.<<withTensePresent>> ';
    }

    /* object must be closed before doing that */
    mustBeClosedMsg(obj)
    {
        gMessageParams(obj);
        return '{Εσύ/Αυτός} πρέπει να  {κλείνω} {τον obj/αυτόν}
               πρωτού να {μπορώ actor} να {κάνω actor} κάτι τέτοιο.<<withTensePresent>> ';
    }

    /* object must be unlocked before doing that */
    mustBeUnlockedMsg(obj)
    {
        gMessageParams(obj);
        return '{Εσύ/Αυτός} πρέπει να  ξε{κλειδώνω} {τον obj/αυτόν}
                πρωτού να {μπορώ actor} να {κάνω actor} κάτι τέτοιο.<<withTensePresent>> ';
    }

    /* no key is needed to lock or unlock this object */
    noKeyNeededMsg = '{Ο dobj/αυτός} δεν φαίνεται να χρειάζεται κλειδί. '

    /* actor must be standing before doing that */
    mustBeStandingMsg = '{Εσύ/Αυτός} πρέπει να  {στέκομαι} πρωτού να {μπορώ} να {κάνω} κάτι τέτοιο.<<withTensePresent>> '

    /* must be sitting on/in chair */
    mustSitOnMsg(obj)
    {
        gMessageParams(obj);
        return '{Εσύ/Αυτός} πρέπει πρώτα να  {κάθομαι} {μέσα obj}.<<withTensePresent>> ';
    }

    /* must be lying on/in object */
    mustLieOnMsg(obj)
    {
        gMessageParams(obj);
        return '{Εσύ/Αυτός} πρέπει πρώτα να  {ξαπλώνω} {μέσα obj}.<<withTensePresent>> ';
    }

    /* must get on/in object */
    mustGetOnMsg(obj)
    {
        gMessageParams(obj);
        return '{Εσύ/Αυτός} πρέπει πρώτα να  {μπαίνω} {μέσα obj}.<<withTensePresent>> ';
    }

    /* object must be in loc before doing that */
    mustBeInMsg(obj, loc)
    {
        gMessageParams(obj, loc);
        return '{Ο obj/αυτός} πρέπει να  {είμαι} {μέσα loc} πρωτού να {μπορώ actor} να {κάνω actor} κάτι τέτοιο.<<withTensePresent>> ';
    }

    /* actor must be holding the object before we can do that */
    mustBeCarryingMsg(obj, actor)
    {
        gMessageParams(obj, actor);
        return 'Πρέπει να  {κρατάω actor} {τον obj/αυτόν}
            πρωτού να {μπορώ actor} να {κάνω actor} κάτι τέτοιο.<<withTensePresent>> ';
    }

    /* generic "that's not important" message for decorations */
    decorationNotImportantMsg(obj)
    {
        gMessageParams(obj);
        return '{Ο obj/αυτός} δεν {είμαι} σημαντικ{-ός-ή-ό}. ';
    }

    /* generic "you don't see that" message for "unthings" */
    unthingNotHereMsg(obj)
    {
        gMessageParams(obj);
        return '{Εσύ/Αυτός} δεν {βλέπω} {τον obj/αυτόν} {εδώ|εκεί}. ';
    }

    /* generic "that's too far away" message for Distant items */
    tooDistantMsg(obj)
    {
        gMessageParams(obj);
        return '{Ο obj/αυτός} {είμαι} πολύ μακριά. ';
    }

    /* generic "no can do" message for intangibles */
    notWithIntangibleMsg(obj)
    {
        gMessageParams(obj);
        return '{Εσύ/Αυτός} δεν {μπορώ} να  το {κάνω} αυτό {σεέναν/σεμία obj}. ';
    }

    /* generic failure message for varporous objects */
    notWithVaporousMsg(obj)
    {
        gMessageParams(obj);
        return '{Εσύ/Αυτός}  δεν {μπορώ} να  το {κάνω} αυτό {σεέναν/σεμία obj}. ';
    }

    /* look in/look under/look through/look behind/search vaporous */
    lookInVaporousMsg(obj)
    {
        gMessageParams(obj);
        return '{Εσύ/Αυτός} {βλέπω} μόνο {τον obj/αυτόν}. ';
    }

    /*
     *   cannot reach (i.e., touch) an object that is to be manipulated in
     *   a command - this is a generic message used when we cannot
     *   identify the specific reason that the object is in scope but
     *   cannot be touched 
     */
    cannotReachObjectMsg(obj)
    {
        gMessageParams(obj);
        return '{Εσύ/Αυτός} δεν {φτάνω} {τον obj/αυτόν}. ';
    }

    /* cannot reach an object through an obstructor */
    cannotReachThroughMsg(obj, loc)
    {
        gMessageParams(obj, loc);
        return '{Εσύ/Αυτός} δεν {φτάνω} {τον obj/αυτόν} μέσα από<<withTensePresent>> '
               + '{τον loc/αυτόν}. ';
    }

    /* generic long description of a Thing */
    thingDescMsg(obj)
    {
        gMessageParams(obj);
        return '{Εσύ/Αυτός} δεν {βλέπω} τίποτα ασυνήθιστο πάνω<<withTensePresent>> '
               + '{στον obj/σεαυτόν}. ';
    }

    /* generic LISTEN TO description of a Thing */
    thingSoundDescMsg(obj)
        { return '{Εσύ/Αυτός} δεν {ακούω} τίποτα ασυνήθιστο.<<withTensePresent>> '; }

    /* generic "smell" description of a Thing */
    thingSmellDescMsg(obj)
        { return '{Εσύ/Αυτός} δεν {μυρίζω} τίποτα ασυνήθιστο.<<withTensePresent>> '; }

    /* default description of a non-player character */
    npcDescMsg(npc)
    {
        gMessageParams(npc);
        return '{Εσύ/Αυτός} δεν {βλέπω} τίποτα ασυνήθιστο πάνω '
               + '{στον npc/σεαυτόν}. ';
    }

    /* generic messages for looking prepositionally */
    nothingInsideMsg =
        'Δεν υπάρχει τίποτα ασυνήθιστο μέσα {στον dobj/σεαυτόν}. '
    nothingUnderMsg =
        '{Εσύ/Αυτός} δεν {βλέπω} τίποτα ασυνήθιστο κάτω από {τον dobj/αυτόν}. '
    nothingBehindMsg =
        '{Εσύ/Αυτός} δεν {βλέπω} τίποτα ασυνήθιστο πίσω από {τον dobj/αυτόν}. '
    nothingThroughMsg =
        '{Εσύ/Αυτός} δεν {βλέπω} τίποτα μέσα από {τον dobj/αυτόν}. '

    /* this is an object we can't look behind/through */
    cannotLookBehindMsg = '{Εσύ/Αυτός} δεν {μπορώ} να  {βλέπω} πολλά πίσω από {τον dobj/αυτόν}.<<withTensePresent>> '
    cannotLookUnderMsg = '{Εσύ/Αυτός} δεν {μπορώ} να  {βλέπω} πολλά κάτω από {τον dobj/αυτόν}.<<withTensePresent>> '
    cannotLookThroughMsg = '{Εσύ/Αυτός} δεν {μπορώ} να  {βλέπω} μέσα από {τον dobj/αυτόν}.<<withTensePresent>> '

    /* looking through an open passage */
    nothingThroughPassageMsg = '{Εσύ/Αυτός} δεν {μπορώ} να  {βλέπω} πολλά μέσα από {τον dobj/αυτόν} απο αυτό το σημείο.<<withTensePresent>> '

    /* there's nothing on the other side of a door we just opened */
    nothingBeyondDoorMsg = 'Το άνοιγμα {του dobj/αυτού} δεν αποκαλύπτει τίποτα ενδιαφέρον. '

    /* there's nothing here with a specific odor */
    nothingToSmellMsg =
        'Δεν {μυρίζω actor} τίποτα ασυνήθιστο. '

    /* there's nothing here with a specific noise */
    nothingToHearMsg = 'Δεν {ακούω actor} τίποτα ασυνήθιστο. '

    /* a sound appears to be coming from a source */
    noiseSourceMsg(src)
    {
        return '{Ο dobj/αυτός} φαίνεται σαν να έρχεται από '
            + src.tonNameObj + '. ';
    }

    /* an odor appears to be coming from a source */
    odorSourceMsg(src)
    {
        return '{Ο dobj/αυτός} φαίνεται σαν να έρχεται από '
            + src.tonNameObj + '. ';
    }

    /* an item is not wearable */
    notWearableMsg =
        '{Ο dobj/αυτός} δεν {είμαι} κάτι που μπορεί να φορεθεί. '

    /* doffing something that isn't wearable */
    notDoffableMsg =
        '{Ο dobj/αυτός} δεν {είμαι} κάτι που μπορεί να αφαιρεθεί. '

    /* already wearing item */
    alreadyWearingMsg = 'Ήδη {φοράω actor} {τον dobj/αυτόν}. '

    /* not wearing (item being doffed) */
    notWearingMsg = '{Εσύ/Αυτός} δεν {φοράω} {τον dobj/αυτόν}. '

    /* default response to 'wear obj' */
    okayWearMsg = 'Εντάξει, τώρα {φοράω actor} {τον dobj/αυτόν}. '

    /* default response to 'doff obj' */
    okayDoffMsg = 'Εντάξει, {εσύ/αυτός} δεν {φοράω} πλέον {τον dobj/αυτόν}. '

    /* default response to open/close */
    okayOpenMsg = shortTMsg(
        'Ανοίχθηκε. ', '{Εσύ/Αυτός} {ανοίγω} {τον dobj/αυτόν}. ')
    okayCloseMsg = shortTMsg(
        'Έκλεισε. ', '{Εσύ/Αυτός} {κλείνω} {τον dobj/αυτόν}. ')

    /* default response to lock/unlock */
    okayLockMsg = shortTMsg(
        'Κλειδώθηκε. ', '{Εσύ/Αυτός} {κλειδώνω} {τον dobj/αυτόν}. ')
    okayUnlockMsg = shortTMsg(
        'Ξεκλειδώθηκε. ', '{Εσύ/Αυτός} ξε{κλειδώνω} {τον dobj/αυτόν}. ')

    /* cannot dig here */
    cannotDigMsg = '{Εσύ/Αυτός} δεν {έχω} κάποιον λόγο για να  {σκάβω} μέσα {στον dobj/σεαυτόν}.<<withTensePresent>> '

    /* not a digging implement */
    cannotDigWithMsg =
        '{Εσύ/Αυτός} δεν {βλέπω} κάποιον τρόπο με τον οποίο να μπορεί να χρησιμοποιηθεί {ο iobj/αυτός} σαν φτυάρι. '

    /* taking something already being held */
    alreadyHoldingMsg = '{Εσύ/Αυτός} ήδη {κουβαλάω} {τον dobj/αυτόν}. '

    /* actor taking self ("take me") */
    takingSelfMsg = '{Εσύ/Αυτός} δεν {μπορώ} να  {παίρνω} τον εαυτό {μου/σου/του}.<<withTensePresent>> '

    /* dropping an object not being carried */
    notCarryingMsg = '{Εσύ/Αυτός} δεν {κουβαλάω} {τον dobj/αυτόν}. '

    /* actor dropping self */
    droppingSelfMsg = '{Εσύ/Αυτός} δεν {μπορώ} να  {αφήνω} τον εαυτό {μου/σου/του} να πέσει.<<withTensePresent>> '

    /* actor putting self in something */
    puttingSelfMsg = '{Εσύ/Αυτός} δεν {μπορώ} να  {κάνω} κάτι τέτοιο στον εαυτό {μου/σου/του}.<<withTensePresent>> '

    /* actor throwing self */
    throwingSelfMsg = '{Εσύ/Αυτός} δεν {μπορώ} να  {ρίχνω} τον εαυτό {μου/σου/του}.<<withTensePresent>> '

    /* we can't put the dobj in the iobj because it's already there */
    alreadyPutInMsg = '{Ο dobj/αυτός} {είμαι} ήδη μέσα {στον iobj/σεαυτόν}. '

    /* we can't put the dobj on the iobj because it's already there */
    alreadyPutOnMsg = '{Ο dobj/αυτός} {είμαι} ήδη πάνω {στον iobj/σεαυτόν}. '

    /* we can't put the dobj under the iobj because it's already there */
    alreadyPutUnderMsg = '{Ο dobj/αυτός} {είμαι} ήδη κάτω από {τον iobj/αυτόν}. '

    /* we can't put the dobj behind the iobj because it's already there */
    alreadyPutBehindMsg = '{Ο dobj/αυτός} {είμαι} ήδη πίσω από {τον iobj/αυτόν}. '

    /*
     *   trying to move a Fixture to a new container by some means (take,
     *   drop, put in, put on, etc) 
     */
    cannotMoveFixtureMsg = '{Ο dobj/αυτός} δεν είναι δυνατό να μετακινηθεί. '

    /* trying to take a Fixture */
    cannotTakeFixtureMsg = '{Εσύ/Αυτός} δεν {μπορώ} να  {παίρνω} {τον dobj/αυτόν}.<<withTensePresent>>  '

    /* trying to put a Fixture in something */
    cannotPutFixtureMsg = '{Εσύ/Αυτός} δεν {μπορώ} να  {βάζω} {τον dobj/αυτόν} πουθενά.<<withTensePresent>>  '

    /* trying to take/move/put an Immovable object */
    cannotTakeImmovableMsg = '{Εσύ/Αυτός} δεν {μπορώ} να  {παίρνω} {τον dobj/αυτόν}.<<withTensePresent>> '
    cannotMoveImmovableMsg = '{Ο dobj/αυτός} δεν είναι δυνατό να μετακινηθεί. '
    cannotPutImmovableMsg = '{Εσύ/Αυτός} δεν {μπορώ} να  {βάζω} {τον dobj/αυτόν} πουθενά.<<withTensePresent>> '

    /* trying to take/move/put a Heavy object */
    cannotTakeHeavyMsg = '{Ο dobj/αυτός} {είμαι} πολύ βαρ{-ύς-ιά-ύ}. '
    cannotMoveHeavyMsg = '{Ο dobj/αυτός} {είμαι} πολύ βαρ{-ύς-ιά-ύ}. '
    cannotPutHeavyMsg = '{Ο dobj/αυτός} {είμαι} πολύ βαρ{-ύς-ιά-ύ}. '

    /* trying to move a component object */
    cannotMoveComponentMsg(loc)
    {
        return '{Ο dobj/αυτός} είναι μέρος ' + loc.touNameObj + '. ';
    }

    /* trying to take a component object */
    cannotTakeComponentMsg(loc)
    {
        return '{Εσύ/Αυτός} δεν {μπορώ} να  {τον/την/το dobj} {παίρνω}. '
            + '{Ο dobj/αυτός} είναι μέρος ' + loc.touNameObj + '. ';
    }

    /* trying to put a component in something */
    cannotPutComponentMsg(loc)
    {
        return '{Εσύ/Αυτός} δεν {μπορώ} να  {τον/την/το dobj} {βάζω} πουθενά. '
            + '{Ο dobj/αυτός} είναι μέρος ' + loc.touNameObj + '. ';
    }

    /* specialized Immovable messages for TravelPushables */
    cannotTakePushableMsg = '{Εσύ/Αυτός} δεν {μπορώ} να  {τον/την/το dobj} {παίρνω}, 
	αλλά {it actor/he} ίσως να  {μπορώ} να {τον/την/το dobj} {σπρώχνω} κάπου.<<withTensePresent>> '
    cannotMovePushableMsg = 'Δεν θα αποσκοπούσε σε κάτι η άσκοπη μετακίνηση {του dobj/αυτού}, αλλά ίσως {it actor/he}
        να  {μπορώ} νσ {τον/την/το dobj} {σπρώχνω actor} προς μια συγκεκριμένη κατεύθυνση.<<withTensePresent>> '
    cannotPutPushableMsg = '{Εσύ/Αυτός} δεν {μπορώ} να  {τον/την/το dobj} {βάζω} πουθενά,
       αλλά {it actor/he} ίσως να  {μπορώ} να {τον/την/το dobj} {σπρώχνω} κάπου.<<withTensePresent>> '

    /* can't take something while occupying it */
    cannotTakeLocationMsg = '{Εσύ/Αυτός} δεν {μπορώ} να  {τον/την/το dobj} {παίρνω} 
        ενώ {τον/την/το dobj} {χρησιμοποιώ}.<<withTensePresent>> '

    /* can't REMOVE something that's being held */
    cannotRemoveHeldMsg = 'Δεν υπάρχει κάτι από το οποίο να μπορεί να αφαιρεθεί {ο dobj/αυτός}. '

    /* default 'take' response */
    okayTakeMsg = shortTMsg(
        'Λήφθηκε. ', '{Εσύ/Αυτός} {παίρνω} {τον dobj/αυτόν}. ')

    /* default 'drop' response */
    okayDropMsg = shortTMsg(
        'Αφέθηκε. ', '{Εσύ/Αυτός} {αφήνω} {τον dobj/αυτόν} να πέσει. ')

    /* dropping an object */
    droppingObjMsg(dropobj)
    {
        gMessageParams(dropobj);
        return '{Εσύ/Αυτός} {αφήνω} {τον dropobj/αυτόν} να πέσει. ';
    }

    /* default receiveDrop suffix for floorless rooms */
    floorlessDropMsg(dropobj)
    {
        gMessageParams(dropobj);
        return '{αυτός dropobj} {πέφτει|έπεσε} κάτω σε σημείο που δεν φαίνεται. ';
    }

    /* default successful 'put in' response */
    okayPutInMsg = shortTIMsg(
        'Έγινε. ', '{Εσύ/Αυτός} {βάζω} {τον dobj/αυτόν} μέσα {στον iobj/σεαυτόν}. ')

    /* default successful 'put on' response */
    okayPutOnMsg = shortTIMsg(
        'Έγινε. ', '{Εσύ/Αυτός} {βάζω} {τον dobj/αυτόν} πάνω {στον iobj/σεαυτόν}. ')

    /* default successful 'put under' response */
    okayPutUnderMsg = shortTIMsg(
        'Έγινε. ', '{Εσύ/Αυτός} {βάζω} {τον dobj/αυτόν} κάτω από {τον iobj/αυτόν}. ')

    /* default successful 'put behind' response */
    okayPutBehindMsg = shortTIMsg(
        'Έγινε. ', '{Εσύ/Αυτός} {βάζω} {τον dobj/αυτόν} πίσω από {τον iobj/αυτόν}. ')

    /* try to take/move/put/taste an untakeable actor */
    cannotTakeActorMsg = '{Ο dobj/αυτός} δεν θα επιτρέψει σε {εσένα/αυτόν} να {κάνω} κάτι τέτοιο.'
    cannotMoveActorMsg = '{Ο dobj/αυτός} δεν θα επιτρέψει σε {εσένα/αυτόν} να {κάνω} κάτι τέτοιο. '
    cannotPutActorMsg = '{Ο dobj/αυτός} δεν θα επιτρέψει σε {εσένα/αυτόν} να {κάνω} κάτι τέτοιο. '
    cannotTasteActorMsg = '{Ο dobj/αυτός} δεν θα επιτρέψει σε {εσένα/αυτόν} να {κάνω} κάτι τέτοιο. '

    /* trying to take/move/put/taste a person */
    cannotTakePersonMsg =
        'Λογικά, αυτό δεν θα άρεσε {στον dobj/σεαυτόν}. '
    cannotMovePersonMsg =
        'Λογικά, αυτό δεν θα άρεσε {στον dobj/σεαυτόν}. '
    cannotPutPersonMsg =
        'Λογικά, αυτό δεν θα άρεσε {στον dobj/σεαυτόν}. '
    cannotTastePersonMsg =
        'Λογικά, αυτό δεν θα άρεσε {στον dobj/σεαυτόν}. '

    /* cannot move obj through obstructor */
    cannotMoveThroughMsg(obj, obs)
    {
        gMessageParams(obj, obs);
        return '{Εσύ/Αυτός} δεν {μπορώ} να  {μετακινώ} {τον obj/αυτόν} μέσα από '
               + '{τον obs/αυτόν}.<<withTensePresent>> ';
    }

    /* cannot move obj in our out of container cont */
    cannotMoveThroughContainerMsg(obj, cont)
    {
        gMessageParams(obj, cont);
        return '{Εσύ/Αυτός} δεν {μπορώ} να  {μετακινώ} {τον obj/αυτόν} μέσα από '
               + '{τον cont/αυτόν}.<<withTensePresent>> ';
    }

    /* cannot move obj because cont is closed */
    cannotMoveThroughClosedMsg(obj, cont)
    {
        gMessageParams(cont);
        return '{Εσύ/Αυτός} δεν {μπορώ} να  το {κάνω} αυτό διότι {ο cont/αυτός} είναι '
               + 'κλειστ{-ός-ή-ό}. ';
    }

    /* cannot fit obj into cont through cont's opening */
    cannotFitIntoOpeningMsg(obj, cont)
    {
        gMessageParams(obj, cont);
        return '{Εσύ/Αυτός} δεν {μπορώ} να  το {κάνω} αυτό διότι {ο obj/αυτός} είναι πολύ μεγάλ{-ος-η-ο} για να μπει μέσα {στον cont/σεαυτόν}.<<withTensePresent>> ';
    }

    /* cannot fit obj out of cont through cont's opening */
    cannotFitOutOfOpeningMsg(obj, cont)
    {
        gMessageParams(obj, cont);
        return '{Εσύ/Αυτός} δεν {μπορώ} να  το {κάνω} αυτό διότι {ο obj/αυτός} είναι πολύ μεγάλ{-ος-η-ο} για να βγει από {τον cont/αυτόν}.<<withTensePresent>> ';
    }

    /* actor 'obj' cannot reach in our out of container 'cont' */
    cannotTouchThroughContainerMsg(obj, cont)
    {
        gMessageParams(obj, cont);
        return '{Ο obj/αυτός} δεν {φτάνω} τίποτα μέσα από '
               + '{τον cont/αυτόν}. ';
    }

    /* actor 'obj' cannot reach through cont because cont is closed */
    cannotTouchThroughClosedMsg(obj, cont)
    {
        gMessageParams(obj, cont);
        return '{Ο obj/αυτός} δεν {μπορώ} να  το {κάνω} αυτό διότι
               {ο cont/αυτός} είναι κλειστ{-ός-ή-ό}.<<withTensePresent>> ';
    }

    /* actor cannot fit hand into cont through cont's opening */
    cannotReachIntoOpeningMsg(obj, cont)
    {
        gMessageParams(obj, cont);
        return 'Το χέρι {του obj/αυτού} δεν χωράει μέσα {στον cont/σεαυτόν}';
    }

    /* actor cannot fit hand into cont through cont's opening */
    cannotReachOutOfOpeningMsg(obj, cont)
    {
        gMessageParams(obj, cont);
        return 'Το χέρι {του obj/αυτού} δεν χωράει μέσα από {τον cont/αυτόν}. ';
    }

    /* the object is too large for the actor to hold */
    tooLargeForActorMsg(obj)
    {
        gMessageParams(obj);
        return '{Ο obj/αυτός} είναι πολύ μεγάλ{-ος-η-ο}. {Εσύ/Αυτός} δεν {μπορώ} να  {κρατάω}.<<withTensePresent>> ';
    }

    /* the actor doesn't have room to hold the object */
    handsTooFullForMsg(obj)
    {
        return 'Τα χέρια {μου/σου/του} {είναι|ήταν} γεμάτα για να κρατήσουν '
               + obj.tonNameObj + '. ';
    }

    /* the object is becoming too large for the actor to hold */
    becomingTooLargeForActorMsg(obj)
    {
        gMessageParams(obj);
        return '{Εσύ/Αυτός} δεν {μπορώ} να  {κάνω} κάτι τέτοιο διότι {ο obj/αυτός}
                θα γινόταν πολύ μεγάλ{-ος-η-ο} για να  {μπορώ actor} να το {κρατάω actor}.<<withTensePresent>>';
    }

    /* the object is becoming large enough that the actor's hands are full */
    handsBecomingTooFullForMsg(obj)
    {
        gMessageParams(obj);
        return '{Εσύ/Αυτός} δεν {μπορώ} να  {κάνω} κάτι τέτοιο διότι τα χέρια {μου/σου/του} θα γέμισουν και δεν θα χωράνε {τον obj/αυτόν}. ';
    }

    /* the object is too heavy (all by itself) for the actor to hold */
    tooHeavyForActorMsg(obj)
    {
        gMessageParams(obj);
        return '{Ο obj/αυτός} είναι πολύ βαρ{-ύς-ιά-ύ} για {εσένα/αυτόν}. ';
    }

    /*
     *   the object is too heavy (in combination with everything else
     *   being carried) for the actor to pick up 
     */
    totalTooHeavyForMsg(obj)
    {
        gMessageParams(obj);
        return '{Ο obj/αυτός} είναι πολύ βαρ{-ύς-ιά-ύ}. {Εσύ/αυτός} πρέπει να  {αφήνω} κάτι κάτω πρώτα.<<withTensePresent>> ';
    }

    /* object is too large for container */
    tooLargeForContainerMsg(obj, cont)
    {
        gMessageParams(obj, cont);
        return '{Ο obj/αυτός} είναι πολύ μεγάλ{-ος-η-ο} για {τον cont/αυτόν}. ';
    }

    /* object is too large to fit under object */
    tooLargeForUndersideMsg(obj, cont)
    {
        gMessageParams(obj, cont);
        return '{Ο obj/αυτός} είναι πολύ μεγάλ{-ος-η-ο} για να μπει κάτω από {τον cont/αυτόν}. ';
    }

    /* object is too large to fit behind object */
    tooLargeForRearMsg(obj, cont)
    {
        gMessageParams(obj, cont);
        return '{Ο obj/αυτός} είναι πολύ μεγάλ{-ος-η-ο} για να μπει πίσω από {τον cont/αυτόν}. ';
    }

    /* container doesn't have room for object */
    containerTooFullMsg(obj, cont)
    {
        gMessageParams(obj, cont);
        return '{Ο cont/αυτός} {είμαι} ήδη γεμάτ{-ος-η-ο} για να χωρέσει {τον obj/αυτόν}. ';
    }

    /* surface doesn't have room for object */
    surfaceTooFullMsg(obj, cont)
    {
        gMessageParams(obj, cont);
        return 'Δεν {υπάρχει |υπήρχε} χώρος για {τον obj/αυτόν} πάνω '
               + '{στον cont/σεαυτόν}. ';
    }

    /* underside doesn't have room for object */
    undersideTooFullMsg(obj, cont)
    {
        gMessageParams(obj, cont);
        return 'Δεν {υπάρχει |υπήρχε} χώρος για {τον obj/αυτόν} κάτω από '
               + '{τον cont/αυτόν}. ';
    }

    /* rear surface/space doesn't have room for object */
    rearTooFullMsg(obj, cont)
    {
        gMessageParams(obj, cont);
        return 'Δεν {υπάρχει |υπήρχε} χώρος για {τον obj/αυτόν} πίσω από '
               + '{τον cont/αυτόν}. ';
    }

    /* the current action would make obj too large for its container */
    becomingTooLargeForContainerMsg(obj, cont)
    {
        gMessageParams(obj, cont);
        return '{Εσύ/Αυτός} δεν {μπορώ} να  {κάνω} κάτι τέτοιο διότι θα έκανε {τον obj/αυτόν} πολύ <<withListCaseAccusative>>μεγάλ{-ος-η-ο} για {τον cont/αυτόν}.<<withTensePresent>> ';
    }

    /*
     *   the current action would increase obj's bulk so that container is
     *   too full 
     */
    containerBecomingTooFullMsg(obj, cont)
    {
        gMessageParams(obj, cont);
        return '{Εσύ/Αυτός} δεν {μπορώ} να  {κάνω} κάτι τέτοιο διότι {ο obj/αυτός}
            δεν θα χωρούσε πια μέσα {στον cont/σεαυτόν}.<<withTensePresent>> ';
    }

    /* trying to put an object in a non-container */
    notAContainerMsg = '{Εσύ/Αυτός} δεν {μπορώ} να  {βάζω} τίποτα μέσα {στον iobj/σεαυτόν}.<<withTensePresent>> '

    /* trying to put an object on a non-surface */
    notASurfaceMsg = '{Ο iobj/αυτός} δεν έχει κάποια επιφάνεια στην οποία να μπορεί να τοποθετηθεί κάτι.<<withTensePresent>> '

    /* can't put anything under iobj */
    cannotPutUnderMsg =
        '{Εσύ/Αυτός} δεν {μπορώ} να  {βάζω} τίποτα κάτω από {τον iobj/αυτόν}.<<withTensePresent>> '

    /* nothing can be put behind the given object */
    cannotPutBehindMsg = '{Εσύ/Αυτός} δεν {μπορώ} να  {βάζω} τίποτα πίσω από {τον iobj/αυτόν}.<<withTensePresent>> '

    /* trying to put something in itself */
    cannotPutInSelfMsg = '{Εσύ/Αυτός} δεν {μπορώ} να  {βάζω} {τον dobj/αυτόν} μέσα {itself}.<<withTensePresent>> '

    /* trying to put something on itself */
    cannotPutOnSelfMsg = '{Εσύ/Αυτός} δεν {μπορώ} να  {βάζω} {τον dobj/αυτόν} πάνω {itself}.<<withTensePresent>> '

    /* trying to put something under itself */
    cannotPutUnderSelfMsg = '{Εσύ/Αυτός} δεν {μπορώ} να  {βάζω} {τον dobj/αυτόν} κάτω από {itself}.<<withTensePresent>> '

    /* trying to put something behind itself */
    cannotPutBehindSelfMsg = '{Εσύ/Αυτός} δεν {μπορώ} να  {βάζω} {τον dobj/αυτόν} πίσω από {itself}.<<withTensePresent>> '

    /* can't put something in/on/etc a restricted container/surface/etc */
    cannotPutInRestrictedMsg =
        '{Εσύ/Αυτός} δεν {μπορώ} να  {βάζω} {τον dobj/αυτόν} μέσα {στον iobj/σεαυτόν}.<<withTensePresent>> '
    cannotPutOnRestrictedMsg =
        '{Εσύ/Αυτός} δεν {μπορώ} να  {βάζω} {τον dobj/αυτόν} πάνω {στον iobj/σεαυτόν}.<<withTensePresent>> '
    cannotPutUnderRestrictedMsg =
        '{Εσύ/Αυτός} δεν {μπορώ} να  {βάζω} {τον dobj/αυτόν} κάτω από {τον iobj/αυτόν}.<<withTensePresent>> '
    cannotPutBehindRestrictedMsg =
        '{Εσύ/Αυτός} δεν {μπορώ} να  {βάζω} {τον dobj/αυτόν} πίσω από {τον iobj/αυτόν}.<<withTensePresent>> '

    /* trying to return something to a remove-only dispenser */
    cannotReturnToDispenserMsg =
        '{Εσύ/Αυτός} δεν {μπορώ} να  {βάζω} {έναν/μία dobj} πίσω {στον iobj/σεαυτόν}.<<withTensePresent>> '

    /* wrong item type for dispenser */
    cannotPutInDispenserMsg =
        '{Εσύ/Αυτός} δεν {μπορώ} να  {βάζω} {έναν/μία dobj} μέσα {στον iobj/σεαυτόν}.<<withTensePresent>> '

    /* the dobj doesn't fit on this keyring */
    objNotForKeyringMsg = '{Ο dobj/αυτός} δεν {χωράω} {στον iobj/σεαυτόν}. '

    /* the dobj isn't on the keyring */
    keyNotOnKeyringMsg = '{Ο dobj/αυτός} δεν {είμαι} συνδεδε{-μένος-μένη-μένο} {στον iobj/σεαυτόν}. '

    /* can't detach key (with no iobj specified) because it's not on a ring */
    keyNotDetachableMsg = '{Ο dobj/αυτός} δεν {είμαι} συνδεδε{-μένος-μένη-μένο} σε τίποτα. '

    /* we took a key and attached it to a keyring */
    takenAndMovedToKeyringMsg(keyring)
    {
        gMessageParams(keyring);
        return '{Εσύ/Αυτός} {πιάνω} {τον dobj/αυτόν} και {τον/την/το}
            {συνδέω actor} {στον keyring/σεαυτόν}. ';
    }

    /* we attached a key to a keyring automatically */
    movedKeyToKeyringMsg(keyring)
    {
        gMessageParams(keyring);
        return '{Εσύ/Αυτός} {συνδέω} {τον dobj/αυτόν} {στον keyring/σεαυτόν}. ';
    }

    /* we moved several keys to a keyring automatically */
    movedKeysToKeyringMsg(keyring, keys)
    {
        gMessageParams(keyring);
        return '{Εσύ/Αυτός} {συνδέω} '
            + (keys.length() > 1 ? 'τα κλειδιά' : 'το κλειδί')
            + ' {μου/σου/του} {στον keyring/σεαυτόν}. ';
    }

    /* putting y in x when x is already in y */
    circularlyInMsg(x, y)
    {
        gMessageParams(x, y);
        return '{Εσύ/Αυτός} δεν {μπορώ} να  το {κάνω} αυτό καθώς {ο x/αυτός} {είμαι} μέσα {στον y/σεαυτόν}.<<withTensePresent>> ';
    }

    /* putting y in x when x is already on y */
    circularlyOnMsg(x, y)
    {
        gMessageParams(x, y);
        return '{Εσύ/Αυτός} δεν {μπορώ} να  το {κάνω} αυτό καθώς {ο x/αυτός} {είμαι} πάνω {στον y/σεαυτόν}.<<withTensePresent>> ';
    }

    /* putting y in x when x is already under y */
    circularlyUnderMsg(x, y)
    {
        gMessageParams(x, y);
        return '{Εσύ/Αυτός} δεν {μπορώ} να  το {κάνω} αυτό καθώς {ο x/αυτός} {είμαι} κάτω από {τον y/αυτόν}.<<withTensePresent>> ';
    }

    /* putting y in x when x is already behind y */
    circularlyBehindMsg(x, y)
    {
        gMessageParams(x, y);
        return '{Εσύ/Αυτός} δεν {μπορώ} να  το {κάνω} αυτό καθώς {ο x/αυτός} {είμαι} πίσω από {τον y/αυτόν}.<<withTensePresent>> ';
    }

    /* taking dobj from iobj, but dobj isn't in iobj */
    takeFromNotInMsg = '{Ο dobj/αυτός} δεν {είμαι} μέσα {στον iobj/σεαυτόν}. '

    /* taking dobj from surface, but dobj isn't on iobj */
    takeFromNotOnMsg = '{Ο dobj/αυτός} δεν {είμαι} πάνω {στον iobj/σεαυτόν}. '

    /* taking dobj from under something, but dobj isn't under iobj */
    takeFromNotUnderMsg = '{Ο dobj/αυτός} δεν {είμαι} κάτω από {τον iobj/αυτόν}. '

    /* taking dobj from behind something, but dobj isn't behind iobj */
    takeFromNotBehindMsg = '{Ο dobj/αυτός} δεν {είμαι} πίσω από {τον iobj/αυτόν}. '

    /* taking dobj from an actor, but actor doesn't have iobj */
    takeFromNotInActorMsg = '{Ο iobj/αυτός} δεν {έχω} {τον dobj/αυτόν}. '

    /* actor won't let go of a possession */
    willNotLetGoMsg(holder, obj)
    {
        gMessageParams(holder, obj);
        return '{Ο holder/αυτός} δεν <<withTenseStigFuture>>{αφήνω} {εσένα/αυτόν} να  {παίρνω} {τον obj/αυτόν}.<<withTensePresent>> ';
    }

    /* must say which way to go */
    whereToGoMsg = 'Πρέπει να γίνει αναφορά στην κατεύθυνση που {εσύ/αυτός} {θέλω} να  {πηγαίνω}.<<withTensePresent>> '

    /* travel attempted in a direction with no exit */
    cannotGoThatWayMsg = '{Εσύ/Αυτός} δεν {μπορώ} να  {πηγαίνω} προς τα εκεί.<<withTensePresent>> '

    /* travel attempted in the dark in a direction with no exit */
    cannotGoThatWayInDarkMsg = '{Είναι|Ήταν} πολύ σκοτεινά. {Εσύ/Αυτός} δεν {βλέπω} πού {πηγαίνω}. '

    /* we don't know the way back for a GO BACK */
    cannotGoBackMsg = '{Εσύ/Αυτός} δεν {ξέρω} πώς να  {επιστρέφω} επό αυτό το σημείο.<<withTensePresent>> '

    /* cannot carry out a command from this location */
    cannotDoFromHereMsg = '{Εσύ/Αυτός} δεν {μπορώ} να  {κάνω} κάτι τέτοιο από {αυτό|εκείνο} το σημείο. <<withTensePresent>> '

    /* can't travel through a close door */
    cannotGoThroughClosedDoorMsg(door)
    {
        gMessageParams(door);
        return '{Εσύ/Αυτός} δεν {μπορώ} να  το {κάνω} αυτό, διότι {ο door/αυτός} είναι '
               + 'κλειστ{-ός-ή-ό}.<<withTensePresent>> ';
    }

    /* cannot carry out travel while 'dest' is within 'cont' */
    invalidStagingContainerMsg(cont, dest)
    {
        gMessageParams(cont, dest);
        return '{Εσύ/Αυτός} δεν {μπορώ} να  το {κάνω} αυτό καθώς {ο dest/αυτός} είναι {μέσα cont}.<<withTensePresent>> ';
    }

    /* cannot carry out travel while 'cont' (an actor) is holding 'dest' */
    invalidStagingContainerActorMsg(cont, dest)
    {
        gMessageParams(cont, dest);
        return '{Εσύ/Αυτός} δεν {μπορώ} να  το {κάνω} αυτό καθώς {ο cont/αυτός} {κρατάω} {τον dest/αυτόν}.<<withTensePresent>> ';
    }
    
    /* can't carry out travel because 'dest' isn't a valid staging location */
    invalidStagingLocationMsg(dest)
    {
        gMessageParams(dest);
        return '{Εσύ/Αυτός} δεν {μπορώ} να  {έχω} πρόσβαση {μέσα dest}.<<withTensePresent>> ';
    }

    /* destination is too high to enter from here */
    nestedRoomTooHighMsg(obj)
    {
        gMessageParams(obj);
        return '{Ο obj/αυτός} {είμαι} πολύ ψηλά για να είναι προσβάσιμ{-ος-η-ο} από αυτό το σημείο. ';
    }

    /* enclosing room is too high to reach by GETTING OUT OF here */
    nestedRoomTooHighToExitMsg(obj)
    {
        return '{Είναι|Ήταν} πολύ μεγάλο το ύψος για να μπορεί να γίνει κάτι τέτοιο από αυτό το σημείο. ';
    }

    /* cannot carry out a command from a nested room */
    cannotDoFromMsg(obj)
    {
        gMessageParams(obj);
        return '{Εσύ/Αυτός} δεν {μπορώ} να  το {κάνω} αυτό από {τον obj/αυτόν}. ';
    }

    /* cannot carry out a command from within a vehicle in a nested room */
    vehicleCannotDoFromMsg(obj)
    {
        local loc = obj.location;
        gMessageParams(obj, loc);
        return '{Εσύ/Αυτός} δεν {μπορώ} να  το {κάνω} αυτό καθώς {ο obj/αυτός} {είμαι} {μέσα loc}.<<withTensePresent>> ';
    }

    /* cannot go that way in a vehicle */
    cannotGoThatWayInVehicleMsg(traveler)
    {
        gMessageParams(traveler);
        return '{Εσύ/Αυτός} δεν {μπορώ} να  {κάνω} κατι τέτοιο {μέσα traveler}.<<withTensePresent>> ';
    }

    /* cannot push an object that way */
    cannotPushObjectThatWayMsg(obj)
    {
        gMessageParams(obj);
        return '{Εσύ/Αυτός} δεν {μπορώ} να  {πηγαίνω} προς εκείνη την κατεύθυνση σπρώχνοντας {τον obj/αυτόν}.<<withTensePresent>> ';
    }

    /* cannot push an object to a nested room */
    cannotPushObjectNestedMsg(obj)
    {
        gMessageParams(obj);
        return '{Εσύ/Αυτός} δεν {μπορώ} να  {σπρώχνω} {τον obj/αυτόν} εκεί. ';
    }

    /* cannot enter an exit-only passage */
    cannotEnterExitOnlyMsg(obj)
    {
        gMessageParams(obj);
        return '{Εσύ/Αυτός} δεν {μπορώ} να  {μπαίνω} μέσα {στον obj/σεαυτόν} από {εδώ|εκεί}. ';
    }

    /* must open door before going that way */
    mustOpenDoorMsg(obj)
    {
        gMessageParams(obj);
        return '{Εσύ/Αυτός} πρέπει πρώτα να  {ανοίγω} {τον obj/αυτόν}. ';
    }

    /* door closes behind actor during travel through door */
    doorClosesBehindMsg(obj)
    {
        gMessageParams(obj);
        return '<.p>Αφού {εσύ/αυτός} {περνάω} μέσα από {τον obj/αυτόν}, {αυτός}
			{κλείνει|έκλεισε} πίσω {μου/σου/του}. ';
    }

    /* the stairway does not go up/down */
    stairwayNotUpMsg = '{Ο dobj/αυτός} από εκεί {πηγαίνω} μόνο προς τα κάτω. '
    stairwayNotDownMsg = '{Ο dobj/αυτός} από εκεί {πηγαίνω} μόνο προς τα πάνω. '

    /* "wait" */
    timePassesMsg = 'Ο χρόνος {περνά|περνούσε}... '

    /* "hello" with no target actor */
    sayHelloMsg = (addressingNoOneMsg)

    /* "goodbye" with no target actor */
    sayGoodbyeMsg = (addressingNoOneMsg)

    /* "yes"/"no" with no target actor */
    sayYesMsg = (addressingNoOneMsg)
    sayNoMsg = (addressingNoOneMsg)

    /* an internal common handler for sayHelloMsg, sayGoodbyeMsg, etc */
    addressingNoOneMsg
    {
        return '{Εσύ/Αυτός} πρέπει να  {κάνω} πιο ξεκάθαρο '
            + gLibMessages.whomPronoun
            + ' {it actor/he} {θέλω} να  {μιλάω}.<<withTensePresent>> ';
    }

    /* "yell" */
    okayYellMsg = '{Εσύ/Αυτός} {φωνάζω} όσο πιο δυνατά {μπορώ}. '

    /* "jump" */
    okayJumpMsg = '{Εσύ/Αυτός} {πηδάω} λίγο, και {προσγειώνομαι} στο ίδιο σημείο από όπου <<withTenseAoristos>>{ξεκινάω}. '

    /* cannot jump over object */
    cannotJumpOverMsg = '{Εσύ/Αυτός} δεν {μπορώ} να  {πηδάω} πάνω από {τον dobj/αυτόν}.<<withTensePresent>> '

    /* cannot jump off object */
    cannotJumpOffMsg = '{Εσύ/Αυτός} δεν {μπορώ} να  {πηδάω} από {τον dobj/αυτόν}.<<withTensePresent>> '

    /* cannot jump off (with no direct object) from here */
    cannotJumpOffHereMsg = 'Δεν υπάρχει κάποιος χώρος όπου να {μπορώ} να  {πηδάω} από αυτό το σημείο. '

    /* failed to find a topic in a consultable object */
    cannotFindTopicMsg =
        '{Εσύ/Αυτός} δεν {βρίσκω} αυτό που ψάχνω μέσα {στον dobj/σεαυτόν}. '

    /* an actor doesn't accept a command from another actor */
    refuseCommand(targetActor, issuingActor)
    {
        gMessageParams(targetActor, issuingActor);
        return '{Ο targetActor/Αυτός} {αρνούμαι} το αίτημά {μου/σου/του}.<<withTensePresent>> ';
    }

    /* cannot talk to an object (because it makes no sense to do so) */
    notAddressableMsg(obj)
    {
        gMessageParams(obj);
        return '{Εσύ/Αυτός} δεν {μπορώ} να  {μιλάω} {στον obj/σεαυτόν}. ';
    }

    /* actor won't respond to a request or other communicative gesture */
    noResponseFromMsg(other)
    {
        gMessageParams(other);
        return '{Ο other/αυτός} δεν {απαντάω}. ';
    }

    /* trying to give something to someone who already has the object */
    giveAlreadyHasMsg = '{Ο iobj/αυτός} {έχω} ήδη {τον dobj/αυτόν}. '

    /* can't talk to yourself */
    cannotTalkToSelfMsg = 'Η επικοινωνία με τον εαυτό {μου/σου/του}
        δεν θα φέρει κάποιο αποτέλεσμα. '

    /* can't ask yourself about anything */
    cannotAskSelfMsg = 'Η επικοινωνία με τον εαυτό {μου/σου/του}
        δεν θα φέρει κάποιο αποτέλεσμα. '

    /* can't ask yourself for anything */
    cannotAskSelfForMsg = 'Η επικοινωνία με τον εαυτό {μου/σου/του}
        δεν θα φέρει κάποιο αποτέλεσμα. '

    /* can't tell yourself about anything */
    cannotTellSelfMsg = 'Η επικοινωνία με τον εαυτό {μου/σου/του}
        δεν θα φέρει κάποιο αποτέλεσμα. '

    /* can't give yourself something */
    cannotGiveToSelfMsg = 'Το να προσφερθεί {ο dobj/αυτός} στον εαυτό {μου/σου/του}
        δεν έχει κάποια χρησιμότητα. '
    
    /* can't give something to itself */
    cannotGiveToItselfMsg = 'Το να προσφερθεί {ο dobj/αυτός} στον εαυτό {του/της/του}
        δεν έχει κάποια χρησιμότητα. '

    /* can't show yourself something */
    cannotShowToSelfMsg = 'Η επίδειξη {του dobj/αυτού} στον εαυτό {μου/σου/του} δεν έχει κάποια χρησιμότητα. '

    /* can't show something to itself */
    cannotShowToItselfMsg = 'Η επίδειξη {του dobj/αυτού} στον εαυτό {του/της/του}
        δεν θα είχε κάποια χρησιμότητα. '

    /* can't give/show something to a non-actor */
    cannotGiveToMsg = '{Εσύ/Αυτός} δεν {μπορώ} να  {δίνω} κάτι {σεέναν/σεμία iobj}.<<withTensePresent>> '
    cannotShowToMsg = '{Εσύ/Αυτός} δεν {μπορώ} να  {δείχνω} κάτι {σεέναν/σεμία iobj}.<<withTensePresent>> '

    /* actor isn't interested in something being given/shown */
    notInterestedMsg(actor)
    {
        return '\^' + '{Ο actor/αυτός} δεν φαίνεται να ενδιαφέρεται. ';
    }

    /* vague ASK/TELL (for ASK/TELL <actor> <topic> syntax errors) */
    askVagueMsg = '<.parser>Η ιστορία δεν καταλαβαίνει αυτήν την εντολή.
        Παρακαλώ, χρησιμοποίησε την εντολή ΡΩΤΑ ΤΟΝ ΗΘΟΠΟΙΟ ΓΙΑ ΤΟ ΘΕΜΑ (ή απλά ΤΟ ΘΕΜΑ).<./parser> '
    tellVagueMsg = '<.parser>Η ιστορία δεν καταλαβαίνει αυτήν την εντολή.
        Παρακαλώ, χρησιμοποίησε ΠΕΣ ΣΤΟΝ ΗΘΟΠΟΙΟ ΓΙΑ ΤΟ ΘΕΜΑ (ή απλά Π ΘΕΜΑ).<./parser> '

    /* object cannot hear actor */
    objCannotHearActorMsg(obj)
    {
        return '\^' + '{Ο obj/αυτός} μάλλον δεν {ακούω}. ';
    }

    /* actor cannot see object being shown to actor */
    actorCannotSeeMsg(actor, obj)
    {
        return '\^' + '{Ο actor/αυτός} μάλλον δεν {βλέπω}. '
            + obj.tonNameObj + '. ';
    }

    /* not a followable object */
    notFollowableMsg = '{Εσύ/Αυτός} δεν {μπορώ} να  {ακολουθώ} {τον dobj/αυτόν}. '

    /* cannot follow yourself */
    cannotFollowSelfMsg = '{Εσύ/Αυτός} δεν {μπορώ} να  {ακολουθώ} τον εαυτό {μου/σου/του}. '

    /* following an object that's in the same location as the actor */
    followAlreadyHereMsg = '{Ο dobj/αυτός} {είμαι} ακριβώς σε αυτό το σημείο. '

    /*
     *   following an object that we *think* is in our same location (in
     *   other words, we're already in the location where we thought we
     *   last saw the object go), but it's too dark to see if that's
     *   really true 
     */
    followAlreadyHereInDarkMsg = '{Ο dobj/αυτός} θα έπρεπε να βρίσκεται ακριβώς σε αυτό το σημείο, αλλά {εσύ/αυτός} δεν {βλέπω} {τον dobj/αυτόν}. '

    /* trying to follow an object, but don't know where it went from here */
    followUnknownMsg = '{Εσύ/Αυτός} δεν {έχω} γνώση για το που πήγε {ο dobj/αυτός}
       από {εδώ|εκεί}. '

    /*
     *   we're trying to follow an actor, but we last saw the actor in the
     *   given other location, so we have to go there to follow 
     */
    cannotFollowFromHereMsg(srcLoc)
    {
        return 'Η τελευταία τοποθεσία στην οποία {εσύ/αυτός} <<withTenseAoristos>>{βλέπω} {τον dobj/αυτόν} ήταν '
            + srcLoc.getDestName(gActor, gActor.location) + '. ';
    }

    /* acknowledge a 'follow' for a target that was in sight */
    okayFollowInSightMsg(loc)
    {
        return '{Εσύ/Αυτός} {ακολουθώ} {τον dobj/αυτόν} '
            + loc.actorIntoName + '. ';
    }

    /* obj is not a weapon */
    notAWeaponMsg = '{Εσύ/Αυτός} δεν {μπορώ} να  {επιτίθεμαι} σε κάτι με {τον iobj/αυτόν}. '

    /* no effect attacking obj */
    uselessToAttackMsg = '{Εσύ/Αυτός} δεν {μπορώ} να  {επιτίθεμαι} {στον dobj/σεαυτόν}. '

    /* pushing object has no effect */
    pushNoEffectMsg = 'Το σπρώξιμο {του dobj/αυτού} δεν έχει κάποιο αποτέλεσμα. '

    /* default 'push button' acknowledgment */
    okayPushButtonMsg = '<q>Κλικ.</q> '

    /* lever is already in pushed state */
    alreadyPushedMsg =
        '{Ο dobj/αυτός} {είναι} ήδη στο τέρμα {μου/σου/του}. '

    /* default acknowledgment to pushing a lever */
    okayPushLeverMsg = '{Εσύ/Αυτός} {σπρώχνω} {τον dobj/αυτόν} μέχρι το τέρμα. '

    /* pulling object has no effect */
    pullNoEffectMsg = 'Το τράβηγμα {του dobj/αυτού} δεν {έχω} κάποιο αποτέλεσμα. '

    /* lever is already in pulled state */
    alreadyPulledMsg =
        '{Ο dobj/αυτός} {είναι} ήδη τραβηγ{-μένος-μένη-μένο} πάρα πολύ. '

    /* default acknowledgment to pulling a lever */
    okayPullLeverMsg = '{Εσύ/Αυτός} {τραβάω} {τον dobj/αυτόν} μέχρι το τέρμα. '

    /* default acknowledgment to pulling a spring-loaded lever */
    okayPullSpringLeverMsg = '{Εσύ/Αυτός} {τραβάω} {τον dobj/αυτόν}, που
        επιστρέφει πίσω στην αρχική {μου/σου/του} θέση μόλις {εσύ/αυτός} {τον/την/το} {αφήνω}. '

    /* moving object has no effect */
    moveNoEffectMsg = 'Η μεταφορά {του dobj/αυτού} δεν έχει κάποιο εμφανές αποτέλεσμα. '

    /* cannot move object to other object */
    moveToNoEffectMsg = 'Αυτό δεν θα έφερνε κάποιο αποτέλεσμα. '

    /* cannot push an object through travel */
    cannotPushTravelMsg = 'Αυτό δεν θα έφερνε κάποιο αποτέλεσμα. '

    /* acknowledge pushing an object through travel */
    okayPushTravelMsg(obj)
    {
        return '<.p>{Εσύ/Αυτός} {σπρώχνω} ' + obj.tonNameObj
            + ' μέσα στην περιοχή. ';
    }

    /* cannot use object as an implement to move something */
    cannotMoveWithMsg =
        '{Εσύ/Αυτός} δεν {μπορώ} να  {μεταφέρω} κάτι με {τον iobj/αυτόν}. '

    /* cannot set object to setting */
    cannotSetToMsg = '{Εσύ/Αυτός} δεν {μπορώ} να  {θέτω} {τον dobj/αυτόν} σε κάποια ρύθμιση. '

    /* invalid setting for generic Settable */
    setToInvalidMsg = '{Ο dobj/αυτός} δεν {έχω} κάποια τέτοια ρύθμιση. '

    /* default 'set to' acknowledgment */
    okaySetToMsg(val)
        { return 'Εντάξει, {ο dobj/αυτός} {είμαι} ρυθμισ{-μένος-μένη-μένο} στο ' + val + '. '; }

    /* cannot turn object */
    cannotTurnMsg = '{Εσύ/Αυτός} δεν {μπορώ} να  {γυρνάω} {τον dobj/αυτόν}. '

    /* must specify setting to turn object to */
    mustSpecifyTurnToMsg = '{Εσύ/Αυτός} πρέπει να  {κάνω} πιο συγκεκριμένη την ρύθμιση στην οποία {θέλω} να {γυρνάω} {τον dobj/αυτον}. '

    /* cannot turn anything with object */
    cannotTurnWithMsg =
        '{Εσύ/Αυτός} δεν {μπορώ} να  {γυρνάω} τίποτα με {τον iobj/αυτόν}. '

    /* invalid setting for dial */
    turnToInvalidMsg = '{Ο dobj/αυτός} δεν {έχω} κάποια τέτοια ρύθμιση. '

    /* default 'turn to' acknowledgment */
    okayTurnToMsg(val)
        { return 'Εντάξει, {ο dobj/αυτός} {είμαι} τώρα ρυθμισμέν{-ος-η-ο} στην τιμή ' + val + '. '; }

    /* switch is already on/off */
    alreadySwitchedOnMsg = '{Ο dobj/αυτός} {είμαι} ήδη ενεργ{-ός-ή-ό}. '
    alreadySwitchedOffMsg = '{Ο dobj/αυτός} {<<withTensePresent>>[είμαι]|<<withTenseAoristos>>[είμαι]} ήδη ανενεργ{-ός-ή-ό}. '

    /* default acknowledgment for switching on/off */
    okayTurnOnMsg = 'Εντάξει, {ο dobj/αυτός} {είμαι} τώρα ενεργ{-ός-ή-ό}. '
    okayTurnOffMsg = 'Εντάξει, {ο dobj/αυτός} {είμαι} τώρα ανενεργ{-ός-ή-ό}. '

    /* flashlight is on but doesn't light up */
    flashlightOnButDarkMsg = '{Εσύ/Αυτός} {<<withTensePresent>>[ενεργοποιώ]|<<withTenseAoristos>>[ενεργοποιώ]} {τον dobj/αυτόν}, αλλά
        δεν {συμβαίνει|συνέβη} τίποτα. '

    /* default acknowledgment for eating something */
    okayEatMsg = '{Εσύ/Αυτός} { <<withTensePresent>>[τρώω]|<<withTenseAoristos>>[τρώω]} {τον dobj/αυτόν}. '

    /* object must be burning before doing that */
    mustBeBurningMsg(obj)
    {
        return '{Εσύ/Αυτός} πρέπει να  {ανάβω} ' + obj.tonNameObj
            + ' πριν {ο actor/αυτός}  {μπορώ} να  {κάνω} αυτό. ';
    }

    /* match not lit */
    matchNotLitMsg = '{Ο dobj/αυτός} δεν {είμαι} αναμ{-μένος-μένη-μένο}. '

    /* lighting a match */
    okayBurnMatchMsg =
        '{Εσύ/Αυτός} {χτυπάω} {τον dobj/αυτόν}, δημιουργώντας μια μικρή φλόγα. '

    /* extinguishing a match */
    okayExtinguishMatchMsg = '{Εσύ/Αυτός} {σβήνω} {τον dobj/αυτόν} και {αυτός} μετατρέπεται σε ένα σύννεφο καπνού. '

    /* trying to light a candle with no fuel */
    candleOutOfFuelMsg =
        '{Ο dobj/αυτός} {είμαι} σχεδόν ολοκληρωτικά καμ{-μένος-μένη-μένο}. {Αυτός} δεν {μπορώ} να ανάψει. '

    /* lighting a candle */
    okayBurnCandleMsg = '{Εσύ/Αυτός} {ανάβω} {τον dobj/αυτόν}. '

    /* extinguishing a candle that isn't lit */
    candleNotLitMsg = '{Ο dobj/αυτός} δεν {είμαι} αναμ{-μένος-μένη-μένο}. '

    /* extinguishing a candle */
    okayExtinguishCandleMsg = 'Έγινε. '

    /* cannot consult object */
    cannotConsultMsg =
        '{Ο dobj/αυτός} δεν {είμαι} κάτι που {εσύ/αυτός} {μπορώ} να  {συμβουλεύομαι}. '

    /* cannot type anything on object */
    cannotTypeOnMsg = '{Εσύ/Αυτός} δεν {μπορώ} να  {πληκτρολογώ} τίποτα {στον dobj/σεαυτόν}. '

    /* cannot enter anything on object */
    cannotEnterOnMsg = '{Εσύ/Αυτός} δεν {μπορώ} να  {εισάγω} το οτιδήποτε {στον dobj/σεαυτόν}. '

    /* cannot switch object */
    cannotSwitchMsg = '{Εσύ/Αυτός} δεν {μπορώ} να  {αλλάζω} {τον dobj/αυτόν}. '

    /* cannot flip object */
    cannotFlipMsg = '{Εσύ/Αυτός} δεν {μπορώ} να  αναποδο{γυρίζω} {τον dobj/αυτόν}. '

    /* cannot turn object on/off */
    cannotTurnOnMsg =
        '{Ο dobj/αυτός} δεν {είμαι} κάτι που {εσύ/αυτός} {μπορώ} να  {ενεργοποιώ}. '
    cannotTurnOffMsg =
        '{Ο dobj/αυτός} δεν {είμαι} κάτι που {εσύ/αυτός} {μπορώ} να  απ{ενεργοποιώ}. '

    /* cannot light */
    cannotLightMsg = '{Εσύ/Αυτός} δεν {μπορώ} να  {φωτίζω} {τον dobj/αυτόν}. '

    /* cannot burn */
    cannotBurnMsg = '{Ο dobj/αυτός} δεν {είμαι} κάτι που {εσύ/αυτός} {μπορώ} να  {καίω}. '
    cannotBurnWithMsg =
        '{Εσύ/Αυτός} δεν {μπορώ} να  {καίω} τίποτα με {τον iobj/αυτόν}. '

    /* cannot burn this specific direct object with this specific iobj */
    cannotBurnDobjWithMsg = '{Εσύ/Αυτός} δεν {μπορώ} να  {ανάβω} {τον dobj/αυτόν}
                          με {τον iobj/αυτόν}. '

    /* object is already burning */
    alreadyBurningMsg = '{Ο dobj/αυτός} ήδη {ανάβω}. '

    /* cannot extinguish */
    cannotExtinguishMsg = '{Εσύ/Αυτός} δεν {μπορώ} να  {σβήνω} {τον dobj/αυτόν}. '

    /* cannot pour/pour in/pour on */
    cannotPourMsg = '{Ο dobj/αυτός} δεν {είμαι} κάτι που {εσύ/αυτός} {μπορώ} να  {χύνω}. '
    cannotPourIntoMsg =
        '{Εσύ/Αυτός} δεν {μπορώ} να  {χύνω} τίποτα μέσα {στον iobj/σεαυτόν}. '
    cannotPourOntoMsg =
        '{Εσύ/Αυτός} δεν {μπορώ} να  {χύνω} τίποτα πάνω {στον iobj/σεαυτόν}. '

    /* cannot attach object to object */
    cannotAttachMsg =
        '{Εσύ/Αυτός} δεν {μπορώ} να  {συνδέω} {τον dobj/αυτόν} σε τίποτα. '
    cannotAttachToMsg =
        '{Εσύ/Αυτός} δεν {μπορώ} να  {συνδέω} τίποτα {στον iobj/σεαυτόν}. '

    /* cannot attach to self */
    cannotAttachToSelfMsg =
        '{Εσύ/Αυτός} δεν {μπορώ} να  {συνδέω} {τον dobj/αυτόν} στον εαυτό {μου/σου/του}. '

    /* cannot attach because we're already attached to the given object */
    alreadyAttachedMsg =
        '{Ο dobj/αυτός} {είμαι} ήδη συνδεδε{-μένος-μένη-μένο} με {τον iobj/αυτόν}. '

    /*
     *   dobj and/or iobj can be attached to certain things, but not to
     *   each other 
     */
    wrongAttachmentMsg =
        '{Εσύ/Αυτός} δεν {μπορώ} να  {συνδέω} {τον dobj/αυτόν} με {τον iobj/αυτόν}. '

    /* dobj and iobj are attached, but they can't be taken apart */
    wrongDetachmentMsg =
        '{Εσύ/Αυτός} δεν {μπορώ} να  {αποσπώ} {τον dobj/αυτόν} από {τον iobj/αυτόν}. '

    /* must detach the object before proceeding */
    mustDetachMsg(obj)
    {
        gMessageParams(obj);
        return '{Εσύ/Αυτός} πρέπει να  {αποσπώ} {τον obj/αυτόν} πριν {ο actor/αυτός}
            μπορέσει να το κάνει αυτό. ';
    }

    /* default message for successful Attachable attachment */
    okayAttachToMsg = 'Έγινε. '

    /* default message for successful Attachable detachment */
    okayDetachFromMsg = 'Έγινε. '

    /* cannot detach object from object */
    cannotDetachMsg = '{Εσύ/Αυτός} δεν {μπορώ} να  {αποσπώ} {τον dobj/αυτόν}. <<withTensePresent>> '
    cannotDetachFromMsg =
        '{Εσύ/Αυτός} δεν {μπορώ} να  {αποσπώ} τίποτα από {τον iobj/αυτόν}. <<withTensePresent>> '

    /* no obvious way to detach a permanent attachment */
    cannotDetachPermanentMsg =
        'Δεν φαίνεται να υπάρχει τρόπος να αποσπαστεί {ο dobj/αυτός}. '

    /* dobj isn't attached to iobj */
    notAttachedToMsg = '{Ο dobj/αυτός} δεν {είμαι} συνδεδε{-μένος-μένη-μένο} {στον iobj/σεαυτόν}. '

    /* breaking object would serve no purpose */
    shouldNotBreakMsg =
        'Το σπάσιμο {του dobj/αυτού} δεν θα βοηθούσε σε τίποτα. '

    /* cannot cut that */
    cutNoEffectMsg = '{Ο iobj/αυτός} δεν {κόβω} {τον dobj/αυτόν}. '

    /* can't use iobj to cut anything */
    cannotCutWithMsg = '{Εσύ/Αυτός} δεν {μπορώ} να  {κόβω} το οτιδήποτε με {τον iobj/αυτον}. <<withTensePresent>> '

    /* cannot climb object */
    cannotClimbMsg =
        '{Ο dobj/αυτός} δεν <<withTensePresent>>{είμαι} κάτι που {εσύ/αυτός} <<withTensePresent>>{μπορώ} να  {σκαρφαλώνω}. '

    /* object is not openable/closable */
    cannotOpenMsg = cannot1+cannot2//'{Ο dobj/αυτός} δεν {είμαι} κάτι που {εσύ/αυτός} <<withTensePresent>>{μπορώ}' + ' να {ανοίγω}. '
	cannot1= '{Ο dobj/αυτός} δεν {είμαι} κάτι που {εσύ/αυτός} <<withTensePresent>>{μπορώ}'
	cannot2= ' να {ανοίγω}.  '
    cannotCloseMsg =
        '{Ο dobj/αυτός} δεν {είμαι} κάτι που {εσύ/αυτός} {μπορώ} να  {κλείνω}.<<withTensePresent>> '

    /* already open/closed */
    alreadyOpenMsg = '{Ο dobj/αυτός} {είμαι} ήδη ανοιχτ{-ός-ή-ό}. '
    alreadyClosedMsg = '{Ο dobj/αυτός} {είμαι} ήδη κλειστ{-ός-ή-ό}. '

    /* already locked/unlocked */
    alreadyLockedMsg = '{Ο dobj/αυτός} {είμαι} ήδη κλειδω{-μένος-μένη-μένο}. '
    alreadyUnlockedMsg = '{Ο dobj/αυτός} {είμαι} ήδη ξεκλείδωτ{-ος-η-ο}. '

    /* cannot look in container because it's closed */
    cannotLookInClosedMsg = '{Ο dobj/αυτός} {είμαι} κλειστ{-ός-ή-ό}. '

    /* object is not lockable/unlockable */
    cannotLockMsg =
        '{Ο dobj/αυτός} δεν {είμαι} κάτι που {εσύ/αυτός} {μπορώ} να  {κλειδώνω}.<<withTensePresent>> '
    cannotUnlockMsg =
        '{Ο dobj/αυτός} δεν {είμαι} κάτι που {εσύ/αυτός} {μπορώ} να  ξε{κλειδώνω}.<<withTensePresent>> '

    /* attempting to open a locked object */
    cannotOpenLockedMsg = '{Ο dobj/αυτός} {είμαι} κλειδωμέν{-ος-η-ο}. '

    /* object requires a key to unlock */

    unlockRequiresKeyMsg =
        '{Εσύ/Αυτός} {χρειάζομαι} ένα κλειδί για να  ξε{κλειδώνω} {τον dobj/αυτόν}.<<withTensePresent>> '

    /* object is not a key */
    cannotLockWithMsg =
        '{Ο iobj/αυτός} δεν {φαίνομαι} κατάλληλ{-ος-η-ο} για να κλειδώσει κάτι τέτοιο. '
    cannotUnlockWithMsg =
        '{Ο iobj/αυτός} δεν {φαίνομαι} κατάλληλ{-ος-η-ο} για να ξεκλειδώσει κάτι τέτοιο. '

    /* we don't know how to lock/unlock this */
    unknownHowToLockMsg =
        'Δε είναι ξεκάθαρο πώς μπορεί να κλειδωθεί {ο dobj/αυτός}. '
    unknownHowToUnlockMsg =
        'Δε είναι ξεκάθαρο πώς μπορεί να ξεκλειδωθεί {ο dobj/αυτός}. '

    /* the key (iobj) does not fit the lock (dobj) */
    keyDoesNotFitLockMsg = '{Ο iobj/αυτός} δεν {ταιριάζω} στην κλειδαριά. '

    /* found key on keyring */
    foundKeyOnKeyringMsg(ring, key)
    {
        gMessageParams(ring, key);
        return '{Εσύ/Αυτός} {δοκιμάζω} κάθε κλειδί από {τον ring/αυτόν} και
            {βρίσκω} ότι {τον key/αυτόν} ταιριάζει στην κλειδαριά. ';
    }

    /* failed to find a key on keyring */
    foundNoKeyOnKeyringMsg(ring)
    {
        gMessageParams(ring);
        return '{Εσύ/Αυτός} {δοκιμάζω} κάθε κλειδί από {τον ring/αυτόν},
            αλλά {εσύ/αυτός} δεν {μπορώ} να  {βρίσκω} κάποιο που να ταιριάζει στην κλειδαριά.<<withTensePresent>> ';
    }

    /* not edible/drinkable */
    cannotEatMsg = '{Ο dobj/αυτός} δεν {φαίνομαι} σαν κάτι που μπορεί να φαγωθεί. '
    cannotDrinkMsg = '{Ο dobj/αυτός} δεν {φαίνομαι} να είναι κάτι που {εσύ/αυτός} {μπορώ} να  {πίνω}.<<withTensePresent>> '

    /* cannot clean object */
    cannotCleanMsg =
        '{Εσύ/Αυτός} δεν {ξέρω} πως να  {καθαρίζω} {τον dobj/αυτόν}<<withTensePresent>>. '
    cannotCleanWithMsg =
        '{Εσύ/Αυτός} δεν {μπορώ} να  {καθαρίζω} κάτι με {τον iobj/αυτόν}.<<withTensePresent>> '

    /* cannot attach key (dobj) to (iobj) */
    cannotAttachKeyToMsg =
        '{Εσύ/Αυτός} δεν {μπορώ} να  {συνδέω} {τον dobj/αυτόν} με {τον iobj/αυτόν}.<<withTensePresent>> '

    /* actor cannot sleep */
    cannotSleepMsg = '{Εσύ/Αυτός} δεν {χρειάζομαι} ύπνο αυτή τη στιγμή. '

    /* cannot sit/lie/stand/get on/get out of */
    cannotSitOnMsg =
        '{Ο dobj/αυτός} δεν {είμαι} κάτι πάνω στο οποίο {εσύ/αυτός} {μπορώ} να  {κάθομαι}.<<withTensePresent>> '
    cannotLieOnMsg =
        '{Ο dobj/αυτός} δεν {είμαι} κάτι πάνω στο οποίο {εσύ/αυτός} {μπορώ} να  {ξαπλώνω}.<<withTensePresent>> '
    cannotStandOnMsg = '{Εσύ/Αυτός} δεν {μπορώ} να  {στέκομαι} πάνω {στον dobj/σεαυτόν}.<<withTensePresent>> '
    cannotBoardMsg = '{Εσύ/Αυτός} δεν {μπορώ} να  {επιβιβάζομαι} {στον dobj/σεαυτόν}.<<withTensePresent>> '
    cannotUnboardMsg = '{Εσύ/Αυτός} δεν {μπορώ} να  {βγαίνω} από {τον dobj/αυτόν}.<<withTensePresent>> '
    cannotGetOffOfMsg = '{Εσύ/Αυτός} δεν {μπορώ} να  {κατεβαίνω} από {τον dobj/αυτόν}.<<withTensePresent>> '

    /* standing on a PathPassage */
    cannotStandOnPathMsg = 'Αν {εσύ/αυτός} {θέλω} να  {ακολουθώ} {τον dobj/αυτόν}, πρέπει απλά να το {λέω}.<<withTensePresent>> '

    /* cannot sit/lie/stand on something being held */
    cannotEnterHeldMsg =
        '{Εσύ/Αυτός} δεν {μπορώ}  να  {κάνω} κάτι τέτοιο ενώ <<withTensePresent>>{κρατάω} {τον dobj/αυτόν}. '

    /* cannot get out (of current location) */
    cannotGetOutMsg = '{Εσύ/Αυτός} δεν {είμαι} μέσα σε κάτι απο το οποίο να  {μπορώ} να {αποβιβάζομαι}.<<withTensePresent>> '

    /* actor is already in a location */
    alreadyInLocMsg = '{Εσύ/Αυτός} {είμαι} ήδη {μέσα dobj}. '

    /* actor is already standing/sitting on/lying on */
    alreadyStandingMsg = '{Εσύ/Αυτός} ήδη {στέκομαι}. '
    alreadyStandingOnMsg = '{Εσύ/Αυτός} ήδη {στέκομαι} {πάνω dobj}. '
    alreadySittingMsg = '{Εσύ/Αυτός} ήδη {κάθομαι}. '
    alreadySittingOnMsg = '{Εσύ/Αυτός} ήδη {κάθομαι} {πάνω dobj}. '
    alreadyLyingMsg = '{Εσύ/Αυτός} {έχω} ήδη ξαπλώσει κάτω. '
    alreadyLyingOnMsg = '{Εσύ/Αυτός} {έχω} ήδη ξαπλώσει {πάνω dobj}. '

    /* getting off something you're not on */
    notOnPlatformMsg = '{Εσύ/Αυτός} δεν {είμαι} {πάνω dobj}. '

    /* no room to stand/sit/lie on dobj */
    noRoomToStandMsg =
        'Δεν {υπάρχει| υπήρχε} χώρος ώστε {εσύ/αυτός}  να  {στέκομαι} {πάνω dobj}.<<withTensePresent>> '
    noRoomToSitMsg =
        'Δεν {υπάρχει| υπήρχε} χώρος ώστε {εσύ/αυτός}  να  {κάθομαι} {πάνω dobj}.<<withTensePresent>> '
    noRoomToLieMsg =
        'Δεν {υπάρχει| υπήρχε} χώρος ώστε {εσύ/αυτός}  να  {ξαπλώνω} {πάνω dobj}.<<withTensePresent>> '

    /* default report for standing up/sitting down/lying down */
    okayPostureChangeMsg(posture)
        { return 'Εντάξει, τώρα ' + posture.participle + '. '; }

    /* default report for standing/sitting/lying in/on something */
    roomOkayPostureChangeMsg(posture, obj)
    {
        gMessageParams(obj);
        return 'Εντάξει, τώρα ' + posture.participle + ' {πάνω obj}. ';
    }

    /* default report for getting off of a platform */
    okayNotStandingOnMsg = 'Εντάξει, δεν {είμαι} πια πάνω {πάνω dobj}. '

    /* cannot fasten/unfasten */
    cannotFastenMsg = '{Εσύ/Αυτός} δεν {μπορώ}  να  {δένω} {τον dobj/αυτόν}. '
    cannotFastenToMsg =
        '{Εσύ/Αυτός} δεν {μπορώ}  να  {δένω} τίποτα {στον iobj/σεαυτόν}.<<withTensePresent>> '
    cannotUnfastenMsg = '{Εσύ/Αυτός} δεν {μπορώ}  να  {λύνω} {τον dobj/αυτόν}.<<withTensePresent>> '
    cannotUnfastenFromMsg =
        '{Εσύ/Αυτός} δεν {μπορώ} να  {λύνω} τίποτα από {τον iobj/αυτόν}.<<withTensePresent>> '

    /* cannot plug/unplug */
    cannotPlugInMsg = '{Εσύ/Αυτός} δεν {βλέπω} κάποιον τρόπο για να  {συνδέω} {τον dobj/αυτόν}.<<withTensePresent>> '
    cannotPlugInToMsg =
        '{Εσύ/Αυτός} δεν {βλέπω} κάποιον τρόπο να  {συνδέω} το οτιδήποτε μέσα {στον iobj/σεαυτόν}.<<withTensePresent>> '
    cannotUnplugMsg = '{Εσύ/Αυτός} δεν {βλέπω} κάποιον τρόπο ώστε να  απο{συνδέω} {τον dobj/αυτόν}.<<withTensePresent>> '
    cannotUnplugFromMsg =
        '{Εσύ/Αυτός} δεν {βλέπω} να  απο{συνδέω} κάτι από {τον iobj/αυτόν}.<<withTensePresent>> '

    /* cannot screw/unscrew */
    cannotScrewMsg = '{Εσύ/Αυτός} δεν {βλέπω} κάποιον τρόπο να  {βιδώνω} {τον dobj/αυτόν}.<<withTensePresent>> '
    cannotScrewWithMsg =
        '{Εσύ/Αυτός} δεν {μπορώ} να  {βιδώνω} κάτι με {τον iobj/αυτόν}.<<withTensePresent>> '
    cannotUnscrewMsg = '{Εσύ/Αυτός} δεν {βλέπω} κάποιον τρόπο για να  ξε{βιδώνω} {τον dobj/αυτόν}. '
    cannotUnscrewWithMsg =
        '{Εσύ/Αυτός} δεν {μπορώ} να  ξε{βιδώνω} το οτιδήποτε με {τον iobj/αυτόν}.<<withTensePresent>> '

    /* cannot enter/go through */
    cannotEnterMsg =
        '{εκείνος/εκείνο dobj} δεν {είμαι} κάτι στο οποίο {εσύ/αυτός} {μπορώ} να  {εισέρχομαι}.<<withTensePresent>> '
    cannotGoThroughMsg =
        '{εκείνος/εκείνο dobj} δεν {είμαι} κάτι μέσα από το οποίο {Εσύ/Αυτός} {μπορώ} να  {περνάω}.<<withTensePresent>> '
        
    /* can't throw something at itself */
    cannotThrowAtSelfMsg =
        '{Εσύ/Αυτός} δεν {μπορώ} να  {ρίχνω} {εκείνος dobj/εκείνο} στον εαυτό {μου/σου/του}.<<withTensePresent>> '

    /* can't throw something at an object inside itself */
    cannotThrowAtContentsMsg = '{Εσύ/Αυτός} πρέπει πρώτα να  {αφαιρώ} {τον iobj/αυτόν}
        από {τον dobj/αυτόν} πρωτού {αυτός actor} {κάνω} κάτι τέτοιο.<<withTensePresent>> '

    /* can't throw through a sense connector */
    cannotThrowThroughMsg(target, loc)
    {
        gMessageParams(target, loc);
        return '{Εσύ/αυτός} δεν {μπορώ} να  {ρίχνω} τίποτα μέσα από {τον loc/αυτόν}. ';
    }

    /* shouldn't throw something at the floor */
    shouldNotThrowAtFloorMsg =
        '{Εσύ/Αυτός} θα {πρέπει|έπρεπε} απλά να { [τοποθετώ]|<<withTenseYpers>>[τοποθετώ]} {το dobj/αυτό} κάτω.<<withTensePresent>> '

    /* THROW <obj> <direction> isn't supported; use THROW AT instead */
    dontThrowDirMsg =
        ('<.parser>Πρέπει να κάνεις πιο σαφές σε τι θέλεις ' + (gActor.referralPerson == ThirdPerson
                      ? ' {ο actor/αυτός}' : '')
         + ' να  {ρίχνω} {τον dobj/αυτόν}.<./parser> ')

    /* thrown object bounces off target (short report) */
    throwHitMsg(projectile, target)
    {
        gMessageParams(projectile, target);
        return '{Ο projectile/αυτός} {χτυπά|χτύπησε} {τον target/αυτόν} χωρίς κάποιο εμφανές αποτέλεσμα. ';
    }

    /* thrown object lands on target */
    throwFallMsg(projectile, target)
    {
        gMessageParams(projectile, target);
        return '{Ο projectile/αυτός} {προσγειώνεται|προσγειώθηκε} πάνω {στον target/σεαυτόν}. ';
    }

    /* thrown object bounces off target and falls to destination */
    throwHitFallMsg(projectile, target, dest)
    {
        gMessageParams(projectile, target);
        return '{ο projectile/αυτός} {χτυπά|χτύπησε} {τον target/αυτόν}
            χωρίς κάποιο εμφανές αποτέλεσμα, και {ο projectile/αυτός} {πέφτει|έπεσε} '
            + dest.putInName + '. ';
    }

    /* thrown object falls short of distant target (sentence prefix only) */
    throwShortMsg(projectile, target)
    {
        gMessageParams(projectile, target);
        return '{Ο projectile/αυτός} {πέφτει|έπεσε} μακριά από '
               + '{τον target/αυτόν}. ';
    }
        
    /* thrown object falls short of distant target */
    throwFallShortMsg(projectile, target, dest)
    {
        gMessageParams(projectile, target);
        return '{Ο projectile/αυτός} {πέφτει|έπεσε} ' + dest.putInName
            + ' μακριά από {τον target/αυτόν}. ';
    }

    /* target catches object */
    throwCatchMsg(obj, target)
    {
        return '\^' + target.oName + ' '
            + tSel('πιάνει', 'έπιασε')
            + ' ' + obj.tonNameObj + '. ';
    }

    /* we're not a suitable target for THROW TO (because we're not an NPC) */
    cannotThrowToMsg = '{Εσύ/Αυτός} δεν {μπορώ} να {ρίχνω} το οτιδήποτε {στον iobj/σεαυτόν}. '

    /* target does not want to catch anything */
    willNotCatchMsg(catcher)
    {
        return '\^' + 'Δεν φαίνεται ' + catcher.oName + ' να θέλει να πιάσει το οτιδήποτε. ';
    }

    /* cannot kiss something */
    cannotKissMsg = 'Με το να {φιλάω} {τον dobj/αυτόν} δεν {καταφέρνω} κάτι. '

    /* person uninterested in being kissed */
    cannotKissActorMsg
        = 'Πιθανότατα να μην άρεσε κάτι τέτοιο {στον dobj/σεαυτόν}. '

    /* cannot kiss yourself */
    cannotKissSelfMsg = '{Εσύ/Αυτός} δεν {μπορώ} να  {φιλάω} τον εαυτό {μου/σου/του}.<<withTensePresent>> '

    /* it is now dark at actor's location */
    newlyDarkMsg = '{Επικρατεί|Επικρατούσε} πλέον το απόλυτο σκοτάδι. '
;

/*
 *   Non-player character verb messages.  By default, we inherit all of
 *   the messages defined for the player character, but we override some
 *   that must be rephrased slightly to make sense for NPC's.
 */
npcActionMessages: playerActionMessages
    /* "wait" */
    timePassesMsg = '{Εσύ/Αυτός} {[περιμένω]|<<withTenseAoristos>>[περιμένω]}<<withTensePresent>>... '

    /* trying to move a Fixture/Immovable */
    cannotMoveFixtureMsg = '{Εσύ/Αυτός} δεν {μπορώ} να  {μετακινώ} {τον dobj/αυτόν}. '
    cannotMoveImmovableMsg = 'δεν {μπορώ} να  {μετακινώ} {τον dobj/αυτόν}. '

    /* trying to take/move/put a Heavy object */
    cannotTakeHeavyMsg =
        '{That dobj/he} {είμαι} πολύ βαρ{-ύς-ιά-ύ} για να   {μπορώ} να το {μετακινώ}.<<withTensePresent>> '
    cannotMoveHeavyMsg =
        '{That dobj/he} {είμαι} πολύ βαρ{-ύς-ιά-ύ} για να   {μπορώ} να το {μετακινώ}.<<withTensePresent>> '
    cannotPutHeavyMsg =
        '{That dobj/he} {είμαι} πολύ βαρ{-ύς-ιά-ύ} για να   {μπορώ} να το {μετακινώ}.<<withTensePresent>> '

    /* trying to move a component object */
    cannotMoveComponentMsg(loc)
    {
        return '{Εσύ/Αυτός} δεν {μπορώ} να το  {κάνω} αυτό, διότι {ο dobj/αυτός} <<withTensePresent>>{είμαι} μέρος ' + loc.touNameObj + '. ';
    }

    /* default successful 'take' response */
    okayTakeMsg = '{Εσύ/Αυτός} {[παίρνω]|<<withTenseAoristos>>[παίρνω]} {τον dobj/αυτόν}.<<withTensePresent>> '

    /* default successful 'drop' response */
    okayDropMsg = '{Εσύ/Αυτός} {αφήνω} {τον dobj/αυτόν} κάτω. '

    /* default successful 'put in' response */
    okayPutInMsg = '{Εσύ/Αυτός} {βάζω} {τον dobj/αυτόν} μέσα {στον iobj/σεαυτόν}. '

    /* default successful 'put on' response */
    okayPutOnMsg = '{Εσύ/Αυτός} {βάζω} {τον dobj/αυτόν} πάνω {στον iobj/σεαυτόν}. '

    /* default successful 'put under' response */
    okayPutUnderMsg =
        '{Εσύ/Αυτός} {βάζω} {τον dobj/αυτόν} κάτω από {τον iobj/αυτόν}. '

    /* default successful 'put behind' response */
    okayPutBehindMsg =
        '{Εσύ/Αυτός} {βάζω} {τον dobj/αυτόν} πίσω από {τον iobj/αυτόν}. '

    /* default succesful response to 'wear obj' */
    okayWearMsg =
        '{Εσύ/Αυτός} {φοράω} {τον dobj/αυτόν}. '

    /* default successful response to 'doff obj' */
    okayDoffMsg = '{Εσύ/Αυτός} {βγάζω} {τον dobj/αυτόν}. '

    /* default successful responses to open/close */
    okayOpenMsg = '{Εσύ/Αυτός} {[ανοίγω]|<<withTenseAoristos>>[ανοίγω]} {τον dobj/αυτόν}.<<withTensePresent>> '
    okayCloseMsg = '{Εσύ/Αυτός} {[κλείνω]|<<withTenseAoristos>>[κλείνω]} {τον dobj/αυτόν}.<<withTensePresent>> '

    /* default successful responses to lock/unlock */
    okayLockMsg = '{Εσύ/Αυτός} {[κλειδώνω] | <<withTenseAoristos>>[κλειδώνω]} {τον dobj/αυτόν}.<<withTensePresent>> '
    okayUnlockMsg = '{Εσύ/Αυτός} ξε{[κλειδώνω] | <<withTenseAoristos>>[κλειδώνω]} {τον dobj/αυτόν}.<<withTensePresent>> '

    /* push/pull/move with no effect */
    pushNoEffectMsg = '{Εσύ/Αυτός} {[προσπαθώ]|<<withTenseAoristos>>[προσπαθώ]} να   {σπρώχνω} {τον dobj/αυτόν}, με κανένα '
                      + 'εμφανές αποτέλεσμα.<<withTensePresent>>. '
    pullNoEffectMsg = '{Εσύ/Αυτός} {[προσπαθώ]|<<withTenseAoristos>>[προσπαθώ]} να   {τραβάω} {τον dobj/αυτόν}, με κανένα '
                      + 'εμφανές αποτέλεσμα.<<withTensePresent>> '
    moveNoEffectMsg = '{Εσύ/Αυτός} {[προσπαθώ]|<<withTenseAoristos>>[προσπαθώ]} να   {μετακινώ} {τον dobj/αυτόν}, με κανένα '
                      + 'εμφανές αποτέλεσμα.<<withTensePresent>> '
    moveToNoEffectMsg = '{Εσύ/Αυτός} {αφήνω} {τον dobj/αυτόν} στην θέση που {είναι|ήταν}. '

    whereToGoMsg =
        'Θα πρέπει να αναφέρεις προς τα ποια κατεύθυνση {Εσύ/Αυτός} θα {πρέπει|έπρεπε} να { [πηγαίνω]|<<withTenseYpers>>[πηγαίνω]}.<<withTensePresent>> '

    /* object is too large for container */
    tooLargeForContainerMsg(obj, cont)
    {
        gMessageParams(obj, cont);
        return '{Εσύ/Αυτός} δεν {μπορώ} να το  {κάνω} αυτό, διότι {ο obj/αυτός} <<withTensePresent>>{είμαι}
            πολύ μεγάλ{-ος-η-ο} για {τον cont/αυτόν}.<<withTensePresent>> ';
    }

    /* object is too large for underside */
    tooLargeForUndersideMsg(obj, cont)
    {
        gMessageParams(obj, cont);
        return '{Εσύ/Αυτός} δεν {μπορώ} να το  {κάνω} αυτό, διότι {ο obj/αυτός}
            δεν <<withTenseStigFuture>>{χωράω} κάτω από {τον cont/αυτόν}.<<withTensePresent>> ';
    }

    /* object is too large to fit behind something */
    tooLargeForRearMsg(obj, cont)
    {
        gMessageParams(obj, cont);
        return '{Εσύ/Αυτός} δεν {μπορώ} να το  {κάνω} αυτό, διότι {ο obj/αυτός}
            δεν <<withTenseStigFuture>>{χωράω} πίσω από {τον cont/αυτόν}.<<withTensePresent>> ';
    }

    /* container doesn't have room for object */
    containerTooFullMsg(obj, cont)
    {
        gMessageParams(obj, cont);
        return '{Εσύ/Αυτός} δεν {μπορώ} να το  {κάνω} αυτό, διότι {ο cont/αυτός} <<withTensePresent>>{είμαι}
            ήδη υπερπλήρ{-ης-ης-ες} για να  {χωράω} {τον obj/αυτόν}.<<withTensePresent>> ';
    }

    /* surface doesn't have room for object */
    surfaceTooFullMsg(obj, cont)
    {
        gMessageParams(obj, cont);
        return '{Εσύ/Αυτός} δεν {μπορώ} να το  {κάνω} αυτό, διότι δεν {υπάρχει| υπήρχε}
            χώρος για {τον obj/αυτόν} πάνω {στον cont/σεαυτόν}.<<withTensePresent>> ';
    }

    /* the dobj doesn't fit on this keyring */
    objNotForKeyringMsg = '{Εσύ/Αυτός} δεν {μπορώ} να το  {κάνω} αυτό, διότι {that dobj/he}
        δεν <<withTensePresent>>{χωράω} {στον iobj/σεαυτόν}.<<withTensePresent>> '

    /* taking dobj from iobj, but dobj isn't in iobj */
    takeFromNotInMsg = '{Εσύ/Αυτός} δεν {μπορώ} να το  {κάνω} αυτό, διότι
        {ο dobj/αυτός}  δεν <<withTensePresent>>{είμαι} μέσα {στον iobj/σεαυτόν}.<<withTensePresent>> '

    /* taking dobj from surface, but dobj isn't on iobj */
    takeFromNotOnMsg = '{Εσύ/Αυτός} δεν {μπορώ} να το  {κάνω} αυτό, διότι
        {ο dobj/αυτός}  δεν <<withTensePresent>>{είμαι} πάνω {στον iobj/σεαυτόν}.<<withTensePresent>> '

    /* taking dobj under something, but dobj isn't under iobj */
    takeFromNotUnderMsg = '{Εσύ/Αυτός} δεν {μπορώ} να το  {κάνω} αυτό, διότι
        {ο dobj/αυτός}  δεν <<withTensePresent>>{είμαι} κάτω από {τον iobj/αυτόν}.<<withTensePresent>> '

    /* taking dobj from behind something, but dobj isn't behind iobj */
    takeFromNotBehindMsg = '{Εσύ/Αυτός} δεν {μπορώ} να το  {κάνω} αυτό, διότι
        {ο dobj/αυτός} δεν <<withTensePresent>>{είμαι} πίσω από {τον iobj/αυτόν}.<<withTensePresent>> '

    /* cannot jump off (with no direct object) from here */
    cannotJumpOffHereMsg = 'Δεν {υπάρχει|υπήρχε} κάποιο μέρος στο οποίο να {μπορώ} να  {πηδάω}.<<withTensePresent>> '

    /* should not break object */
    shouldNotBreakMsg = '{Εσύ/Αυτός} δεν {θέλω} να  {σπάω} {τον dobj/αυτόν}.<<withTensePresent>> '

    /* report for standing up/sitting down/lying down */
    okayPostureChangeMsg(posture)
        { return '{Εσύ/Αυτός} ' + posture.msgVerbI + '. '; }

    /* report for standing/sitting/lying in/on something */
    roomOkayPostureChangeMsg(posture, obj)
    {
        gMessageParams(obj);
        return '{Εσύ/Αυτός} ' + posture.msgVerbT + ' {on obj}. ';
    }

    /* report for getting off a platform */
    okayNotStandingOnMsg = '{Εσύ/Αυτός} {[κατεβαίνω]|<<withTenseAoristos>>[κατεβαίνω]} {offof dobj}.<<withTensePresent>> '

    /* default 'turn to' acknowledgment */
    okayTurnToMsg(val)
        { return '{Εσύ/Αυτός} {γυρνάω} {τον dobj/αυτόν} προς ' + val + '. '; }

    /* default 'push button' acknowledgment */
    okayPushButtonMsg = '{Εσύ/Αυτός} {πιέζω} {τον dobj/αυτόν}. '

    /* default acknowledgment for switching on/off */
    okayTurnOnMsg = '{Εσύ/Αυτός} {ενεργοποιώ} {τον dobj/αυτόν}. '
    okayTurnOffMsg = '{Εσύ/Αυτός} απ{ενεργοποιώ} {τον dobj/αυτόν}. '

    /* the key (iobj) does not fit the lock (dobj) */
    keyDoesNotFitLockMsg = '{Εσύ/Αυτός} {προσπαθώ} με {the iobj/he}, αλλά
                         {it iobj/he} δεν {χωράω} στην κλειδαριά. '

    /* acknowledge entering "follow" mode */
    okayFollowModeMsg = '<q>Εντάξει, θα ακολουθήσω {τον dobj/αυτόν}.</q> '

    /* note that we're already in "follow" mode */
    alreadyFollowModeMsg = '<q>Ακολουθώ ήδη {τον dobj/αυτόν}.</q> '

    /* extinguishing a candle */
    okayExtinguishCandleMsg = '{Εσύ/Αυτός} {σβήνω} {τον dobj/αυτόν}. '

    /* acknowledge attachment */
    okayAttachToMsg =
        '{Εσύ/Αυτός} {συνδέω} {τον dobj/αυτόν} {στο iobj/σεαυτόν}. '

    /* acknowledge detachment */
    okayDetachFromMsg =
        '{Εσύ/Αυτός} απο{συνδέω} {τον dobj/αυτόν} από {τον iobj/αυτόν}. '

    /*
     *   the PC's responses to conversational actions applied to oneself
     *   need some reworking for NPC's 
     */
    cannotTalkToSelfMsg = '{Εσύ/Αυτός} δεν <<withTenseStigFuture>>{καταφέρνω} κάτι με το να  {μιλάω}
	στον εαυτό {μου/σου/του}.<<withTensePresent>> '
    cannotAskSelfMsg = 'Εσύ/Αυτός} δεν <<withTenseStigFuture>>{καταφέρνω} κάτι με το να  {μιλάω}
	στον εαυτό {μου/σου/του}.<<withTensePresent>> '
    cannotAskSelfForMsg = 'Εσύ/Αυτός} δεν <<withTenseStigFuture>>{καταφέρνω} κάτι με το να  {μιλάω}
	στον εαυτό {μου/σου/του}.<<withTensePresent>> '
    cannotTellSelfMsg = 'Εσύ/Αυτός} δεν <<withTenseStigFuture>>{καταφέρνω} κάτι με το να  {μιλάω}
	στον εαυτό {μου/σου/του}.<<withTensePresent>> '
    cannotGiveToSelfMsg = 'Εσύ/Αυτός} δεν <<withTenseStigFuture>>{καταφέρνω} κάτι με το να  {δίνω}
	{τον dobj/αυτόν} στον εαυτό {μου/σου/του}.<<withTensePresent>> '
    cannotShowToSelfMsg = '{Εσύ/Αυτός} δεν <<withTenseStigFuture>>{καταφέρνω} κάτι με το να  
       δείχνω {τον dobj/αυτόν} στον εαυτό {μου/σου/του}.<<withTensePresent>> '
;

/* ------------------------------------------------------------------------ */
/*
 *   Standard tips
 */

scoreChangeTip: Tip
    "Αν θα προτιμούσατε να μην ενημερώνεστε για τις αλλαγές στο σκορ στο μέλλον,
	πληκτρολογήστε <<aHref('ανενεργές ενημερώσεις', 'ΑΝΕΝΕΡΓΕΣ ΕΝΗΜΕΡΩΣΕΙΣ', 'Απενεργοποίηση ενημερώσεων για το σκορ')>>."
;

footnotesTip: Tip
    "Ένας αριθμός σε [αγκυλες], όπως αυτός παραπάνω, αναφέρεται σε μια υποσημείωση,
    την οποία μπορείτε να διαβάσετε πληκτρολογώντας ΥΠΟΣΗΜΕΙΩΣΗ ακολουθούμενο από τον αριθμό. Για παράδειγμα:
    <<aHref('υποσημείωση 1', 'ΥΠΟΣΗΜΕΙΩΣΗ 1', 'Δείξε υποσημείωση [1]')>>.
    Οι υποσημειώσεις συνήθως περιέχουν επιπρόσθετες πληροφορίες που ίσως να φανούν ενδιαφέρουσες
    αλλά δεν είναι απαραίτητες για την ιστορία. Αν θα προτιμούσατε να μην βλέπετε καθόλου υποσημειώσεις,
	μπορείτε να ελέγξετε την εμφάνισή τους πληκτρολογώντας <<aHref('υποσημειώσεις', 'ΥΠΟΣΗΜΕΙΩΣΕΙΣ', 'Έλεγχος εμφάνισης υποσημειώσεων')>>."
;

oopsTip: Tip
    "Αν αυτό ήταν ένα ακούσιο ορθογραφικό λάθος, μπορείτε να το διορθώσετε πληκτρολογώντας ΟΥΠΣ 
	ακολουθούμενο από τη διορθωμένη λέξη. 
	Κάθε φορά που η ιστορία επισημαίνει μια άγνωστη λέξη, 
	μπορείτε να διορθώσετε ένα ορθογραφικό λάθος χρησιμοποιώντας το ΟΥΠΣ 
	ως την επόμενη εντολή σας."
;

fullScoreTip: Tip
    "Για εμφάνιση λεπτομερούς καταγραφής του σκορ, πληκτρολογήστε
    <<aHref('πλήρες σκορ', 'ΠΛΗΡΕΣ ΣΚΟΡ')>>."
;

exitsTip: Tip
    "Μπορείτε να ελέγξετε τις λίστες με τις εξόδους με την εντολή ΕΞΟΔΟΙ.
    <<aHref('κατάσταση εξόδων', 'ΚΑΤΑΣΤΑΣΗ ΕΞΟΔΩΝ',
            'Ενεργοποίηση την γραμμή κατάστασης εξόδων')>>
    δείχνει τη λίστα εξόδων στη γραμμή κατάστασης,
    <<aHref('περιγραφή εξόδων', 'ΠΕΡΙΓΡΑΦΗ ΕΞΟΔΩΝ', 'Καταγραφή των εξόδων στις περιγραφές δωματίων')>>
    δείχνει την πλήρη λίστα εξόδων σε κάθε περιγραφή δωματίου,
    <<aHref('έξοδοι ενεργές', 'ΕΞΟΔΟΙ ΕΝΕΡΓΕΣ', 'Ενεργοποίηση όλων των λιστών εξόδων')>>
    δείχνει και τα δύο, και
    <<aHref('έξοδοι ανενεργές', 'ΕΞΟΔΟΙ ΑΝΕΝΕΡΓΕΣ', 'Απενεργοποίηση όλων των λιστών εξόδων')>>
    απενεργοποιεί και τα δύο είδη λιστών εξόδων."
;

undoTip: Tip
    "Αν η επιλογή σου δεν οδήγησε σε αυτό που περίμενες, να γνωρίζεις ότι μπορείς πάντα να πας μια εντολή πίσω πληκτρολογώντας <<aHref('αναίρεση', 'ΑΝΑΙΡΕΣΗ',
        'Αναίρεση της πιο πρόσφατης εντολής')>>. Μπορείς ακόμα να το κάνεις επανειλημμένα για να αναιρέσεις πολλές διαδοχικές επιλογές σου. "
;


/* ------------------------------------------------------------------------ */
/*
 *   Listers
 */

/*
 *   The basic "room lister" object - this is the object that we use by
 *   default with showList() to construct the listing of the portable
 *   items in a room when displaying the room's description.  
 */
roomLister: Lister
    /* show the prefix/suffix in wide mode */
    showListPrefixWide(itemCount, pov, parent) { "{Εσύ/Αυτός} {βλέπω}<<withListCaseAccusative>><<withListArtIndefinite>> "; }
    showListSuffixWide(itemCount, pov, parent) { " εδώ. "; }

    /* show the tall prefix */
    showListPrefixTall(itemCount, pov, parent) { "{Eσύ/αυτός} {βλέπω}:<<withListCaseAccusative>><<withListArtIndefinite>>"; }
;

/*
 *   The basic room lister for dark rooms 
 */
darkRoomLister: Lister
    showListPrefixWide(itemCount, pov, parent)
        { "Μέσα στο σκοτάδι {εσύ/αυτός} {βλέπω}<<withListCaseAccusative>><<withListArtIndefinite>> "; }

    showListSuffixWide(itemCount, pov, parent) { ". "; }

    showListPrefixTall(itemCount, pov, parent)
        { "Μέσα στο σκοτάδι {εσύ/αυτός} {βλέπω}:<<withListCaseAccusative>><<withListArtIndefinite>>"; }
;

/*
 *   A "remote room lister".  This is used to describe the contents of an
 *   adjoining room.  For example, if an actor is standing in one room,
 *   and can see into a second top-level room through a window, we'll use
 *   this lister to describe the objects the actor can see through the
 *   window. 
 */
class RemoteRoomLister: Lister
    construct(room) { remoteRoom = room; }
    
    showListPrefixWide(itemCount, pov, parent)
        { "\^<<remoteRoom.inRoomName(pov)>>, {εσύ/αυτός} {βλέπω}<<withListCaseAccusative>><<withListArtIndefinite>> "; }
    showListSuffixWide(itemCount, pov, parent)
        { ". "; }

    showListPrefixTall(itemCount, pov, parent)
        { "\^<<remoteRoom.inRoomName(pov)>>, {εσύ/αυτός} {βλέπω}:<<withListCaseAccusative>><<withListArtIndefinite>>"; }

    /* the remote room we're viewing */
    remoteRoom = nil
;

/*
 *   A simple customizable room lister.  This can be used to create custom
 *   listers for things like remote room contents listings.  We act just
 *   like any ordinary room lister, but we use custom prefix and suffix
 *   strings provided during construction.  
 */
class CustomRoomLister: Lister
    construct(prefix, suffix)
    {
        prefixStr = prefix;
        suffixStr = suffix;
    }

    showListPrefixWide(itemCount, pov, parent) { "<<prefixStr>> "; }
    showListSuffixWide(itemCount, pov, parent) { "<<suffixStr>> "; }
    showListPrefixTall(itemCount, pov, parent) { "<<prefixStr>>:"; }

    /* our prefix and suffix strings */
    prefixStr = nil
    suffixStr = nil
;

/*
 *   Single-list inventory lister.  This shows the inventory listing as a
 *   single list, with worn items mixed in among the other inventory items
 *   and labeled "(being worn)".  
 */
actorSingleInventoryLister: InventoryLister
    showListPrefixWide(itemCount, pov, parent)
        { "<<buildSynthParam('Εσύ/Αυτός', parent)>> {κουβαλάω}<<withListCaseAccusative>><<withListArtIndefinite>> "; }
    showListSuffixWide(itemCount, pov, parent)
        { ". "; }

    showListPrefixTall(itemCount, pov, parent)
        { "<<buildSynthParam('Εσύ/Αυτός', parent)>> {κουβαλάω}<<withListCaseAccusative>><<withListArtIndefinite>>:"; }
    showListContentsPrefixTall(itemCount, pov, parent)
        { "<<buildSynthParam('Εσύ/Αυτός', parent)>>, που {κουβαλάω}<<withListCaseAccusative>><<withListArtIndefinite>>:"; }

    showListEmpty(pov, parent)
        { "<<buildSynthParam('Εσύ/Αυτός', parent)>> {έχω} άδεια χέρια. "; }
;

/*
 *   Standard inventory lister for actors - this will work for the player
 *   character and NPC's as well.  This lister uses a "divided" format,
 *   which segregates the listing into items being carried and items being
 *   worn.  We'll combine the two lists into a single sentence if the
 *   overall list is short, otherwise we'll show two separate sentences for
 *   readability.  
 */
actorInventoryLister: DividedInventoryLister
    /*
     *   Show the combined inventory listing, putting together the raw
     *   lists of the items being carried and the items being worn. 
     */
    showCombinedInventoryList(parent, carrying, wearing)
    {
        /* if one or the other sentence is empty, the format is simple */
        if (carrying == '' && wearing == '')
        {
            /* the parent is completely empty-handed */
            showInventoryEmpty(parent);
        }
        else if (carrying == '')
        {
            /* the whole list is being worn */
            showInventoryWearingOnly(parent, wearing);
        }
        else if (wearing == '')
        {
            /* the whole list is being carried */
            showInventoryCarryingOnly(parent, carrying);
        }
        else
        {
            /*
             *   Both listings are populated.  Count the number of
             *   comma-separated or semicolon-separated phrases in each
             *   list.  This will give us an estimate of the grammatical
             *   complexity of each list.  If we have very short lists, a
             *   single sentence will be easier to read; if the lists are
             *   long, we'll show the lists in separate sentences.  
             */
            if (countPhrases(carrying) + countPhrases(wearing)
                <= singleSentenceMaxNouns)
            {
                /* short enough: use a single-sentence format */
                showInventoryShortLists(parent, carrying, wearing);
            }
            else
            {
                /* long: use a two-sentence format */
                showInventoryLongLists(parent, carrying, wearing);
            }
        }
    }

    /*
     *   Count the noun phrases in a string.  We'll count the number of
     *   elements in the list as indicated by commas and semicolons.  This
     *   might not be a perfect count of the actual number of noun phrases,
     *   since we could have commas setting off some other kind of clauses,
     *   but it nonetheless will give us a good estimate of the overall
     *   complexity of the text, which is what we're really after.  The
     *   point is that we want to break up the listings if they're long,
     *   but combine them into a single sentence if they're short.  
     */
    countPhrases(txt)
    {
        local cnt;
        
        /* if the string is empty, there are no phrases at all */
        if (txt == '')
            return 0;

        /* a non-empty string has at least one phrase */
        cnt = 1;

        /* scan for commas and semicolons */
        for (local startIdx = 1 ;;)
        {
            local idx;
            
            /* find the next phrase separator */
            idx = rexSearch(phraseSepPat, txt, startIdx);

            /* if we didn't find it, we're done */
            if (idx == nil)
                break;

            /* count it */
            ++cnt;

            /* continue scanning after the separator */
            startIdx = idx[1] + idx[2];
        }

        /* return the count */
        return cnt;
    }
//###I replaced the english semicolon ; with the greek semicolon ·
    phraseSepPat = static new RexPattern(',(?! και )|·| και |<rparen>')

    /*
     *   Once we've made up our mind about the format, we'll call one of
     *   these methods to show the final sentence.  These are all separate
     *   methods so that the individual formats can be easily tweaked
     *   without overriding the whole combined-inventory-listing method. 
     */
    showInventoryEmpty(parent)
    {
        /* empty inventory */
        "<<buildSynthParam('Εσύ/αυτός', parent)>> {έχω} άδεια χέρια. ";
    }
    showInventoryWearingOnly(parent, wearing)
    {
        /* we're carrying nothing but wearing some items */
        "<<buildSynthParam('Εσύ/αυτός', parent)>> δεν {κουβαλάω} τίποτα,
        και {φοράω} <<wearing>>. ";
    }
    showInventoryCarryingOnly(parent, carrying)
    {
        /* we have only carried items to report */
        "<<buildSynthParam('Εσύ/αυτός', parent)>> {κουβαλάω} <<carrying>>. ";
    }
    showInventoryShortLists(parent, carrying, wearing)
    {
        local nm = gSynthMessageParam(parent);
        
        /* short lists - combine carried and worn in a single sentence */
        "<<buildParam('Εσύ/αυτός', nm)>> {κουβαλάω} <<carrying>>,
        και {φοράω} <<wearing>>. ";
    }
    showInventoryLongLists(parent, carrying, wearing)
    {
        local nm = gSynthMessageParam(parent);

        /* long lists - show carried and worn in separate sentences */
        "<<buildParam('Εσύ/αυτός', nm)>> {κουβαλάω} <<carrying>>.
        <<buildParam('Εσύ/αυτός', nm)>> {φοράω} <<wearing>>. ";
    }

    /*
     *   For 'tall' listings, we'll use the standard listing style, so we
     *   need to provide the framing messages for the tall-mode listing.  
     */
    showListPrefixTall(itemCount, pov, parent)
        { "<<buildSynthParam('Εσύ/αυτός', parent)>> {κουβαλάω} :"; }
    showListContentsPrefixTall(itemCount, pov, parent)
        { "<<buildSynthParam('Ένας/αυτός', parent)>>, που {κουβαλάω}:"; }
    showListEmpty(pov, parent)
        { "<<buildSynthParam('Εσύ/αυτός', parent)>> {έχω} άδεια χέρια. "; }
;

/*
 *   Special inventory lister for non-player character descriptions - long
 *   form lister.  This is used to display the inventory of an NPC as part
 *   of the full description of the NPC.
 *   
 *   This long form lister is meant for actors with lengthy descriptions.
 *   We start the inventory listing on a new line, and use the actor's
 *   full name in the list preface.  
 */
actorHoldingDescInventoryListerLong: actorInventoryLister
    showInventoryEmpty(parent)
    {
        /* empty inventory - saying nothing in an actor description */
    }
    showInventoryWearingOnly(parent, wearing)
    {
        /* we're carrying nothing but wearing some items */
        "<.p><<buildSynthParam('Εσύ/αυτός', parent)>> {φοράω} <<wearing>>. ";
    }
    showInventoryCarryingOnly(parent, carrying)
    {
        /* we have only carried items to report */
        "<.p><<buildSynthParam('Εσύ/αυτός', parent)>> {κουβαλάω} <<carrying>>. ";
    }
    showInventoryShortLists(parent, carrying, wearing)
    {
        local nm = gSynthMessageParam(parent);

        /* short lists - combine carried and worn in a single sentence */
        "<.p><<buildParam('Εσύ/αυτός', nm)>> {κουβαλάω} <<carrying>>,
        και {φοράω} <<wearing>>. ";
    }
    showInventoryLongLists(parent, carrying, wearing)
    {
        local nm = gSynthMessageParam(parent);

        /* long lists - show carried and worn in separate sentences */
        "<.p><<buildParam('Εσύ/αυτός', nm)>> {κουβαλάω} <<carrying>>.
        <<buildParam('Εσύ/αυτός', nm)>> {φοράω} <<wearing>>. ";
    }
;

/* short form of non-player character description inventory lister */
actorHoldingDescInventoryListerShort: actorInventoryLister
    showInventoryEmpty(parent)
    {
        /* empty inventory - saying nothing in an actor description */
    }
    showInventoryWearingOnly(parent, wearing)
    {
        /* we're carrying nothing but wearing some items */
        "<<buildSynthParam('Εσύ/Αυτός', parent)>> {φοράω} <<wearing>>. ";
    }
    showInventoryCarryingOnly(parent, carrying)
    {
        /* we have only carried items to report */
        "<<buildSynthParam('Εσύ/αυτός', parent)>> {κουβαλάω} <<carrying>>. ";
    }
    showInventoryShortLists(parent, carrying, wearing)
    {
        local nm = gSynthMessageParam(parent);

        /* short lists - combine carried and worn in a single sentence */
        "<<buildParam('Εσύ/αυτός', nm)>> {κουβαλάω} <<carrying>>, και {φοράω} <<wearing>>. ";
    }
    showInventoryLongLists(parent, carrying, wearing)
    {
        local nm = gSynthMessageParam(parent);

        /* long lists - show carried and worn in separate sentences */
        "<<buildParam('Εσύ/αυτός', nm)>> {κουβαλάω} <<carrying>>.
        <<buildParam('Εσύ/αυτός', nm)>> {φοράω} <<wearing>>. ";
    }
;

/*
 *   Base contents lister for things.  This is used to display the contents
 *   of things shown in room and inventory listings; we subclass this for
 *   various purposes 
 */
class BaseThingContentsLister: Lister
    showListPrefixWide(itemCount, pov, parent)
        { "\^<<parent.oName>> {περιέχει|περιείχε}<<withListCaseAccusative>> "; }
    showListSuffixWide(itemCount, pov, parent)
        { ". "; }
    showListPrefixTall(itemCount, pov, parent)
        { "<<parent.oName>> {περιέχει|περιείχε}:<<withListCaseAccusative>>"; }
    showListContentsPrefixTall(itemCount, pov, parent)
        { "<<parent.enasName>>, που {περιέχει|περιείχε}:<<withListCaseNominative>>"; }
	//##Back to the default case
	showListContentsSuffixTall(itemCount, pov, parent) 
        { "<<withListCaseAccusative>><<withListArtIndefinite>>"; }
;

/*
 *   Contents lister for things.  This is used to display the second-level
 *   contents lists for things listed in the top-level list for a room
 *   description, inventory listing, or object description.  
 */
thingContentsLister: ContentsLister, BaseThingContentsLister
;

/*
 *   Contents lister for descriptions of things - this is used to display
 *   the contents of a thing as part of the long description of the thing
 *   (in response to an "examine" command); it differs from a regular
 *   thing contents lister in that we use a pronoun to refer to the thing,
 *   rather than its full name, since the full name was probably just used
 *   in the basic long description.  
 */
thingDescContentsLister: DescContentsLister, BaseThingContentsLister
    showListPrefixWide(itemCount, pov, parent)
        { "\^<<parent.itOnom>> περιέχει<<withListCaseAccusative>><<withListArtIndefinite>> "; }
;

/*
 *   Contents lister for openable things.
 */
openableDescContentsLister: thingDescContentsLister
    showListEmpty(pov, parent)
    {
        "\^<<parent.openStatus>>. ";
    }
    showListPrefixWide(itemCount, pov, parent)
    {
        "\^<<parent.openStatus>>,<<withListCaseAccusative>><<withListArtIndefinite>> και περιέχει ";
    }
	showListSuffixWide(itemCount, pov, parent)
        { "<<withListCaseNominative>><<withListArtIndefinite>>. "; }

;

/*
 *   Base contents lister for "LOOK <PREP>" commands (LOOK IN, LOOK UNDER,
 *   LOOK BEHIND, etc).  This can be subclasses for the appropriate LOOK
 *   <PREP> command matching the container type - LOOK UNDER for
 *   undersides, LOOK BEHIND for rear containers, etc.  To use this class,
 *   combine it via multiple inheritance with the appropriate
 *   Base<Prep>ContentsLister for the preposition type.  
 */
class LookWhereContentsLister: DescContentsLister
    showListEmpty(pov, parent)
    {
        /* show a default message indicating the surface is empty */
        gMessageParams(parent);
        defaultDescReport('{Εσύ/αυτός} δεν {βλέπω} τίποτα ' + parent.objInPrep
                          + ' <<parent.stonNameObj>>. ');
    }
;

/*
 *   Contents lister for descriptions of things whose contents are
 *   explicitly inspected ("look in").  This differs from a regular
 *   contents lister in that we explicitly say that the object is empty if
 *   it's empty.
 */
thingLookInLister: LookWhereContentsLister, BaseThingContentsLister
    showListEmpty(pov, parent)
    {
        /*
         *   Indicate that the list is empty, but make this a default
         *   descriptive report.  This way, if we report any special
         *   descriptions for items contained within the object, we'll
         *   suppress this default description that there's nothing to
         *   describe, which is clearly wrong if there are
         *   specially-described contents. 
         */
        gMessageParams(parent);
        defaultDescReport('{Εσύ/αυτός} δεν {βλέπω} τίποτα ασυνήθιστο μέσα <<parent.stonNameObj>>. ');
    }
;

/*
 *   Default contents lister for newly-revealed objects after opening a
 *   container.  
 */
openableOpeningLister: BaseThingContentsLister
    showListEmpty(pov, parent) { }
    showListPrefixWide(itemCount, pov, parent)
    {
        /*
         *   This list is, by default, generated as a replacement for the
         *   default "Opened" message in response to an OPEN command.  We
         *   therefore need different messages for PC and NPC actions,
         *   since this serves as the description of the entire action.
         *   
         *   Note that if you override the Open action response for a given
         *   object, you might want to customize this lister as well, since
         *   the message we generate (especially for an NPC action)
         *   presumes that we'll be the only response the command.  
         */
        gMessageParams(pov, parent);
        if (pov.isPlayerChar())
            "<<withListCaseGenitive>>Το άνοιγμα {του parent/αυτού} αποκαλύπτει <<withListCaseAccusative>><<withListArtIndefinite>>";
        else
            "{Ο pov/αυτός} ανοίγει {τον parent/αυτόν}, αποκαλύπτοντας <<withListCaseAccusative>><<withListArtIndefinite>>";
    }
;

/*
 *   Base contents lister.  This class handles contents listings for most
 *   kinds of specialized containers - Surfaces, RearConainers,
 *   RearSurfaces, and Undersides.  The main variation in the contents
 *   listings for these various types of containers is simply the
 *   preposition that's used to describe the relationship between the
 *   container and the contents, and for this we can look to the objInPrep
 *   property of the container.  
 */
class BaseContentsLister: Lister
    showListPrefixWide(itemCount, pov, parent)
    {
        "\^<<parent.objInPrep>> <<parent.stonNameObj>>
        <<itemCount == 1 ? tSel('είναι', 'ήταν') : tSel('είναι', 'ήταν')>><<withListCaseNominative>><<withListArtIndefinite>> ";
    }
    showListSuffixWide(itemCount, pov, parent)
    {
        ".<<withListCaseAccusative>><<withListArtIndefinite>> ";
    }
    showListPrefixTall(itemCount, pov, parent)
    {
        "\^<<parent.objInPrep>> <<parent.stonNameObj>>
        <<itemCount == 1 ? tSel('είναι', 'ήταν') : tSel('είναι', 'ήταν')>>:<<withListCaseNominative>><<withListArtIndefinite>>";
    }
	//##We add the Suffix so we can return to the default case of the listcase (Accusative)
	showListSuffixTall(itemCount, pov, parent) 
    {
        "<<withListCaseAccusative>><<withListArtIndefinite>>";
    }
    showListContentsPrefixTall(itemCount, pov, parent)
    {
        "<<parent.enasName>>, <<parent.objInPrep>> {στον} οποί{-ος-α-ο} <<withListCaseNominative>><<withListArtIndefinite>>
        <<itemCount == 1 ? tSel('είναι', 'ήταν') : tSel('είναι', 'ήταν')>>:";
    }
	//##We add the Suffix so we can return to the default case of the listcase (Accusative)
	showListContentsSuffixTall(itemCount, pov, parent) 
    {
        "<<withListCaseAccusative>><<withListArtIndefinite>>";
    }
;


/*
 *   Base class for contents listers for a surface 
 */
class BaseSurfaceContentsLister: BaseContentsLister
;

/*
 *   Contents lister for a surface 
 */
surfaceContentsLister: ContentsLister, BaseSurfaceContentsLister
;

/*
 *   Contents lister for explicitly looking in a surface 
 */
surfaceLookInLister: LookWhereContentsLister, BaseSurfaceContentsLister
;

/*
 *   Contents lister for a surface, used in a long description. 
 */
surfaceDescContentsLister: DescContentsLister, BaseSurfaceContentsLister
;

/*
 *   Contents lister for room parts
 */
roomPartContentsLister: surfaceContentsLister
    isListed(obj)
    {
        /* list the object if it's listed in the room part */
        return obj.isListedInRoomPart(part_);
    }

    /* the part I'm listing */
    part_ = nil
;

/*
 *   contents lister for room parts, used in a long description 
 */
roomPartDescContentsLister: surfaceDescContentsLister
    isListed(obj)
    {
        /* list the object if it's listed in the room part */
        return obj.isListedInRoomPart(part_);
    }

    part_ = nil
;

/*
 *   Look-in lister for room parts.  Most room parts act like surfaces
 *   rather than containers, so base this lister on the surface lister.  
 */
roomPartLookInLister: surfaceLookInLister
    isListed(obj)
    {
        /* list the object if it's listed in the room part */
        return obj.isListedInRoomPart(part_);
    }

    part_ = nil
;
                         
/*
 *   Base class for contents listers for an Underside.  
 */
class BaseUndersideContentsLister: BaseContentsLister
;

/* basic contents lister for an Underside */
undersideContentsLister: ContentsLister, BaseUndersideContentsLister
;

/* contents lister for explicitly looking under an Underside */
undersideLookUnderLister: LookWhereContentsLister, BaseUndersideContentsLister
;

/* contents lister for moving an Underside and abandoning its contents */
undersideAbandonContentsLister: undersideLookUnderLister
    showListEmpty(pov, parent) { }
    showListPrefixWide(itemCount, pov, parent)
        { "Η μετακίνηση <<parent.touNameObj>> αποκαλύπτει<<withListCaseAccusative>><<withListArtIndefinite>> "; }
    showListSuffixWide(itemCount, pov, parent)
        { " από κάτω. "; }
    showListPrefixTall(itemCount, pov, parent)
        { "Η μετακίνηση <<parent.touNameObj>> αποκαλύπτει<<withListCaseAccusative>><<withListArtIndefinite>>:"; }
;
 
/* contents lister for an Underside, used in a long description */
undersideDescContentsLister: DescContentsLister, BaseUndersideContentsLister
    showListPrefixWide(itemCount, pov, parent)
    {
        "Κάτω από <<parent.tonNameObj>>
        <<itemCount == 1 ? tSel('είναι', 'ήταν')
                         : tSel('είναι', 'ήταν')>><<withListCaseNominative>><<withListArtIndefinite>> ";
    }
;

/*
 *   Base class for contents listers for an RearContainer or RearSurface 
 */
class BaseRearContentsLister: BaseContentsLister
;

/* basic contents lister for a RearContainer or RearSurface */
rearContentsLister: ContentsLister, BaseRearContentsLister
;

/* contents lister for explicitly looking behind a RearContainer/Surface */
rearLookBehindLister: LookWhereContentsLister, BaseRearContentsLister
;
 
/* lister for moving a RearContainer/Surface and abandoning its contents */
rearAbandonContentsLister: undersideLookUnderLister
    showListEmpty(pov, parent) { }
    showListPrefixWide(itemCount, pov, parent)
        { "Η μετακίνηση <<parent.touNameObj>> αποκαλύπτει<<withListCaseAccusative>><<withListArtIndefinite>> "; }
    showListSuffixWide(itemCount, pov, parent)
        { " πίσω από <<parent.itObj>>. "; }
    showListPrefixTall(itemCount, pov, parent)
        { "Η μετακίνηση <<parent.touNameObj>> αποκαλύπτει:<<withListCaseAccusative>><<withListArtIndefinite>>"; }
;
 
/* long-description contents lister for a RearContainer/Surface */
rearDescContentsLister: DescContentsLister, BaseRearContentsLister
    showListPrefixWide(itemCount, pov, parent)
    {
        "Πίσω από <<parent.tonNameObj>>
        <<itemCount == 1 ? tSel('είναι', 'ήταν')
                         : tSel('είναι', 'ήταν')>><<withListCaseNominative>> ";
    }
;


/*
 *   Base class for specialized in-line contents listers.  This shows the
 *   list in the form "(<prep> which is...)", with the preposition obtained
 *   from the container's objInPrep property.  
 */
class BaseInlineContentsLister: ContentsLister
    showListEmpty(pov, parent) { }
    showListPrefixWide(cnt, pov, parent)
    {
        " (<<parent.objInPrep>> {στον} οποί{-ος-α-ο} <<
          cnt == 1 ? tSel('είναι', 'ήταν') : tSel('είναι', 'ήταν')>> <<withListCaseNominative>><<withListArtIndefinite>> ";
    }
    showListSuffixWide(itemCount, pov, parent)
        { ")"; }
;

/*
 *   Contents lister for a generic in-line list entry.  We customize the
 *   wording slightly here: rather than saying "(in which...)" as the base
 *   class would, we use the slightly more readable "(which contains...)".
 */
inlineListingContentsLister: BaseInlineContentsLister
    showListPrefixWide(cnt, pov, parent)
        { " (που {περιέχει|περιείχε} <<withListCaseAccusative>><<withListArtIndefinite>>"; }
;

/* in-line contents lister for a surface */
surfaceInlineContentsLister: BaseInlineContentsLister
;

/* in-line contents lister for an Underside */
undersideInlineContentsLister: BaseInlineContentsLister
;

/* in-line contents lister for a RearContainer/Surface */
rearInlineContentsLister: BaseInlineContentsLister
;

/*
 *   Contents lister for keyring list entry.  This is used to display a
 *   keyring's contents in-line with the name of the keyring,
 *   parenthetically. 
 */
keyringInlineContentsLister: inlineListingContentsLister
    showListPrefixWide(cnt, pov, parent)
        { " (με συνδεδε{-μένος-μένη-μένο} <<withListCaseAccusative>><<withListArtIndefinite>> "; }
    showListSuffixWide(cnt, pov, parent)
        { " )"; }
;


/*
 *   Contents lister for "examine <keyring>" 
 */
keyringExamineContentsLister: DescContentsLister
    showListEmpty(pov, parent)
    {
	"\^<<parent.oName>> <<parent.verbEimai>> άδει{-ος-α-ο}. ";
    }
    showListPrefixWide(cnt, pov, parent)
    {
        "<<parent.stonNameObj>>
        <<cnt == 1 ? tSel('είναι', 'ήταν')
                   : tSel('είναι', 'ήταν')>> συνδεδε{-μένος-μένη-μένο} <<withListCaseNominative>><<withListArtIndefinite>>";
    }
    showListSuffixWide(itemCount, pov, parent)
    {
        ". ";
    }
;

/*
 *   Lister for actors aboard a traveler.  This is used to list the actors
 *   on board a vehicle when the vehicle arrives or departs a location.  
 */
aboardVehicleLister: Lister
    showListPrefixWide(itemCount, pov, parent)
        { " (φέροντας "; }
    showListSuffixWide(itemCount, pov, parent)
        { ")"; }

    /* list anything whose isListedAboardVehicle returns true */
    isListed(obj) { return obj.isListedAboardVehicle; }
;

/*
 *   A simple lister to show the objects to which a given Attachable
 *   object is attached.  This shows the objects which have symmetrical
 *   attachment relationships to the given parent object, or which are
 *   "major" items to which the parent is attached.  
 */
class SimpleAttachmentLister: Lister
    construct(parent) { parent_ = parent; }
    
    showListEmpty(pov, parent)
        { /* say nothing when there are no attachments */ }
    
    showListPrefixWide(cnt, pov, parent)
        { "<.p>\^<<parent.oName>><<parent.verbEimai>> συνδεδε{-μένος-μένη-μένο} με <<withListCaseAccusative>><<withListArtIndefinite>>"; }
    showListSuffixWide(cnt, pov, parent)
        { ". "; }

    /* ask the parent if we should list each item */
    isListed(obj) { return parent_.isListedAsAttachedTo(obj); }

    /*
     *   the parent object - this is the object whose attachments are being
     *   listed 
     */
    parent_ = nil
;

/*
 *   The "major" attachment lister.  This lists the objects which are
 *   attached to a given parent Attachable, and for which the parent is
 *   the "major" item in the relationship.  The items in the list are
 *   described as being attached to the parent.  
 */
class MajorAttachmentLister: SimpleAttachmentLister
    showListPrefixWide(cnt, pov, parent) { "<.p>\^<<withListCaseNominative>><<withListArtIndefinite>>"; }
    showListSuffixWide(cnt, pov, parent)
    {
        " {είναι|ήταν} <<isHim ? 'συνδεδεμένος' : isHer ?  'συνδεδεμένη' : isHimPlural ? 'συνδεδεμένοι' : isHerPlural ? 'συνδεδεμένες' : isItPlural ? 'συνδεδεμένα' : 'συνδεδεμένο'>>
         με <<withListCaseAccusative>><<parent.tonNameObj>>.<<withListCaseAccusative>><<withListArtIndefinite>> ";
    }

    /* ask the parent if we should list each item */
    isListed(obj) { return parent_.isListedAsMajorFor(obj); }
;

/*
 *   Finish Options lister.  This lister is used to offer the player
 *   options in finishGame(). 
 */
finishOptionsLister: Lister
    showListPrefixWide(cnt, pov, parent)
    {
        "<.p>Θα ήθελες να κάνεις ";
    }
    showListSuffixWide(cnt, pov, parent)
    {
        /* end the question, add a blank line, and show the ">" prompt */
        ";\b&gt;";
    }
    
    isListed(obj) { return obj.isListed; }
    listCardinality(obj) { return 1; }
    
    showListItem(obj, options, pov, infoTab)
    {
        /* obj is a FinishOption object; show its description */
        obj.desc;
    }
    
    showListSeparator(options, curItemNum, totalItems)
    {
        /*
         *   for the last separator, show "or" rather than "and"; for
         *   others, inherit the default handling 
         */
        if (curItemNum + 1 == totalItems)
        {
            if (totalItems == 2)
                " ή ";
            else
                ", ή ";
        }
        else
            inherited(options, curItemNum, totalItems);
    }
;

/*
 *   Equivalent list state lister.  This shows a list of state names for a
 *   set of otherwise indistinguishable items.  We show the state names in
 *   parentheses, separated by commas only (i.e., no "and" separating the
 *   last two items); we use this less verbose format so that we blend
 *   into the larger enclosing list more naturally.
 *   
 *   The items to be listed are EquivalentStateInfo objects.  
 */
equivalentStateLister: Lister
    showListPrefixWide(cnt, pov, parent) { " ("; }
    showListSuffixWide(cnt, pov, parent) { ")"; }
    isListed(obj) { return true; }
    listCardinality(obj) { return 1; }
    showListItem(obj, options, pov, infoTab)
    {
        "<<spellIntBelow(obj.getEquivCount(), 100)>> <<obj.getName()>>";
    }
    showListSeparator(options, curItemNum, totalItems)
    {
        if (curItemNum < totalItems)
            ", ";
    }
;

/* in case the exits module isn't included in the build */
property tonDestName_, destName_, destIsBack_, others_, enableHyperlinks;

/*
 *   Basic room exit lister.  This shows a list of the apparent exits from
 *   a location.
 *   
 *   The items to be listed are DestInfo objects.  
 */
class ExitLister: Lister
    showListPrefixWide(cnt, pov, parent)
    {
        if (cnt == 1)
            "Η μόνη εμφανής έξοδος {οδηγεί|οδηγούσε} ";
        else
            "Οι εμφανείς έξοδοι {οδηγούν|οδηγούσαν} ";
    }
    showListSuffixWide(cnt, pov, parent) { ". "; }

    isListed(obj) { return true; }
    listCardinality(obj) { return 1; }

    showListItem(obj, options, pov, infoTab)
    {
        /*
         *   Show the back-to-direction prefix, if we don't know the
         *   destination name but this is the back-to direction: "back to
         *   the north" and so on. 
         */
        if (obj.destIsBack_ && obj.destName_ == nil)
            say(obj.dir_.backToPrefix + ' ');
        
        /* show the direction */
        showListItemDirName(obj, nil);

        /* if the destination is known, show it as well */
        if (obj.destName_ != nil)
        {
            /*
             *   if we have a list of other directions going to the same
             *   place, show it parenthetically 
             */
            otherExitLister.showListAll(obj.others_, 0, 0);
            
            /*
             *   Show our destination name.  If we know the "back to"
             *   destination name, show destination names in the format
             *   "east, to the living room" so that they are consistent
             *   with "west, back to the dining room".  Otherwise, just
             *   show "east to the living room".  
             */
            if ((options & hasBackNameFlag) != 0)
                ",";

            /* if this is the way back, say so */
            if (obj.destIsBack_)
                " πίσω";

            /* show the destination */
            " προς <<obj.tonDestName_>>";
        }
    }
    showListSeparator(options, curItemNum, totalItems)
    {
        /*
         *   if we have a "back to" name, use the "long" notation - this is
         *   important because we'll use commas in the directions with
         *   known destination names 
         */
        if ((options & hasBackNameFlag) != 0)
            options |= ListLong;

        /*
         *   for a two-item list, if either item has a destination name,
         *   show a comma or semicolon (depending on 'long' vs 'short' list
         *   mode) before the "and"; for anything else, use the default
         *   handling 
         */
        if (curItemNum == 1
            && totalItems == 2
            && (options & hasDestNameFlag) != 0)
        {
            if ((options & ListLong) != 0)
                ", και ";
            else
                " και ";
        }
        else
            inherited(options, curItemNum, totalItems);
    }

    /* show a direction name, hyperlinking it if appropriate */
    showListItemDirName(obj, initCap)
    {
        local dirname;
        
        /* get the name */
        dirname = obj.dir_.name;

        /* capitalize the first letter, if desired */
        if (initCap)
            dirname = dirname.substr(1,1).toUpper() + dirname.substr(2);

        /* show the name with a hyperlink or not, as configured */
        if (libGlobal.exitListerObj.enableHyperlinks)
            say(aHref(dirname, dirname));
        else
            say(dirname);
    }

    /* this lister shows destination names */
    listerShowsDest = true

    /*
     *   My special options flag: at least one object in the list has a
     *   destination name.  The caller should set this flag in our options
     *   if applicable. 
     */
    hasDestNameFlag = ListerCustomFlag(1)
    hasBackNameFlag = ListerCustomFlag(2)
    nextCustomFlag = ListerCustomFlag(3)
;

/*
 *   Show a list of other exits to a given destination.  We'll show the
 *   list parenthetically, if there's a list to show.  The objects to be
 *   listed are Direction objects.  
 */
otherExitLister: Lister
    showListPrefixWide(cnt, pov, parent) { " (ή "; }
    showListSuffixWide(cnt, pov, parent) { ")"; }

    isListed(obj) { return true; }
    listCardinality(obj) { return 1; }

    showListItem(obj, options, pov, infoTab)
    {
        if (libGlobal.exitListerObj.enableHyperlinks)
            say(aHref(obj.name, obj.name));
        else
            say(obj.name);
    }
    showListSeparator(options, curItemNum, totalItems)
    {
        /*
         *   simply show "or" for all items (these lists are usually
         *   short, so omit any commas) 
         */
        if (curItemNum != totalItems)
            " ή ";
    }
;

/*
 *   Show room exits as part of a room description, using the "verbose"
 *   sentence-style notation.  
 */
lookAroundExitLister: ExitLister
    showListPrefixWide(cnt, pov, parent)
    {
        /* add a paragraph break before the exit listing */
        "<.roompara>";

        /* inherit default handling */
        inherited(cnt, pov, parent);
    }    
;

/*
 *   Show room exits as part of a room description, using the "terse"
 *   notation. 
 */
lookAroundTerseExitLister: ExitLister
    showListPrefixWide(cnt, pov, parent)
    {
        "<.roompara><.parser>Εμφανείς έξοδοι: ";
    }
    showListItem(obj, options, pov, infoTab)
    {
        /* show the direction name */
        showListItemDirName(obj, true);
    }
    showListSuffixWide(cnt, pov, parent)
    {
        "<./parser> ";
    }
    showListSeparator(options, curItemNum, totalItems)
    {
        /* just show a comma between items */
        if (curItemNum != totalItems)
            ", ";
    }

    /* this lister does not show destination names */
    listerShowsDest = nil
;

/*
 *   Show room exits in response to an explicit request (such as an EXITS
 *   command).  
 */
explicitExitLister: ExitLister
    showListEmpty(pov, parent)
    {
        "Δεν {υπάρχουν|υπήρχαν} εμφανείς έξοδοι. ";
    }
;

/*
 *   Show room exits in the status line (used in HTML mode only)
 */
statuslineExitLister: ExitLister
    showListEmpty(pov, parent)
    {
        "<<statusHTML(3)>><b>Έξοδοι:</b> <i>Καμία</i><<statusHTML(4)>>";
    }
    showListPrefixWide(cnt, pov, parent)
    {
        "<<statusHTML(3)>><b>Έξοδοι:</b> ";
    }
    showListSuffixWide(cnt, pov, parent)
    {
        "<<statusHTML(4)>>";
    }
    showListItem(obj, options, pov, infoTab)
    {
        "<<aHref(obj.dir_.name, obj.dir_.name, 'Μετάβαση ' + obj.dir_.name,
                 AHREF_Plain)>>";
    }
    showListSeparator(options, curItemNum, totalItems)
    {
        /* just show a space between items */
        if (curItemNum != totalItems)
            " &nbsp; ";
    }

    /* this lister does not show destination names */
    listerShowsDest = nil
;

/*
 *   Implied action announcement grouper.  This takes a list of
 *   ImplicitActionAnnouncement reports and returns a single message string
 *   describing the entire list of actions.  
 */
implicitAnnouncementGrouper: object
    /*
     *   Configuration option: keep all failures in a list of implied
     *   announcements.  If this is true, then we'll write things like
     *   "trying to unlock the door and then open it"; if nil, we'll
     *   instead write simply "trying to unlock the door".
     *   
     *   By default, we keep only the first of a group of failures.  A
     *   group of failures is always recursively related, so the first
     *   announcement refers to the command that actually failed; the rest
     *   of the announcements are for the enclosing actions that triggered
     *   the first action.  All of the enclosing actions failed as well,
     *   but only because the first action failed.
     *   
     *   Announcing all of the actions is too verbose for most tastes,
     *   which is why we set the default here to nil.  The fact that the
     *   first action in the group failed means that we necessarily won't
     *   carry out any of the enclosing actions, so the enclosing
     *   announcements don't tell us much.  All they really tell us is why
     *   we're running the action that actually failed, but that's almost
     *   always obvious, so suppressing them is usually fine.  
     */
    keepAllFailures = nil

    /* build the composite message */
    compositeMessage(lst)
    {
        local txt;
        local ctx = new ListImpCtx();

        /* add the text for each item in the list */
        for (txt = '', local i = 1, local len = lst.length() ; i <= len ; ++i)
        {
            local curTxt;

            /* get this item */
            local cur = lst[i];

            /* we're not in a 'try' or 'ask' sublist yet */
            ctx.isInSublist = nil;

            /* set the underlying context according to this item */
            ctx.setBaseCtx(cur);

            /*
             *   Generate the announcement for this element.  Generate the
             *   announcement from the message property for this item using
             *   our running list context.  
             */
            curTxt = cur.getMessageText(
                cur.getAction().getOriginalAction(), ctx);

            /*
             *   If this one is an attempt only, and it's followed by one
             *   or more other attempts, the attempts must all be
             *   recursively related (in other words, the first attempt was
             *   an implied action required by the second attempt, which
             *   was required by the third, and so on).  They have to be
             *   recursively related, because otherwise we wouldn't have
             *   kept trying things after the first failed attempt.
             *   
             *   To make the series of failed attempts sound more natural,
             *   group them into a single "trying to", and keep only the
             *   first failure: rather than "trying to unlock the door,
             *   then trying to open the door", write "trying to unlock the
             *   door and then open it".
             *   
             *   An optional configuration setting makes us keep only the
             *   first failed operation, so we'd instead write simply
             *   "trying to unlock the door".
             *   
             *   Do the same grouping for attempts interrupted for an
             *   interactive question.  
             */
            while ((cur.justTrying && i < len && lst[i+1].justTrying)
                   || (cur.justAsking && i < len && lst[i+1].justAsking))
            {
                local addTxt;
                
                /*
                 *   move on to the next item - we're processing it here,
                 *   so we don't need to handle it again in the main loop 
                 */
                ++i;
                cur = lst[i];

                /* remember that we're in a try/ask sublist */
                ctx.isInSublist = true;

                /* add the list entry for this action, if desired */
                if (keepAllFailures)
                {
                    /* get the added text */
                    addTxt = cur.getMessageText(
                        cur.getAction().getOriginalAction(), ctx);

                    /*
                     *   if both the text so far and the added text are
                     *   non-empty, string them together with 'and then';
                     *   if one or the other is empty, use the non-nil one 
                     */
                    if (addTxt != '' && curTxt != '')
                        curTxt += ' και έπειτα ' + addTxt;
                    else if (addTxt != '')
                        curTxt = addTxt;
                }
            }

            /* add a separator before this item if it isn't the first */
            if (txt != '' && curTxt != '')
                txt += ', έπειτα ';

            /* add the current item's text */
            txt += curTxt;
        }

        /* if we ended up with no text, the announcement is silent */
        if (txt == '')
            return '';

        /* wrap the whole list in the usual full standard phrasing */
        return standardImpCtx.buildImplicitAnnouncement(txt);
    }
;

/*
 *   Suggested topic lister. 
 */
class SuggestedTopicLister: Lister
    construct(asker, askee, explicit)
    {
        /* remember the actors */
        askingActor = asker;
        targetActor = askee;

        /* remember whether this is explicit or implicit */
        isExplicit = explicit;

        /* cache the actor's scope list */
        scopeList = asker.scopeList();
    }
    
    showListPrefixWide(cnt, pov, parent)
    {
        /* add the asking and target actors as global message parameters */
        gMessageParams(askingActor, targetActor);

        /* show the prefix; include a paren if not in explicit mode */
        "<<isExplicit ? '' : '('>>{Εσύ askingActor/Αυτός} {μπορώ} ";
    }
    showListSuffixWide(cnt, pov, parent)
    {
        /* end the sentence; include a paren if not in explicit mode */
        ".<<isExplicit? '' : ')'>> ";
    }
    showListEmpty(pov, parent)
    {
        /*
         *   say that the list is empty if it was explicitly requested;
         *   say nothing if the list is being added by the library 
         */
        if (isExplicit)
        {
            gMessageParams(askingActor, targetActor);
            "<<isExplicit ? '' : '('>>{Εσύ askingActor/αυτός} δεν {έχω} τίποτα
            συγκεκριμένο στο νου {αυτή τη στιγμή|εκείνη τη στιγμή} ως θέμα συζήτησης με
            {τον targetActor/αυτόν}.<<isExplicit ? '' : ')'>> ";
        }
    }

    showListSeparator(options, curItemNum, totalItems)
    {
        /* use "or" as the conjunction */
        if (curItemNum + 1 == totalItems)
            ", ή ";
        else
            inherited(options, curItemNum, totalItems);
    }

    /* list suggestions that are currently active */
    isListed(obj) { return obj.isSuggestionActive(askingActor, scopeList); }

    /* each item counts as one item grammatically */
    listCardinality(obj) { return 1; }

    /* suggestions have no contents */
    contentsListed(obj) { return nil; }

    /* get the list group */
    listWith(obj) { return obj.suggestionGroup; }

    /* mark as seen - nothing to do for suggestions */
    markAsSeen(obj, pov) { }

    /* show the item - show the suggestion's theName */
    showListItem(obj, options, pov, infoTab)
    {
        /* note that we're showing the suggestion */
        obj.noteSuggestion();

        /* show the name */
        say(obj.fullName);
    }

    /* don't use semicolons, even in long lists */
    longListSepTwo { listSepTwo; }
    longListSepMiddle { listSepMiddle; }
    longListSepEnd { listSepEnd; }

    /* flag: this is an explicit listing (i.e., a TOPICS command) */
    isExplicit = nil

    /* the actor who's asking for the topic list (usually the PC) */
    askingActor = nil

    /* the actor we're talking to */
    targetActor = nil

    /* our cached scope list for the actor */
    scopeList = nil
;

/* ASK/TELL suggestion list group base class */
class SuggestionListGroup: ListGroupPrefixSuffix
    showGroupItem(sublister, obj, options, pov, infoTab)
    {
        /*
         *   show the short name of the item - the group prefix will have
         *   shown the appropriate long name 
         */
        say(obj.name);
    }
;

/* ASK ABOUT suggestion list group */
suggestionAskGroup: SuggestionListGroup
    groupPrefix = "ρώτα {it targetActor/him} για "
;

/* TELL ABOUT suggestion list group */
suggestionTellGroup: SuggestionListGroup
    groupPrefix = "πες {it targetActor/him} για "
;

/* ASK FOR suggestion list group */
suggestionAskForGroup: SuggestionListGroup
    groupPrefix = "ρώτα {it targetActor/him} για "
;

/* GIVE TO suggestions list group */
suggestionGiveGroup: SuggestionListGroup
    groupPrefix = "δώσε {it targetActor/him} "
;

/* SHOW TO suggestions */
suggestionShowGroup: SuggestionListGroup
    groupPrefix = "δείξε {it targetActor/him} "
;

/* YES/NO suggestion group */
suggestionYesNoGroup: SuggestionListGroup
    showGroupList(pov, lister, lst, options, indent, infoTab)
    {
        /*
         *   if we have one each of YES and NO responses, make the entire
         *   list "say yes or no"; otherwise, use the default behavior 
         */
        if (lst.length() == 2
            && lst.indexWhich({x: x.ofKind(SuggestedYesTopic)}) != nil
            && lst.indexWhich({x: x.ofKind(SuggestedNoTopic)}) != nil)
        {
            /* we have a [yes, no] group - use the simple message */
            "πες ναι ή όχι";
        }
        else
        {
            /* inherit the default behavior */
            inherited(pov, lister, lst, options, indent, infoTab);
        }
    }
    groupPrefix = "πες";
;
