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
    whomPronoun = '�����' //���� ��� �� whom

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
    commandLookAround = '����� �������'//���� ��� look around
    commandFullScore = '������ ����'//���� ��� full score
    
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
            action.getImplicitPhrase(ctx) + ', ��� �� ������������ �����');
    }

    /* show a library credit (for a CREDITS listing) */
    showCredit(name, byline) { "<<name>> <<byline>>"; }

    /* show a library version number (for a VERSION listing) */
    showVersion(name, version) { "<<name>> version <<version>>"; }

    /* there's no "about" information in this game */
    noAboutInfo = "<.parser>���� � ������� ��� ���� �����������.<./parser> "

    /*
     *   Show a list state name - this is extra state information that we
     *   show for an object in a listing involving the object.  For
     *   example, a light source might add a state like "(providing
     *   light)".  We simply show the list state name in parentheses.  
     */
    showListState(state) { " (<<state>>)"; }

    /* a set of equivalents are all in a given state */
    allInSameListState(lst, stateName)
        { " (<<lst.length() == 2 ? '��� �� ���' : '���'>> <<stateName>>)"; }// ���� ��� both ����� '��� �� ���' ��� ���� ��� all ����� '���'
 
    /* generic long description of a Thing from a distance */
    distantThingDesc(obj)
    {
        gMessageParams(obj);
        "{���/�����} ��� {�����} ���� ������ ��� �� ����� �������� ������ �����������. ";
    }
	
    /* generic long description of a Thing under obscured conditions */
    obscuredThingDesc(obj, obs)
    {
        gMessageParams(obj, obs);
        "{���/�����} ��� {�����} ������������ ���� ��� �� {��� obs/�����}. ";
    }

    /* generic "listen" description of a Thing at a distance */
    distantThingSoundDesc(obj)
        { "{���/�����} ��� {�����} �� ����������� ��� ����� ��� ��������. "; }

    /* generic obscured "listen" description */
    obscuredThingSoundDesc(obj, obs)
    {
        gMessageParams(obj, obs);
        "{���/�����} ��� {�����} �� ����������� ���� ��� {��� obs/�����}. ";
    }

    /* generic "smell" description of a Thing at a distance */
    distantThingSmellDesc(obj)
        { "{���/�����} ��� {������} ���� ��� ����� ��� ��������. "; }

    /* generic obscured "smell" description */
    obscuredThingSmellDesc(obj, obs)
    {
        gMessageParams(obj, obs);
        "{���/�����} ��� {������} ���� ��� {�� obs/�����}. ";
    }

    /* generic "taste" description of a Thing */
    thingTasteDesc(obj)
    {
        gMessageParams(obj);
        "{� obj/�����} {����|����} ��� ����������� �����. ";
    }

    /* generic "feel" description of a Thing */
    thingFeelDesc(obj)
        { "{���/�����} ��� {������} ���� ����������. "; }

    /* obscured "read" description */
    obscuredReadDesc(obj)
    {
        gMessageParams(obj);
        "{���/�����} ��� {�����} {��� obj/�����} ������ ���� ��� �� {��/���} {�������}. ";
    }

    /* dim light "read" description */
    dimReadDesc(obj)
    {
        gMessageParams(obj);
        "��� ������� ������ ��� ��� �� {�������} {��� obj/�����}. ";
    }

    /* lit/unlit match description */
    litMatchDesc(obj) { "\^<<obj.oName>> <<obj.verbEimai>> ����{-�����-����-����}. "; }
    unlitMatchDesc(obj) { "\^<<obj.oName>> <<obj.verbEimai>> ��� ����� ������. "; }

    /* lit candle description */
    litCandleDesc(obj) { "\^<<obj.oName>> <<obj.verbEimai>>> ����{-�����-����-����}. "; }

    /*
     *   Prepositional phrases for putting objects into different types of
     *   objects. 
     */
    putDestContainer(obj) { return '���� ' + obj.stonNameObj; }
    putDestSurface(obj) { return '���� ' + obj.stonNameObj; }
    putDestUnder(obj) { return '���� ��� ' + obj.tonNameObj; }
    putDestBehind(obj) { return '���� ��� ' + obj.tonNameObj; }
    putDestFloor(obj) { return ' ' + obj.stonNameObj; }
    putDestRoom(obj) { return '���� ' + obj.stonNameObj; }

    /* the list separator character in the middle of a list */
    listSepMiddle = ", "

    /* the list separator character for a two-element list */
    listSepTwo = " ��� "

    /* the list separator for the end of a list of at least three elements */
    listSepEnd = " ��� "

    /*
     *   the list separator for the middle of a long list (a list with
     *   embedded lists not otherwise set off, such as by parentheses) 
     */
    longListSepMiddle = "� " //the ; in greek is used for questions. 

    /* the list separator for a two-element list of sublists */
    longListSepTwo = " ��� "

    /* the list separator for the end of a long list */
    longListSepEnd = " ��� "

    /* show the basic score message */
    showScoreMessage(points, maxPoints, turns)
    {
        "�� <<turns>> <<turns == 1 ? '������' : '��������'>>, 
		����� ������� <<points>> ��� �� ������� ��� ����� <<maxPoints>> 
		<<maxPoints == 1 ? '������' : '������'>>. ";
    }

    /* show the basic score message with no maximum */
    showScoreNoMaxMessage(points, turns)
    {
        "�� <<turns>> <<turns == 1 ? '������' : '��������'>>, ����� ������� 
		<<points>> <<points == 1 ? '�����' : '�������'>>. ";
    }

    /* show the full message for a given score rank string */
    showScoreRankMessage(msg) { "���� �� ����� <<msg>>. "; }

    /*
     *   show the list prefix for the full score listing; this is shown on
     *   a line by itself before the list of full score items, shown
     *   indented and one item per line 
     */
    showFullScorePrefix = "�� ���� ��� ����������� ���:"

    /*
     *   show the item prefix, with the number of points, for a full score
     *   item - immediately after this is displayed, we'll display the
     *   description message for the achievement 
     */
    fullScoreItemPoints(points)
    {
        "<<points>> <<points == 1 ? '������' : '������'>> ��� ";
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
        "�� <<aHref(commandFullScore, '����', '����� �� ������ ����')>>
        ��� <<delta > 0 ? '��������' : '��������'>> ����
        <<spellInt(delta > 0 ? delta : -delta)>>
        <<delta is in (1, -1) ? '�����' : '�������'>>.";
    }

    /* acknowledge turning tips on or off */
    acknowledgeTipStatus(stat)
    {
        "<.parser>�� ���������� <<stat ? '���������������' : '�����������������'>>.<./parser> ";
    }

    /* describe the tip mode setting */
    tipStatusShort(stat)
    {
        "���������� <<stat ? '���������������' : '�����������������'>>";
    }

    /* get the string to display for a footnote reference */
    footnoteRef(num)
    {
        /* set up a hyperlink for the note that enters the "note n" command */
        return '<sup>[<<aHref('����������� ' + num, toString(num))>>]</sup>';
    }

    /* first footnote notification */
    firstFootnote()
    {
        footnotesTip.showTip();
    }

    /* there is no such footnote as the given number */
    noSuchFootnote(num)
    {
        "<.parser>� ������� ��� ���� ��������� ���� �� ������ �����������.<./parser> ";
    }

    /* show the current footnote status */
    showFootnoteStatus(stat)
    {
        "� �������� ������� ����� ������������� ";
        switch(stat)
        {
        case FootnotesOff:
            "��������, ��� ������ ���� ��� �������� �� �������������.
            ������������� <<aHref('������������� ��� ������', '������������� ��� ������', '���� ��� ������������� ��� ������')>> 
			���� �� ������� ��� �������� �� ������������� ����� ��� ����� ��� ����� ��� ���, 
			or <<aHref('������������� ��� ������', '������������� ��� ������', '���� ��� ������������� ��� ������')>>
			��� �� ������������ ���� �� ��������, ����� ��� ��� ������������� ��� ����� ��� ���������. ";
            break;

        case FootnotesMedium:
            "������, �� ����� ������� �������� �� ������������� ��� ��� ����� ��������� ���, ����
            ������ �������� �� ����� ��� ����� ��� ���������.  
			������������� <<aHref('������������� ��� ��������', '������������� ��� ��������', '�������������� ��� �������������')>>  
			��� �� ������� ������ ��� �������� �� �������������,
			or <<aHref('������������� ��� ������', '������������� ��� ������', '���� ��� ������������� ��� ������')>> 
			��� �� ������������ ���� �� ��������, ����� ��� ��� ������������� ��� ����� ��� ���������. ";
            break;

        case FootnotesFull:
            "������, �� ����� ������� ���� ��� �������� �� �������������, ����� ��� ������������� ��� ����� ��� ���������.  
			������������� <<aHref('������������� ��� ������', '������������� ��� ������', '���� ��� ������������� ��� ������')>> 
			���� �� ������� ��� �������� �� ������������� ����� ��� ����� ��� ����� ��� ���������, 
			or <<aHref('������������� ��� ��������', '������������� ��� ��������', '�������������� ��� �������������')>> 
			��� �� ������� ������ ��� �������� �� �������������. ";
            break;
        }
    }

    /* acknowledge a change in the footnote status */
    acknowledgeFootnoteStatus(stat)
    {
        "<.parser>� �������� ������� �����
        <<shortFootnoteStatus(stat)>>.<./parser> ";
    }

    /* show the footnote status, in short form */
    shortFootnoteStatus(stat)
    {
        "������������� <<
          stat == FootnotesOff ? '��������'
          : stat == FootnotesMedium ? '������'
          : '������' >>";
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
    emptyCommandResponse = "<.parser>�������, �� �����?<./parser> "

    /* invalid token (i.e., punctuation) in command line */
    invalidCommandToken(ch)
    {
        "<.parser>� ������� ��� ����� ��� �� �������������� ��� ���������
        &lsquo;<<ch>>&rsquo; �� ��� ������.<./parser> ";
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
        ('��� {���������|������} ������ ������� ' + '.<.p>')

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
        "\^<<issuingActor.oName>> ��� ������ �� ������� <<targetActor.stonName>>. ";
    }

    /* greeting actor while actor is already talking to us */
    alreadyTalkingTo(actor, greeter)
    {
        "\^<<greeter.oName>> ��� <<greeter.verbExo>>
        ��� ������� <<actor.touName>>. ";
    }

    /* no topics to suggest when we're not talking to anyone */
    noTopicsNotTalking = "<.parser>{���/�����} ��� {�����} �� ������� ����� ��� ������.<./parser> "

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
    oopsOutOfContext = "<.parser>������� �� ��������������� ��� ������ ���� ���� 
	��� �� ���������� ������ ����������� ����� ������ ���� ��� ������ 
	���� ����� � ������� ��� ����������� ��� ����.<./parser> "

    /* OOPS in context, but without the word to correct */
    oopsMissingWord = "<.parser>��� �� ��������������� ��� ������ ���� ��� �� ���������� ��� ����������� �����,
        ���� ��� ����� ���� ���� �� ����, ���� ��� ����������: ���� ������.<./parser> "

    /* acknowledge setting VERBOSE mode (true) or TERSE mode (nil) */
    acknowledgeVerboseMode(verbose)
    {
        if (verbose)
            "<.parser>� ��������� ���������� ����� ����������.<./parser> ";
        else
            "<.parser>� ��������� ���������� ����� ����������.<./parser> ";
    }

    /* show the current VERBOSE setting, in short form */
    shortVerboseStatus(stat) { "<<stat ? '���������' : '���������'>> mode"; }

    /* show the current score notify status */
    showNotifyStatus(stat)
    {
        "<.parser>�� ������������ ��� �� ���� ����� <<stat ? '���������������' : '�����������������'>>.<./parser> ";
    }

    /* show the current score notify status, in short form */
    shortNotifyStatus(stat) { "���������� <<stat ? '��������������' : '����������������'>>"; }

    /* acknowledge a change in the score notification status */
    acknowledgeNotifyStatus(stat)
    {
        "<.parser>�� ������������ ��� �� ���� ����� �����
        <<stat ? '���������������' : '�����������������'>>.<./parser> ";
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
        "<.parser>��� ������� ���� ��� ������ �� �����������.<./parser> ";
    }

    /* 'again' cannot be directed to a different actor */
    againCannotChangeActor()
    {
        "<.parser>��� �� ����������� ��� ������ ���� �.�. <q>turtle, go north,</q>
        ���� ����� <q>again,</q> ��� ��� <q>turtle, again.</q><./parser> ";
    }

    /* 'again': can no longer talk to target actor */
    againCannotTalkToTarget(issuer, target)
    {
        "\^<<issuer.theName>> <<issuer.verbCannot>> �� ����������� ����� ��� ������. ";
    }

    /* the last command cannot be repeated in the present context */
    againNotPossible(issuer)
    {
        "���� � ������ ��� ������ �� ����������� ����. ";
    }

    /* system actions cannot be directed to non-player characters */
    systemActionToNPC()
    {
        "<.parser>���� � ������ ��� ������ �� ����������� �� ����� ��������� ��� ��������.<./parser> ";
    }

    /* confirm that we really want to quit */
    confirmQuit()
    {
        "��� ����� �� �����������;\ (<<aHref('�', '�', '����������� ����������')
        >> ��� �� �����������) >\ ";
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
        "<.parser>� ������� �����������.<./parser> ";
    }

    /* confirm that they really want to restart */
    confirmRestart()
    {
        "��� ����� �� �������������� �� ��������;\ (<<aHref('�', '�',
        '����������� �������������')>> ��� �� �����������) >\ ";
    }

    /* "not restarting" confirmation */
    notRestarting() { "<.parser>� ������� �����������.<./parser> "; }

    /*
     *   Show a game-finishing message - we use the conventional "*** You
     *   have won! ***" format that text games have been using since the
     *   dawn of time. 
     */
    showFinishMsg(msg) { "<.p>*** <<msg>>\ ***<.p>"; }

    /* standard game-ending messages for the common outcomes */
    finishDeathMsg = '{���/����� pc} <<withTenseAoristos>>{�������}'
    finishVictoryMsg = ('{���/����� pc} ' + tSel('<<withTenseParak>>{�������}','<<withTenseAoristos>>{�������}'))
    finishFailureMsg = ('{���/����� pc} ' + tSel('<<withTenseParak>>{����������}','<<withTenseAoristos>>{����������}'))
    finishGameOverMsg = '����� ����������'

    /*
     *   Get the save-game file prompt.  Note that this must return a
     *   single-quoted string value, not display a value itself, because
     *   this prompt is passed to inputFile(). 
     */
    getSavePrompt = '���������� ��� ���������� ���� ������'

    /* get the restore-game prompt */
    getRestorePrompt = '��������� ���������� ��� ��� ������'

    /* successfully saved */
    saveOkay() { "<.parser>������������.<./parser> "; }

    /* save canceled */
    saveCanceled() { "<.parser>���������.<./parser> "; }

    /* saved failed due to a file write or similar error */
    saveFailed(exc)
    {
        "<.parser>��������. � ����� ���� ����� ��� ���������� ��� ������ �� ����������� 
		, � ��������� �� ��� ����� �� ���������� ���������� ��� �� ������� ���� �� ������.<./parser> ";
    }

    /* save failed due to storage server request error */
    saveFailedOnServer(exc)
    {
        "<.parser>�������, ���� ��������� ��������� ���� ���������� �����������:
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
    noteMainRestore() { "<.parser>��������� ������������� ����������...<./parser>\n"; }

    /* successfully restored */
    restoreOkay() { "<.parser>��������������.<./parser> "; }

    /* restore canceled */
    restoreCanceled() { "<.parser>���������.<./parser> "; }

    /* restore failed due to storage server request error */
    restoreFailedOnServer(exc)
    {
        "<.parser>�������, ���� ��������� ��������� ���� ���������� �����������:
        <<makeSentence(exc.errMsg)>><./parser>";
    }

    /* restore failed because the file was not a valid saved game file */
    restoreInvalidFile()
    {
        "<.parser>��������: ���� ��� ����� ������ ������������ ������ �����.<./parser> ";
    }

    /* restore failed because the file was corrupted */
    restoreCorruptedFile()
    {
        "<.parser>��������: �� ������ ���������� ��� ������������ �������� �� �����
        �������������. ���� ������ �� ������ ��� �� ������ ������������� ��� ������ ����
        ���������, � �� ������ ����������� ������ ����������� �� �� �������
        ���������� ���������, � �� ������ ���� ����������� ��� �������
        ����� ������� �����.<./parser> ";
    }

    /* restore failed because the file was for the wrong game or version */
    restoreInvalidMatch()
    {
        "<.parser>��������: �� ������ ��� ������������ ��� ����� ��
        ������� (� ������������ ��� ��� �� ������� ������ ���
        ��������).<./parser> ";
    }

    /* restore failed for some reason other than those distinguished above */
    restoreFailed(exc)
    {
        "<.parser>��������: ��� ���� ������ � ��������
        ��� �����.<./parser> ";
    }

    /* error showing the input file dialog (or character-mode equivalent) */
    filePromptFailed()
    {
        "<.parser>������ ������ ���������� ���� ��� ������ �������� �������.
        � ����������� ��� ��������� �� ���� ������������ ��������� ����� �
        �� ������� �������� �����������.<./parser> ";
    }

    /* error showing the input file dialog, with a system error message */
    filePromptFailedMsg(msg)
    {
        "<.parser>��������: <<makeSentence(msg)>><./parser> ";
    }

    /* Web UI inputFile error: uploaded file is too large */
    webUploadTooBig = '�� ���������� ������ ����� ���� ������ ��� �����������.'

    /* PAUSE prompt */
    pausePrompt()
    {
        "<.parser>� ������� ����� �� �����. �������� ����� �� �������
		����������� ���� ����� ������� �� ���������� ��� �������, � ����� �� ������� &lsquo;S&rsquo;
		��� �� ������������ ��� �������� ����.<./parser><.p>";
    }

    /* saving from within a pause */
    pauseSaving()
    {
        "<.parser>���������� ��� ��������...<./parser><.p>";
    }

    /* PAUSE ended */
    pauseEnded()
    {
        "<.parser>� ������� �����������.<./parser> ";
    }

    /* acknowledge starting an input script */
    inputScriptOkay(fname)
    {
        "<.parser>�������� ������� ��� <q><<
          File.getRootName(fname).htmlify()>></q>...<./parser>\n ";
    }

    /* error opening input script */
    inputScriptFailed = "<.parser>��������: �� ������ ������� �������� ��� ���� ������ �� �������.<./parser> "
        
    /* exception opening input script */
    inputScriptFailedException(exc)
    {
        "<.parser>��������: <<exc.displayException>><./parser> ";
    }

    /* get the scripting inputFile prompt message */
    getScriptingPrompt = '�������� ������� ��� ����� ��� �� ��� ������ ��������'

    /* acknowledge scripting on */
    scriptingOkay()
    {
        "<.parser>�� ���������� �� ����������� ��� ������.
        ������������� <<aHref('������� ��������', '������� ��������', '�������������� ��������')>> ��� ������� 
		��� ��������.<./parser> ";
    }

    scriptingOkayWebTemp()
    {
        "<.parser>�� ���������� �� �����������.
        ������������� <<aHref('�������� �������', '�������� �������', '�������������� ��������')>> ��� ������� 
		��� �������� ��� ��� ��������� ��� ������������� ����������.<./parser> ";
    }

    /* scripting failed */
    scriptingFailed = "<.parser>��������: ������ ��� ������ ���� �� ������� ��� ������� ��������.<./parser> "

    /* scripting failed with an exception */
    scriptingFailedException(exc)
    {
        "<.parser>��������: <<exc.displayException>><./parser>";
    }

    /* acknowledge cancellation of script file dialog */
    scriptingCanceled = "<.parser>�����.<./parser> "

    /* acknowledge scripting off */
    scriptOffOkay = "<.parser>�� ������� ������������.<./parser> "

    /* SCRIPT OFF ignored because we're not in a script file */
    scriptOffIgnored = "<.parser>��� ������������ ������ ������� ���� �� ������.<./parser> "

    /* get the RECORD prompt */
    getRecordingPrompt = '�������� ������� ��� ����� ��� �� ��� ������ ���������� �������'

    /* acknowledge recording on */
    recordingOkay = "<.parser>�� ������� ���� �� �������������.  �������������
                     <<aHref('������� ��������', '������� ��������',
                             '�������������� ��� ��������')>>
                     ��� ���������� ��� ��������.<.parser> "

    /* recording failed */
    recordingFailed = "<.parser>��������: ������ ��� ������ ���� �� ������� 
	��� ������� ���������� �������.<./parser> "

    /* recording failed with exception */
    recordingFailedException(exc)
    {
        "<.parser>�������: <<exc.displayException()>><./parser> ";
    }

    /* acknowledge cancellation */
    recordingCanceled = "<.parser>���������.<./parser> "

    /* recording turned off */
    recordOffOkay = "<.parser>� ��������� ������� ������������.<./parser> "

    /* RECORD OFF ignored because we're not recording commands */
    recordOffIgnored = "<.parser>��� ������� ����� ��������� ������� ���� �� ������.<./parser> "

    /* REPLAY prompt */
    getReplayPrompt = '�������� ������� �� ������ ���������� ������� ��� �� �����������.'

    /* REPLAY file selection canceled */
    replayCanceled = "<.parser>���������.<./parser> "

    /* undo command succeeded */
    undoOkay(actor, cmd)
    {
        "<.parser>����������� ��� ���� ����: <q>";

        /* show the target actor prefix, if an actor was specified */
        if (actor != nil)
            "<<actor>>, ";

        /* show the command */
        "<<cmd>></q>.<./parser><.p>";
    }

    /* undo command failed */
    undoFailed()
    {
        "<.parser>��� �������� ������������ ����������� ���������� ��� ������������ �����������.<./parser> ";
    }

    /* comment accepted, with or without transcript recording in effect */
    noteWithScript = "<.parser>�� ������ �����������.<./parser> "
    noteWithoutScript = "<.parser>�� ������ <b>���</b> �����������.<./parser> "

    /* on the first comment without transcript recording, warn about it */
    noteWithoutScriptWarning = "<.parser>�� ������ <b>���</b> �����������.
        ������������� <<aHref('�������', '�������', '������ ��� ���������� ��� ����������')
          >> �� ������ �� ���������� ��� ��������� ��� ��������.<./parser> "

    /* invalid finishGame response */
    invalidFinishOption(resp)
    {
        "\b���� ��� ����� ��� ��� ��� ��������. ";
    }

    /* acknowledge new "exits on/off" status */
    exitsOnOffOkay(stat, look)
    {
        if (stat && look)
            "<.parser>� ����� ��� ������ �� ����������� ���� ���� ��� ������ ���������� 
		��� ��� �� ���� ��������� ��������.<./parser> ";
        else if (!stat && !look)
            "<.parser>� ����� ��� ������ ��� �� ����������� ����� ���� ��� ������ ���������� 
		���� ���� ��������� ��� ��������.<./parser> ";
        else
            "<.parser>� ����� ��� ������ <<stat ? '��' : '��� ��'>> 
		����������� ���� ��� ������ ����������, ��� <<look ? '��' : '��� ��'>> 
		���������� ���� ��������� ��� ��������.<./parser> ";
    }

    /* explain how to turn exit display on and off */
    explainExitsOnOff()
    {
        exitsTip.showTip();
    }

    /* describe the current EXITS settings */
    currentExitsSettings(statusLine, roomDesc)
    {
        "������ ";
        if (statusLine && roomDesc)
            "������";
        else if (statusLine)
            "������ ����������";
        else if (roomDesc)
            "�����";
        else
            "��������";
    }

    /* acknowledge HINTS OFF */
    hintsDisabled = '<.parser>� ������� ����� ����� ��������.<./parser> '

    /* rebuff a request for hints when they've been previously disabled */
    sorryHintsDisabled = '<.parser>�������, ���� � ������� ���� ��������������� ��� ����� �� ��������, ���� �������. 
	�� ����� ������� �����, �� ������ �� ������������ ��� �������� ����, 
	�� ����� ��� ��� ��������� TADS ��� �� ���������� ��� ��� �������� ���������. <./parser> '

    /* this game has no hints */
    hintsNotPresent = '<.parser>�������, ���� � ������� ��� ���� ����� ������������ �������.<./parser> '

    /* there are currently no hints available (but there might be later) */
    currentlyNoHints = '<.parser>�������, ��� ������� ��������� ������� ���� �� ������. �������� ������ ���� ��������.<./parser> '

    /* show the hint system warning */
    showHintWarning =
       "<.notification>�������������: ������� �������� ��� ��������� ��� ������������ �������,
       ����� ��� ������� �� ����������� ���� �������� ��� �� �������� ��� ������� �� ��� ��������
       ���� �� �������� ����� ���� ������ ����������. �� ��������� ���
       � �������������� ��� ��� ����� ������, ������� �� ���������������� ��� �������
	   ��� �� �������� ����� ��� ��������� ��������������� <<aHref('������� �������� ', '������� ��������')
       >>.  �� ����� ������ �� ���� ��� �������, �������������
       <<aHref('�������', '�������')>>.<./notification> "

    /* done with hints */
    hintsDone = '<.parser>������������.<./parser> '

    /* optional command is not supported in this game */
    commandNotPresent = "<.parser>���� � ������ ��� ����� ������� �� ����� ��� �������.<./parser> "

    /* this game doesn't use scoring */
    scoreNotPresent = "<.parser>���� � ������� ��� ���������� ����.<./parser> "

    /* mention the FULL SCORE command */
    mentionFullScore()
    {
        fullScoreTip.showTip();
    }

    /* SAVE DEFAULTS successful */
    savedDefaults()
    {
        "<.parser>�� ��������� ��������� ����� ����������� 
		�� �� �������������� ��������� ��� ��� ���������. 
		�� ������������� ��������� �����: ";

        /* show all of the settings */
        settingsUI.showAll();

        ".  �� ����������� ������� ��������� �� ���������� ����� ��� ��������� �������� ���� ���� ��� ������� (� ������������) �� ��������, 
		���� ��� ����� ��� �� ���������� ��������� ��� �� ������ �� ����.<./parser> ";
    }

    /* RESTORE DEFAULTS successful */
    restoredDefaults()
    {
        "<.parser>�� ������������� �������������� ��������� ����� ����� �� ����. 
		�� ���� ��������� �����: ";

        /* show all of the settings */
        settingsUI.showAll();

        ".<./parser> ";
    }

    /* show a separator for the settingsUI.showAll() list */
    settingsItemSeparator = "; "

    /* SAVE/RESTORE DEFAULTS not supported (old interpreter version) */
    defaultsFileNotSupported = "<.parser>�������, ���� � ������ ��� ��������� TADS ��� �������������� ��� ����������� ��� ���������� � �������� ��� �������������� ���������. 
	������ �� ������������� ��� ��� �������� ������ ��� �� ��������������� ����� �� ����������.<./parser> "

    /* RESTORE DEFAULTS file open/read error */
    defaultsFileReadError(exc)
    {
        "<.parser>������������� ������ ���� ��� �������� ��� ������� �������������� ���������. 
		�� ������� �������������� ��������� ��� ������� �� ����������.<./parser> ";
    }

    /* SAVE DEFAULTS file creation error */
    defaultsFileWriteError = "<.parser>������������� ������ ���� ��� ������� ��� ������� �������������� ���������.  
	�� �������������� ��������� ��� ����� �����������. ������ �� ������� ������� ����� ���� ����� ���, 
	� ��������� �� ��� ����� �� ���������� ���������� ��� �� ��������� �� ������.<./parser> "

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
    prevMenuLink = '<font size=-1>�����������</font>'

    /* link title for 'next topic' navigation link in topic lists */
    nextMenuTopicLink = '<font size=-1>�������</font>'

    /*
     *   main prompt text for text-mode menus - this is displayed each
     *   time we ask for a keystroke to navigate a menu in text-only mode 
     */
    textMenuMainPrompt(keylist)
    {
        "\b�������� ���� ������ �������, � ������ &lsquo;<<
        keylist[M_PREV][1]>>&rsquo; ��� �� ����������� ����� � 
		&lsquo;<<keylist[M_QUIT][1]>>&rsquo; ��� ����������:\ ";
    }

    /* prompt text for topic lists in text-mode menus */
    textMenuTopicPrompt()
    {
        "\b������ �� ������� ����� ����������� ��� ��� �������� ��� �������� �������,
        &lsquo;<b>P</b>&rsquo; ��� �� ���� ��� ����������� �����, �
        &lsquo;<b>Q</b>&rsquo; ��� ����������.\b";
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
    menuTopicListEnd = '[�����]'

    /*
     *   Message to display at the end of a "long topic" in the menu
     *   system.  We'll display this at the end of the long topic's
     *   contents.  
     */
    menuLongTopicEnd = '[�����]'

    /*
     *   instructions text for banner-mode menus - this is displayed in
     *   the instructions bar at the top of the screen, above the menu
     *   banner area 
     */
    menuInstructions(keylist, prevLink)
    {
        "<tab align=right ><b>\^<<keylist[M_QUIT][1]>></b>=Quit <b>\^<<
        keylist[M_PREV][1]>></b>=����������� �����<br>
        <<prevLink != nil ? aHrefAlt('�����������', prevLink, '') : ''>>
        <tab align=right ><b>\^<<keylist[M_UP][1]>></b>=���� <b>\^<<
        keylist[M_DOWN][1]>></b>=���� <b>\^<<
        keylist[M_SEL][1]>></b>=�������<br>";
    }

    /* show a 'next chapter' link */
    menuNextChapter(keylist, title, hrefNext, hrefUp)
    {
        "�������: <<aHref(hrefNext, title)>>;
        <b>\^<<keylist[M_PREV][1]>></b>=<<aHref(hrefUp, '�����')>>";
    }

    /*
     *   cannot reach (i.e., touch) an object that is to be manipulated in
     *   a command - this is a generic message used when we cannot
     *   identify the specific reason that the object is in scope but
     *   cannot be touched 
     */
    cannotReachObject(obj)
    {
        "{���/�����} ��� {�����} <<obj.tonNameObj>>. ";
    }

    /*
     *   cannot reach an object, because the object is inside the given
     *   container 
     */
    cannotReachContents(obj, loc)
    {
        gMessageParams(obj, loc);
        return '{���/�����} ��� {�����} {�� obj/�����} ���� ��� '
               + '{the loc/�����}. ';
    }

    /* cannot reach an object because it's outisde the given container */
    cannotReachOutside(obj, loc)
    {
        gMessageParams(obj, loc);
        return '{���/�����} ��� {�����} {�� obj/�����} ���� ��� '
               + '{the loc/�����}. ';
    }

    /* sound is coming from inside/outside a container */
    soundIsFromWithin(obj, loc)
    {
        "\^<<obj.oName>> {�������} ���� ��� <<loc.tonNameObj>>. ";
		
		//appear<<obj.verbEndingSEd>> to be
        //coming from inside <<loc.theNameObj>>. ";
    }
    soundIsFromWithout(obj, loc)
    {
        "\^<<obj.oName>> {�������} ��� ��� <<loc.tonNameObj>>. ";
    }

    /* odor is coming from inside/outside a container */
    smellIsFromWithin(obj, loc)
    {
        "\^<<obj.oName>> {�������} ���� ��� <<loc.tonNameObj>>. ";
    }
    smellIsFromWithout(obj, loc)
    {
        "\^<<obj.oName>> {�������} ��� ��� <<loc.tonNameObj>>. ";
    }

    /* default description of the player character */
    pcDesc(actor)
    {
        "\^<<actor.oName>> {��������} ���{-��-�-�} ���� �������. ";
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
    roomDarkName = '���� ��� �������'

    /* generic long description of a dark room */
    roomDarkDesc = "{�����|����} ��������. "

    /*
     *   mention that an actor is here, without mentioning the enclosing
     *   room, as part of a room description 
     */
    roomActorHereDesc(actor)
    {
        "\^<<actor.nameIs>> <<actor.posture.participle>>
        <<tSel('���', '����')>>. ";
    }

    /*
     *   mention that an actor is visible at a distance or remotely,
     *   without mentioning the enclosing room, as part of a room
     *   description 
     */
    roomActorThereDesc(actor)
    {
        "\^<<actor.nameIs>> <<actor.posture.participle>> ����� �����. ";
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
        " <<lst.length() == 1 ? tSel('�����', '����') : tSel('�����', '����')>>
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
        " <<lst.length() == 1 ? tSel('�����', '����') : tSel('�����', '����')>>
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
        " <<lst.length() == 1 ? tSel('�����', '����') : tSel('�����', '����')>>
        <<posture.participle>> <<tSel('���', '����')>>. ";
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
        " <<lst.length() == 1 ? tSel('�����', '����') : tSel('�����', '����')>>
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
        "\^<<traveler.travelerName(nil)>> <<traveler.verbFevgo>> ���
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
        "\^<<traveler.travelerName(true)>> <<traveler.verbFevgo>> ���
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
        <<traveler.stonTravelerRemoteLocName>> ��� �� <<dirName>>. ";
    }

    /* a traveler is leaving in a given compass direction */
    sayDepartingDir(traveler, dirName)
    {
        local nm = traveler.travelerRemoteLocName;
        
        "\^<<traveler.travelerName(nil)>> <<traveler.verbFevgo>>
        ���� <<dirName>><<nm != '' ? ' ��� ' + nm : ''>>. ";
    }
    
    /* a traveler is arriving from a shipboard direction */
    sayArrivingShipDir(traveler, dirName)
    {
        "\^<<traveler.travelerName(true)>> enter<<traveler.verbEndingSEd>>
        <<traveler.travelerRemoteLocName>> ��� <<dirName>>. ";
    }

    /* a traveler is leaving in a given shipboard direction */
    sayDepartingShipDir(traveler, dirName)
    {
        local nm = traveler.tonTravelerRemoteLocName;
        
        "\^<<traveler.travelerName(nil)>> <<traveler.verbFevgo>>
        ���� �� <<dirName>><<nm != '' ? ' ��� ' + nm : ''>>. ";
    }

    /* a traveler is going aft */
    sayDepartingAft(traveler)
    {
        local nm = traveler.tonTravelerRemoteLocName;
        
        "\^<<traveler.travelerName(nil)>> <<traveler.verbPigaino>>
        ����<<nm != '' ? ' ��� ' + nm : ''>>. ";
    }

    /* a traveler is going fore */
    sayDepartingFore(traveler)
    {
        local nm = traveler.tonTravelerRemoteLocName;

        "\^<<traveler.travelerName(nil)>> <<traveler.verbPigaino>>
         �������<<nm != '' ? ' ��� ' + nm : ''>>. ";
    }

    /* a shipboard direction was attempted while not onboard a ship */
    notOnboardShip = "���� � ���������� ��� {����|����} ����� ������� �� {����|������} �� ������. "

    /* a traveler is leaving via a passage */
    sayDepartingThroughPassage(traveler, passage)
    {
        "\^<<traveler.travelerName(nil)>> <<traveler.verbFevgo>> ���
        <<traveler.tonTravelerRemoteLocName>> ���� ��� <<passage.tonNameObj>>. ";
    }

    /* a traveler is arriving via a passage */
    sayArrivingThroughPassage(traveler, passage)
    {
        "\^<<traveler.travelerName(true)>> <<traveler.verbMpeno>>
        <<traveler.stonTravelerRemoteLocName>> ���� ��� <<passage.tonNameObj>>. ";
    }

    /* a traveler is leaving via a path */
    sayDepartingViaPath(traveler, passage)
    {
        "\^<<traveler.travelerName(nil)>> <<traveler.verbFevgo>> ���
        <<traveler.tonTravelerRemoteLocName>> ���� <<passage.touNameObj>>. ";
    }

    /* a traveler is arriving via a path */
    sayArrivingViaPath(traveler, passage)
    {
        "\^<<traveler.travelerName(true)>> <<traveler.verbMpeno>>
        <<traveler.stonTravelerRemoteLocName>> ���� <<passage.touNameObj>>. ";
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
        <<stairs.tonNameObj>> ���� <<nm != '' ?  nm : ''>>. ";
    }

    /* a traveler is arriving by coming down a stairway */
    sayArrivingDownStairs(traveler, stairs)
    {
        local nm = traveler.tonTravelerRemoteLocName;

        "\^<<traveler.travelerName(true)>> <<traveler.verbKatebaino>>
        <<stairs.tonNameObj>> ���� <<nm != '' ? nm : ''>>. ";
    }

    /* acompanying another actor on travel */
    sayDepartingWith(traveler, lead)
    {
        "\^<<traveler.travelerName(nil)>> {������� traveler}
        �� <<lead.tonNameObj>>. ";
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
        "\^<<lead.oName>> {����� lead}
        <<guide.tonNameObj>> �� {������ guide} ��� ����� �����. ";
    }

    /* note that a door is being opened/closed remotely */
    sayOpenDoorRemotely(door, stat)
    {
        "������� <<stat ? '' + tSel('�������', '������')
                        : '' + tSel('�������', '�������')>>
        <<door.tonNameObj>> ��� ��� ���� ������. ";
    }

    /*
     *   open/closed status - these are simply adjectives that can be used
     *   to describe the status of an openable object 
     */
    openMsg(obj) { return obj.replaceEndings('������[-��-�-�]'); }
    closedMsg(obj) { return obj.replaceEndings('������[-��-�-�]'); }

    /* object is currently open/closed */
    currentlyOpen = '{����� dobj} ����� ������{-��-�-�} ����� ��� ������. '
    currentlyClosed = '{����� dobj} ����� ������{-��-�-�} ����� ��� ������. '

    /* stand-alone independent clause describing current open status */
    openStatusMsg(obj) { return obj.itIsContraction + ' ' + obj.openDesc; }
    /* locked/unlocked status - adjectives describing lock states */
    lockedMsg(obj) { return obj.replaceEndings('���������[-��-�-�]'); }
    unlockedMsg(obj) { return obj.replaceEndings('���������[-��-�-�]'); }

    /* object is currently locked/unlocked */
    currentlyLocked = '{� dobj/�����} {�����} ����� �� ������ ���������{-��-�-�}. '
    currentlyUnlocked = '{� dobj/�����} {�����} ����� �� ������ ���������{-��-�-�}. '

    /*
     *   on/off status - these are simply adjectives that can be used to
     *   describe the status of a switchable object 
     */
    onMsg(obj) { return obj.replaceEndings('�����[-��-�-�]'); }
    offMsg(obj) { return obj.replaceEndings('�������[-��-�-�]'); }

    /* daemon report for burning out a match */
    matchBurnedOut(obj)
    {
        gMessageParams(obj);
        "{� obj/�����} ��������� �� ��������, ��� ������������ �� ��� ������� �������. ";
    }

    /* daemon report for burning out a candle */
    candleBurnedOut(obj)
    {
        gMessageParams(obj);
        "{� obj/�����} ���� ���� ������ ������������ ��� �� ������ �� ������������������, ��� ������ ������. ";
    }

    /* daemon report for burning out a generic fueled light source */
    objBurnedOut(obj)
    {
        gMessageParams(obj);
        "{� obj/�����} {�����}. ";
    }

    /* 
     *   Standard dialog titles, for the Web UI.  These are shown in the
     *   title bar area of the Web UI dialog used for inputDialog() calls.
     *   These correspond to the InDlgIconXxx icons.  The conventional
     *   interpreters use built-in titles when titles are needed at all,
     *   but in the Web UI we have to generate these ourselves. 
     */
    dlgTitleNone = '��������'
    dlgTitleWarning = '�������������'
    dlgTitleInfo = '��������'
    dlgTitleQuestion = '�������'
    dlgTitleError = '������'

    /*
     *   Standard dialog button labels, for the Web UI.  These are built in
     *   to the conventional interpreters, but in the Web UI we have to
     *   generate these ourselves.  
     */
    dlgButtonOk = 'OK'
    dlgButtonCancel = '�����'
    dlgButtonYes = '���'
    dlgButtonNo = '���'

    /* web UI alert when a new user has joined a multi-user session */
    webNewUser(name) { "\b[<<name>> ���� �������� ���� ��������.]\n"; }

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
        return warning + ' ������ �� ����������;';
    }
    inputFileScriptWarningButtons = [
        '&���, �� ����� ����� ����� ��� �������', '&������� ����� �������', '&����������� ��� ��������']
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
        "<.parser>� ������� ��� ������������ ����� ��� ������.<./parser> ";
    }

    /* a special topic can't be used right now, because it's inactive */
    specialTopicInactive(actor)
    {
        "<.parser>���� � ������ ��� ������ �� �������������� ����� �� ������.<./parser> ";
    }

    /* no match for a noun phrase */
    noMatch(actor, action, txt) { action.noMatch(self, actor, txt); }

    /*
     *   No match message - we can't see a match for the noun phrase.  This
     *   is the default for most verbs. 
     */
    noMatchCannotSee(actor, txt)
        { "<<actor.oName>> ��� <<actor.verbBlepo>> <<txt>> {���|����}. "; }

    /*
     *   No match message - we're not aware of a match for the noun phrase.
     *   Some sensory actions, such as LISTEN TO and SMELL, use this
     *   variation instead of the normal version; the things these commands
     *   refer to tend to be intangible, so "you can't see that" tends to
     *   be nonsensical. 
     */
    noMatchNotAware(actor, txt)
        { "{���/�����} ��� {�������} ���� ������� �� <<txt>> {���|����}. "; }

    /* 'all' is not allowed with the attempted action */
    allNotAllowed(actor)
    {
        "<.parser>� ������ <q>���</q> ��� ������ �� �������������� �� ���� �� ����.<./parser> ";
    }

    /* no match for 'all' */
    noMatchForAll(actor)
    {
        "<.parser>{���/�����} ��� {�����} ���� ��������� {���|����}.<./parser> ";
    }

    /* nothing left for 'all' after removing 'except' items */
    noMatchForAllBut(actor)
    {
        "<.parser>{���/�����} ��� {�����} ���� ���� {���|����}.<./parser> ";
    }

    /* nothing left in a plural phrase after removing 'except' items */
    noMatchForListBut(actor) { noMatchForAllBut(actor); }

    /* no match for a pronoun */
    noMatchForPronoun(actor, typ, pronounWord)
    {
        /* show the message */
        "<.parser>� ���� <q><<pronounWord>></q> ��� ���������� �� ���� ����� �� ������.<./parser> ";
    }

    /*
     *   Ask for a missing object - this is called when a command is
     *   completely missing a noun phrase for one of its objects.  
     */
    askMissingObject(actor, action, which)
    {
        reportQuestion('<.parser>\^' + action.whatObj(which)
                       + ' ������ '
                       + (actor.referralPerson == ThirdPerson
                          ? actor.oName : '')
                       + ' �� '
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
        "<.parser>������ �� ���� ��� �������� ��� �� <<action.whatObj(which)>> ������
        <<actor.referralPerson == ThirdPerson ? actor.oName : ''>>
        �� <<action.getQuestionInf(which)>>.<./parser> ";
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
        "<.parser>�������� ���� ��� �������� 
        �� <<action.whatObj(which)>> ��
        <<action.getQuestionInf(which)>>.  ����������, ��� ����������,
        <<action.getQuestionInf(which)>> <q>����</q>.<./parser> ";
    }

    /* reflexive pronoun not allowed */
    reflexiveNotAllowed(actor, typ, pronounWord)
    {
        "<.parser>� ������� ��� ������������ ��� �� �������������� ��� ����
        <q><<pronounWord>></q> ���� ����� ��� �����.<./parser> ";
    }

    /*
     *   a reflexive pronoun disagrees in gender, number, or something
     *   else with its referent 
     */
    wrongReflexive(actor, typ, pronounWord)
    {
        "<.parser>� ������� ��� ������������ �� �� ���������� � ���� <q><<pronounWord>></q>.<./parser> ";
    }

    /* no match for a possessive phrase */
    noMatchForPossessive(actor, owner, txt)
    {
        "<.parser>\^{� owner/�����}
        ��� �������� �� ���� ������ ������ �����������.<./parser> ";
    }

    /* no match for a plural possessive phrase */
    noMatchForPluralPossessive(actor, txt)
    {
        "<.parser>\^����� ��� <<tSel('��������', '������')>> �� ����� ������ �����������.<./parser> ";
    }

    /* no match for a containment phrase */
    noMatchForLocation(actor, loc, txt)
    {
        "<.parser>\^{O actor/�����} ��� ������ <<loc.childInName(txt)>>.<./parser> ";
    }

    /* nothing in a container whose contents are specifically requested */
    nothingInLocation(actor, loc)
    {
        "<.parser>\^{O actor/�����} ��� ������
        <<loc.childInName('������ ����������')>>.<./parser> ";
    }

    /* no match for the response to a disambiguation question */
    noMatchDisambig(actor, origPhrase, disambigResponse)
    {
        /*
         *   show the message, leaving the <.parser> tag mode open - we
         *   always show another disambiguation prompt after this message,
         *   so we'll let the prompt close the <.parser> mode 
         */
        "<.parser>���� ��� ���� ��� ��� ��� ��������. ";
    }

    /* empty noun phrase ('take the') */
    emptyNounPhrase(actor)
    {
        "<.parser>�������� ��� ������� ������ ����� ����������.<./parser> ";
    }

    /* 'take zero books' */
    zeroQuantity(actor, txt)
    {
        "<.parser>\^<<actor.oName>> ��� <<actor.verbBoro>> �� ����� ���� ������ �� �������� �������� ��� ����.<./parser> ";
    }

    /* insufficient quantity to meet a command request ('take five books') */
    insufficientQuantity(actor, txt, matchList, requiredNum)
    {
        "<.parser>\^{O actor/�����} ��� ������ ���� �����
        <<txt>> <<tSel('���', '����')>>.<./parser> ";
    }

    /* a unique object is required, but multiple objects were specified */
    uniqueObjectRequired(actor, txt, matchList)
    {
        "<.parser>��� ������� �� ��������������� ����� ����������� {���|����}.<./parser> ";
    }

    /* a single noun phrase is required, but a noun list was used */
    singleObjectRequired(actor, txt)
    {
        "<.parser>��� ������������ ����� ����������� �� ����� ��� ������.<./parser> ";
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
        "<.parser>��� ������� ����� ������ ��������. ";
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
                "���� ���������,
                <<askDisambigList(matchList, fullMatchList, nil, dist)>>;";
            else
                "���� <<originalText>> �������,
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
                "���� <<spellInt(requiredNum)>> (��� ��
                <<askDisambigList(matchList, fullMatchList, true, dist)>>)
                �������;";
            else
                "���� <<spellInt(requiredNum)>>
                (��� �� <<askDisambigList(matchList, fullMatchList,
                                      true, dist)>>) �������;";
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
        "<.parser>� ������� ��� �������� ����
        <<originalText>> �������.<./parser> ";
    }

    /* the actor is missing in a command */
    missingActor(actor)
    {
        "<.parser>������ �� ����� ��� �������� �� <<
        whomPronoun>> {������|������} �� ����������.<./parser> ";
    }

    /* only a single actor can be addressed at a time */
    singleActorRequired(actor)
    {
        "<.parser>�������� �� ������������ ���� �� ��� ����� ��� ����.<./parser> ";
    }

    /* cannot change actor mid-command */
    cannotChangeActor()
    {
        "<.parser>��� �������� �� ������������ �� ���� ��� ���� ��������� �� ��� ������ ������� �� ����� ��� �������.<./parser> ";
    }

    /*
     *   tell the user they entered a word we don't know, offering the
     *   chance to correct it with "oops" 
     */
    askUnknownWord(actor, txt)
    {
        /* start the message */
        "<.parser>� ���� <q><<txt>></q> ��� ����� ���������� �� ����� ��� �������.<./parser> ";

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
        "<.parser>� ������� ��� ������������ ����� ��� ������.<./parser> ";
    }

    /* the actor refuses the command because it's busy with something else */
    refuseCommandBusy(targetActor, issuingActor)
    {
        "\^<<targetActor.nameIs>> ����� �������������. ";
    }

    /* cannot speak to multiple actors */
    cannotAddressMultiple(actor)
    {
        "<.parser>\^<<actor.oName>> ��� ������ �� ��������� �� ����� �����
		����������.<./parser> ";
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
        "\^{O actor/�����} ��� ������. ";
    }

    /* no match for a noun phrase */
    noMatchCannotSee(actor, txt)
        { "\^{O actor/�����} ��� ������ <<txt>>. "; }
    noMatchNotAware(actor, txt)
        { "\^{O actor/�����} ��� ����� ������ ��� ������ <<txt>>. "; }

    /* no match for 'all' */
    noMatchForAll(actor)
    {
        "<.parser>\^{O actor/�����} ��� ������ ������ ���������.<./parser> ";
    }

    /* nothing left for 'all' after removing 'except' items */
    noMatchForAllBut(actor)
    {
        "<.parser>\^{O actor/�����} ��� ������ ������
        else.<./parser> ";
    }

    /* insufficient quantity to meet a command request ('take five books') */
    insufficientQuantity(actor, txt, matchList, requiredNum)
    {
        "<.parser>\^{O actor/�����} ��� ������ ���{-��-�-�} <<txt>>.<./parser> ";
    }

    /*
     *   we found an ambiguous noun phrase, but we were unable to perform
     *   interactive disambiguation 
     */
    ambiguousNounPhrase(actor, originalText, matchList, fullMatchList)
    {
        "<.parser>\^{O actor/�����} ��� ����� {�����}
        <<originalText>> �������.<./parser> ";
    }

    /*
     *   Missing object query and error message templates 
     */
    askMissingObject(actor, action, which)
    {
        reportQuestion('<.parser>\^' + action.whatObj(which)
                       + ' ������ ' + actor.oNameObj + ' �� '
                       + action.getQuestionInf(which) + ';<./parser> ');
    }
    missingObject(actor, action, which)
    {
        "<.parser>������ �� ������ ��� ����� <<action.whatObj(which)>> ������ <<actor.toNameObj>> ��
        <<action.getQuestionInf(which)>>.<./parser> ";
    }

    /* missing literal phrase query and error message templates */
    missingLiteral(actor, action, which)
    {
        "<.parser>������ �� ������ ��� ����� ��� �� <<action.whatObj(which)>>
        ������ <<actor.oNameObj>> �� <<action.getQuestionInf(which)>>.
        ��� ����������: <<actor.oName>>, <<action.getQuestionInf(which)>>
        <q>����</q>.<./parser> ";
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
        "\^<<actor.nameVerb('�����')>> �������. <q>��� ����� ������� <<txt>>.</q> ";
    }
    noMatchNotAware(actor, txt)
    {
        "<q>��� ������� ���� ���  <<txt>>,</q> <<actor.nameSays>>. ";
    }

    /* no match for 'all' */
    noMatchForAll(actor)
    {
        "\^<<actor.nameSays>>, <q>��� ����� ������ ���������.</q> ";
    }

    /* nothing left for 'all' after removing 'except' items */
    noMatchForAllBut(actor)
    {
        "\^<<actor.nameSays>>, <q>��� ����� ���� ���� ���.</q> ";
    }

    /* 'take zero books' */
    zeroQuantity(actor, txt)
    {
        "\^<<actor.nameSays>>,
        <q>��� ����� �� �� ���� ���� ���� ��� �������� �������� ��� ��� �����������.</q> ";
    }

    /* insufficient quantity to meet a command request ('take five books') */
    insufficientQuantity(actor, txt, matchList, requiredNum)
    {
        "\^<<actor.nameSays>>,
        <q>��� ����� ���� ����� <<txt>> ���.</q> ";
    }

    /* a unique object is required, but multiple objects were specified */
    uniqueObjectRequired(actor, txt, matchList)
    {
        "\^<<actor.nameSays>>,
        <q>��� ����� �� ������������� ���� ����� ����������� ���� ����� ��� �����.</q> ";
    }

    /* a single noun phrase is required, but a noun list was used */
    singleObjectRequired(actor, txt)
    {
        "\^<<actor.nameSays>>,
        <q>��� ����� �� ������������� ���� ����� ����������� ���� ����� ��� �����.</q> ";
    }

    /* no match for the response to a disambiguation question */
    noMatchDisambig(actor, origPhrase, disambigResponse)
    {
        /* leave the quote open for the re-prompt */
        "\^<<actor.nameSays>>,
        <q>���� ��� ���� ��� ��� ��� ��������. ";
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
        <q>��� ������� ����� ������ ��������. ";
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
            
            "���� <<originalText>> ��������, <<
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
            
            "���� <<spellInt(requiredNum)>> (��� <<
            askDisambigList(matchList, fullMatchList, true, dist)>>)
            �������?</q> ";
        }
    }

    /*
     *   we found an ambiguous noun phrase, but we were unable to perform
     *   interactive disambiguation 
     */
    ambiguousNounPhrase(actor, originalText, matchList, fullMatchList)
    {
        "\^<<actor.nameSays>>,
        <q>��� ���� ���� <<originalText>> �������.</q> ";
    }

    /*
     *   Missing object query and error message templates 
     */
    askMissingObject(actor, action, which)
    {
        reportQuestion('\^' + actor.nameSays
                       + ', <q>\^' + action.whatObj(which)
                       + ' ������ �� '
                       + action.getQuestionInf(which) + ';</q> ');
    }
    missingObject(actor, action, which)
    {
        "\^<<actor.nameSays>>,
        <q>��� ������� <<action.whatObj(which)>>
        ��� ������ �� <<action.getQuestionInf(which)>>.</q> ";
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
        <q>��� ������� �� ���� <q><<txt>></q>.</q> ";
    }

    /* tell the user they entered a word we don't know */
    wordIsUnknown(actor, txt)
    {
        "\^<<actor.nameSays>>,
        <q>����� ����� ���� ����� ��� ��� �������.</q> ";
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
        <q>��� �������� �� ���������.</q> ";
    }

    /* no match for a noun phrase */
    noMatchCannotSee(actor, txt)
    {
        "\^<<actor.nameSays>>, <q>��� ���� ������� <<txt>>.</q> ";
    }
    noMatchNotAware(actor, txt)
    {
        "\^<<actor.nameSays>>, <q>��� ������� ������ <<txt>>.</q> ";
    }

    /* no match for 'all' */
    noMatchForAll(actor)
    {
        "\^<<actor.nameSays>>, <q>��� ���� ���� ���������.</q> ";
    }

    /* nothing left for 'all' after removing 'except' items */
    noMatchForAllBut(actor)
    {
        "\^<<actor.nameSays>>,
        <q>��� ���� ���� ��� ����� �����������.</q> ";
    }

    /* empty noun phrase ('take the') */
    emptyNounPhrase(actor)
    {
        "\^<<actor.nameSays>>,
        <q>������� ������ ������������.</q> ";
    }

    /* 'take zero books' */
    zeroQuantity(actor, txt)
    {
        "\^<<actor.nameSays>>,
        <q>��� �������� �� ���������.</q> ";
    }

    /* insufficient quantity to meet a command request ('take five books') */
    insufficientQuantity(actor, txt, matchList, requiredNum)
    {
        "\^<<actor.nameSays>>,
        <q>��� ���� ������ <<txt>>.</q> ";
    }

    /* a unique object is required, but multiple objects were specified */
    uniqueObjectRequired(actor, txt, matchList)
    {
        "\^<<actor.nameSays>>,
        <q>��� �������� �� ���������.</q> ";
    }

    /* a unique object is required, but multiple objects were specified */
    singleObjectRequired(actor, txt)
    {
        "\^<<actor.nameSays>>,
        <q>��� �������� �� ������ �� ����.</q> ";
    }

    /*
     *   we found an ambiguous noun phrase, but we were unable to perform
     *   interactive disambiguation 
     */
    ambiguousNounPhrase(actor, originalText, matchList, fullMatchList)
    {
        "\^<<actor.nameSays>>,
        <q>��� �������� �� �������� �� ���� <<originalText>> �����������.</q> ";
    }

    /* an object phrase was missing */
    askMissingObject(actor, action, which)
    {
        reportQuestion('\^' + actor.nameSays
                       + ', <q>��� ����� '
                       + action.whatObj(which) + ' ��� ������ �� '
                       + action.getQuestionInf(which) + '.</q> ');
    }

    /* tell the user they entered a word we don't know */
    wordIsUnknown(actor, txt)
    {
        "\^<<actor.nameSays>>,
        <q>����� ����� ����� ��� ��� �������.</q> ";
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
    cannotDoThatMsg = '{���/�����} ��� {�����} ��  {����} ���� ������.<<withTensePresent>> '

    /* must be holding something before a command */
    mustBeHoldingMsg(obj)
    {
        gMessageParams(obj);
        return '{���/�����} ������ ��  {������} {��� obj/�����} ��� �� {����} ���� ������.<<withTensePresent>> ';
    }

    /* it's too dark to do that */
    tooDarkMsg = '����� ���� �������� ��� �� ��������������� ���� ������. '

    /* object must be visible */
    mustBeVisibleMsg(obj)
    {
        gMessageParams(obj);
        return '{���/�����} ��� {�����} ��  {�����} {��� obj/�����}.<<withTensePresent>> ';
    }

    /* object can be heard but not seen */
    heardButNotSeenMsg(obj)
    {
        gMessageParams(obj);
        return '{���/�����} {�����} ��  {�����} {����/��� obj}, ���� ��� {�����} �� {���/���/�� obj}  {�����}.<<withTensePresent>> ';
    }

    /* object can be smelled but not seen */
    smelledButNotSeenMsg(obj)
    {
        gMessageParams(obj);
        return '{���/�����} {�����} ��  {������} {����/��� obj}, ���� ��� {�����} �� {���/���/�� obj}  {�����}.<<withTensePresent>>. ';
    }

    /* cannot hear object */
    cannotHearMsg(obj)
    {
        gMessageParams(obj);
        return '��� {�����} ��  {�����} {��� obj/�����}.<<withTensePresent>> ';
    }

    /* cannot smell object */
    cannotSmellMsg(obj)
    {
        gMessageParams(obj);
        return '��� {�����} ��  {������} {��� obj/�����}.<<withTensePresent>> ';
    }

    /* cannot taste object */
    cannotTasteMsg(obj)
    {
        gMessageParams(obj);
        return '��� {�����} ��  {�������} {��� obj/�����}.<<withTensePresent>> ';
    }

    /* must remove an article of clothing before a command */
    cannotBeWearingMsg(obj)
    {
        gMessageParams(obj);
        return '{���/�����} ������ ��  {�����} {��� obj/�����}
                ������ �� {����� actor} �� {���� actor} ���� ������.<<withTensePresent>> ';
    }

    /* all contents must be removed from object before doing that */
    mustBeEmptyMsg(obj)
    {
        gMessageParams(obj);
        return '{���/�����} ������ ��  {�����} �,�� ������� ���� {���� obj/�������}
                ������ �� {����� actor} �� {���� actor} ���� ������.<<withTensePresent>>  ';
    }

    /* object must be opened before doing that */
    mustBeOpenMsg(obj)
    {
        gMessageParams(obj);
        return '{���/�����} ������ ��  {������} {��� obj/�����}
                ������ �� {����� actor} �� {���� actor} ���� ������.<<withTensePresent>> ';
    }

    /* object must be closed before doing that */
    mustBeClosedMsg(obj)
    {
        gMessageParams(obj);
        return '{���/�����} ������ ��  {������} {��� obj/�����}
               ������ �� {����� actor} �� {���� actor} ���� ������.<<withTensePresent>> ';
    }

    /* object must be unlocked before doing that */
    mustBeUnlockedMsg(obj)
    {
        gMessageParams(obj);
        return '{���/�����} ������ ��  ��{��������} {��� obj/�����}
                ������ �� {����� actor} �� {���� actor} ���� ������.<<withTensePresent>> ';
    }

    /* no key is needed to lock or unlock this object */
    noKeyNeededMsg = '{� dobj/�����} ��� �������� �� ���������� ������. '

    /* actor must be standing before doing that */
    mustBeStandingMsg = '{���/�����} ������ ��  {��������} ������ �� {�����} �� {����} ���� ������.<<withTensePresent>> '

    /* must be sitting on/in chair */
    mustSitOnMsg(obj)
    {
        gMessageParams(obj);
        return '{���/�����} ������ ����� ��  {�������} {���� obj}.<<withTensePresent>> ';
    }

    /* must be lying on/in object */
    mustLieOnMsg(obj)
    {
        gMessageParams(obj);
        return '{���/�����} ������ ����� ��  {�������} {���� obj}.<<withTensePresent>> ';
    }

    /* must get on/in object */
    mustGetOnMsg(obj)
    {
        gMessageParams(obj);
        return '{���/�����} ������ ����� ��  {������} {���� obj}.<<withTensePresent>> ';
    }

    /* object must be in loc before doing that */
    mustBeInMsg(obj, loc)
    {
        gMessageParams(obj, loc);
        return '{� obj/�����} ������ ��  {�����} {���� loc} ������ �� {����� actor} �� {���� actor} ���� ������.<<withTensePresent>> ';
    }

    /* actor must be holding the object before we can do that */
    mustBeCarryingMsg(obj, actor)
    {
        gMessageParams(obj, actor);
        return '������ ��  {������ actor} {��� obj/�����}
            ������ �� {����� actor} �� {���� actor} ���� ������.<<withTensePresent>> ';
    }

    /* generic "that's not important" message for decorations */
    decorationNotImportantMsg(obj)
    {
        gMessageParams(obj);
        return '{� obj/�����} ��� {�����} ��������{-��-�-�}. ';
    }

    /* generic "you don't see that" message for "unthings" */
    unthingNotHereMsg(obj)
    {
        gMessageParams(obj);
        return '{���/�����} ��� {�����} {��� obj/�����} {���|����}. ';
    }

    /* generic "that's too far away" message for Distant items */
    tooDistantMsg(obj)
    {
        gMessageParams(obj);
        return '{� obj/�����} {�����} ���� ������. ';
    }

    /* generic "no can do" message for intangibles */
    notWithIntangibleMsg(obj)
    {
        gMessageParams(obj);
        return '{���/�����} ��� {�����} ��  �� {����} ���� {������/����� obj}. ';
    }

    /* generic failure message for varporous objects */
    notWithVaporousMsg(obj)
    {
        gMessageParams(obj);
        return '{���/�����}  ��� {�����} ��  �� {����} ���� {������/����� obj}. ';
    }

    /* look in/look under/look through/look behind/search vaporous */
    lookInVaporousMsg(obj)
    {
        gMessageParams(obj);
        return '{���/�����} {�����} ���� {��� obj/�����}. ';
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
        return '{���/�����} ��� {�����} {��� obj/�����}. ';
    }

    /* cannot reach an object through an obstructor */
    cannotReachThroughMsg(obj, loc)
    {
        gMessageParams(obj, loc);
        return '{���/�����} ��� {�����} {��� obj/�����} ���� ���<<withTensePresent>> '
               + '{��� loc/�����}. ';
    }

    /* generic long description of a Thing */
    thingDescMsg(obj)
    {
        gMessageParams(obj);
        return '{���/�����} ��� {�����} ������ ���������� ����<<withTensePresent>> '
               + '{���� obj/�������}. ';
    }

    /* generic LISTEN TO description of a Thing */
    thingSoundDescMsg(obj)
        { return '{���/�����} ��� {�����} ������ ����������.<<withTensePresent>> '; }

    /* generic "smell" description of a Thing */
    thingSmellDescMsg(obj)
        { return '{���/�����} ��� {������} ������ ����������.<<withTensePresent>> '; }

    /* default description of a non-player character */
    npcDescMsg(npc)
    {
        gMessageParams(npc);
        return '{���/�����} ��� {�����} ������ ���������� ���� '
               + '{���� npc/�������}. ';
    }

    /* generic messages for looking prepositionally */
    nothingInsideMsg =
        '��� ������� ������ ���������� ���� {���� dobj/�������}. '
    nothingUnderMsg =
        '{���/�����} ��� {�����} ������ ���������� ���� ��� {��� dobj/�����}. '
    nothingBehindMsg =
        '{���/�����} ��� {�����} ������ ���������� ���� ��� {��� dobj/�����}. '
    nothingThroughMsg =
        '{���/�����} ��� {�����} ������ ���� ��� {��� dobj/�����}. '

    /* this is an object we can't look behind/through */
    cannotLookBehindMsg = '{���/�����} ��� {�����} ��  {�����} ����� ���� ��� {��� dobj/�����}.<<withTensePresent>> '
    cannotLookUnderMsg = '{���/�����} ��� {�����} ��  {�����} ����� ���� ��� {��� dobj/�����}.<<withTensePresent>> '
    cannotLookThroughMsg = '{���/�����} ��� {�����} ��  {�����} ���� ��� {��� dobj/�����}.<<withTensePresent>> '

    /* looking through an open passage */
    nothingThroughPassageMsg = '{���/�����} ��� {�����} ��  {�����} ����� ���� ��� {��� dobj/�����} ��� ���� �� ������.<<withTensePresent>> '

    /* there's nothing on the other side of a door we just opened */
    nothingBeyondDoorMsg = '�� ������� {��� dobj/�����} ��� ����������� ������ ����������. '

    /* there's nothing here with a specific odor */
    nothingToSmellMsg =
        '��� {������ actor} ������ ����������. '

    /* there's nothing here with a specific noise */
    nothingToHearMsg = '��� {����� actor} ������ ����������. '

    /* a sound appears to be coming from a source */
    noiseSourceMsg(src)
    {
        return '{� dobj/�����} �������� ��� �� ������� ��� '
            + src.tonNameObj + '. ';
    }

    /* an odor appears to be coming from a source */
    odorSourceMsg(src)
    {
        return '{� dobj/�����} �������� ��� �� ������� ��� '
            + src.tonNameObj + '. ';
    }

    /* an item is not wearable */
    notWearableMsg =
        '{� dobj/�����} ��� {�����} ���� ��� ������ �� �������. '

    /* doffing something that isn't wearable */
    notDoffableMsg =
        '{� dobj/�����} ��� {�����} ���� ��� ������ �� ���������. '

    /* already wearing item */
    alreadyWearingMsg = '��� {����� actor} {��� dobj/�����}. '

    /* not wearing (item being doffed) */
    notWearingMsg = '{���/�����} ��� {�����} {��� dobj/�����}. '

    /* default response to 'wear obj' */
    okayWearMsg = '�������, ���� {����� actor} {��� dobj/�����}. '

    /* default response to 'doff obj' */
    okayDoffMsg = '�������, {���/�����} ��� {�����} ����� {��� dobj/�����}. '

    /* default response to open/close */
    okayOpenMsg = shortTMsg(
        '���������. ', '{���/�����} {������} {��� dobj/�����}. ')
    okayCloseMsg = shortTMsg(
        '�������. ', '{���/�����} {������} {��� dobj/�����}. ')

    /* default response to lock/unlock */
    okayLockMsg = shortTMsg(
        '����������. ', '{���/�����} {��������} {��� dobj/�����}. ')
    okayUnlockMsg = shortTMsg(
        '������������. ', '{���/�����} ��{��������} {��� dobj/�����}. ')

    /* cannot dig here */
    cannotDigMsg = '{���/�����} ��� {���} ������� ���� ��� ��  {�����} ���� {���� dobj/�������}.<<withTensePresent>> '

    /* not a digging implement */
    cannotDigWithMsg =
        '{���/�����} ��� {�����} ������� ����� �� ��� ����� �� ������ �� �������������� {� iobj/�����} ��� ������. '

    /* taking something already being held */
    alreadyHoldingMsg = '{���/�����} ��� {��������} {��� dobj/�����}. '

    /* actor taking self ("take me") */
    takingSelfMsg = '{���/�����} ��� {�����} ��  {������} ��� ����� {���/���/���}.<<withTensePresent>> '

    /* dropping an object not being carried */
    notCarryingMsg = '{���/�����} ��� {��������} {��� dobj/�����}. '

    /* actor dropping self */
    droppingSelfMsg = '{���/�����} ��� {�����} ��  {�����} ��� ����� {���/���/���} �� �����.<<withTensePresent>> '

    /* actor putting self in something */
    puttingSelfMsg = '{���/�����} ��� {�����} ��  {����} ���� ������ ���� ����� {���/���/���}.<<withTensePresent>> '

    /* actor throwing self */
    throwingSelfMsg = '{���/�����} ��� {�����} ��  {�����} ��� ����� {���/���/���}.<<withTensePresent>> '

    /* we can't put the dobj in the iobj because it's already there */
    alreadyPutInMsg = '{� dobj/�����} {�����} ��� ���� {���� iobj/�������}. '

    /* we can't put the dobj on the iobj because it's already there */
    alreadyPutOnMsg = '{� dobj/�����} {�����} ��� ���� {���� iobj/�������}. '

    /* we can't put the dobj under the iobj because it's already there */
    alreadyPutUnderMsg = '{� dobj/�����} {�����} ��� ���� ��� {��� iobj/�����}. '

    /* we can't put the dobj behind the iobj because it's already there */
    alreadyPutBehindMsg = '{� dobj/�����} {�����} ��� ���� ��� {��� iobj/�����}. '

    /*
     *   trying to move a Fixture to a new container by some means (take,
     *   drop, put in, put on, etc) 
     */
    cannotMoveFixtureMsg = '{� dobj/�����} ��� ����� ������ �� �����������. '

    /* trying to take a Fixture */
    cannotTakeFixtureMsg = '{���/�����} ��� {�����} ��  {������} {��� dobj/�����}.<<withTensePresent>>  '

    /* trying to put a Fixture in something */
    cannotPutFixtureMsg = '{���/�����} ��� {�����} ��  {����} {��� dobj/�����} �������.<<withTensePresent>>  '

    /* trying to take/move/put an Immovable object */
    cannotTakeImmovableMsg = '{���/�����} ��� {�����} ��  {������} {��� dobj/�����}.<<withTensePresent>> '
    cannotMoveImmovableMsg = '{� dobj/�����} ��� ����� ������ �� �����������. '
    cannotPutImmovableMsg = '{���/�����} ��� {�����} ��  {����} {��� dobj/�����} �������.<<withTensePresent>> '

    /* trying to take/move/put a Heavy object */
    cannotTakeHeavyMsg = '{� dobj/�����} {�����} ���� ���{-��-��-�}. '
    cannotMoveHeavyMsg = '{� dobj/�����} {�����} ���� ���{-��-��-�}. '
    cannotPutHeavyMsg = '{� dobj/�����} {�����} ���� ���{-��-��-�}. '

    /* trying to move a component object */
    cannotMoveComponentMsg(loc)
    {
        return '{� dobj/�����} ����� ����� ' + loc.touNameObj + '. ';
    }

    /* trying to take a component object */
    cannotTakeComponentMsg(loc)
    {
        return '{���/�����} ��� {�����} ��  {���/���/�� dobj} {������}. '
            + '{� dobj/�����} ����� ����� ' + loc.touNameObj + '. ';
    }

    /* trying to put a component in something */
    cannotPutComponentMsg(loc)
    {
        return '{���/�����} ��� {�����} ��  {���/���/�� dobj} {����} �������. '
            + '{� dobj/�����} ����� ����� ' + loc.touNameObj + '. ';
    }

    /* specialized Immovable messages for TravelPushables */
    cannotTakePushableMsg = '{���/�����} ��� {�����} ��  {���/���/�� dobj} {������}, 
	���� {it actor/he} ���� ��  {�����} �� {���/���/�� dobj} {�������} �����.<<withTensePresent>> '
    cannotMovePushableMsg = '��� �� ����������� �� ���� � ������ ���������� {��� dobj/�����}, ���� ���� {it actor/he}
        ��  {�����} �� {���/���/�� dobj} {������� actor} ���� ��� ������������ ����������.<<withTensePresent>> '
    cannotPutPushableMsg = '{���/�����} ��� {�����} ��  {���/���/�� dobj} {����} �������,
       ���� {it actor/he} ���� ��  {�����} �� {���/���/�� dobj} {�������} �����.<<withTensePresent>> '

    /* can't take something while occupying it */
    cannotTakeLocationMsg = '{���/�����} ��� {�����} ��  {���/���/�� dobj} {������} 
        ��� {���/���/�� dobj} {�����������}.<<withTensePresent>> '

    /* can't REMOVE something that's being held */
    cannotRemoveHeldMsg = '��� ������� ���� ��� �� ����� �� ������ �� ��������� {� dobj/�����}. '

    /* default 'take' response */
    okayTakeMsg = shortTMsg(
        '�������. ', '{���/�����} {������} {��� dobj/�����}. ')

    /* default 'drop' response */
    okayDropMsg = shortTMsg(
        '�������. ', '{���/�����} {�����} {��� dobj/�����} �� �����. ')

    /* dropping an object */
    droppingObjMsg(dropobj)
    {
        gMessageParams(dropobj);
        return '{���/�����} {�����} {��� dropobj/�����} �� �����. ';
    }

    /* default receiveDrop suffix for floorless rooms */
    floorlessDropMsg(dropobj)
    {
        gMessageParams(dropobj);
        return '{����� dropobj} {������|�����} ���� �� ������ ��� ��� ��������. ';
    }

    /* default successful 'put in' response */
    okayPutInMsg = shortTIMsg(
        '�����. ', '{���/�����} {����} {��� dobj/�����} ���� {���� iobj/�������}. ')

    /* default successful 'put on' response */
    okayPutOnMsg = shortTIMsg(
        '�����. ', '{���/�����} {����} {��� dobj/�����} ���� {���� iobj/�������}. ')

    /* default successful 'put under' response */
    okayPutUnderMsg = shortTIMsg(
        '�����. ', '{���/�����} {����} {��� dobj/�����} ���� ��� {��� iobj/�����}. ')

    /* default successful 'put behind' response */
    okayPutBehindMsg = shortTIMsg(
        '�����. ', '{���/�����} {����} {��� dobj/�����} ���� ��� {��� iobj/�����}. ')

    /* try to take/move/put/taste an untakeable actor */
    cannotTakeActorMsg = '{� dobj/�����} ��� �� ��������� �� {�����/�����} �� {����} ���� ������.'
    cannotMoveActorMsg = '{� dobj/�����} ��� �� ��������� �� {�����/�����} �� {����} ���� ������. '
    cannotPutActorMsg = '{� dobj/�����} ��� �� ��������� �� {�����/�����} �� {����} ���� ������. '
    cannotTasteActorMsg = '{� dobj/�����} ��� �� ��������� �� {�����/�����} �� {����} ���� ������. '

    /* trying to take/move/put/taste a person */
    cannotTakePersonMsg =
        '������, ���� ��� �� ����� {���� dobj/�������}. '
    cannotMovePersonMsg =
        '������, ���� ��� �� ����� {���� dobj/�������}. '
    cannotPutPersonMsg =
        '������, ���� ��� �� ����� {���� dobj/�������}. '
    cannotTastePersonMsg =
        '������, ���� ��� �� ����� {���� dobj/�������}. '

    /* cannot move obj through obstructor */
    cannotMoveThroughMsg(obj, obs)
    {
        gMessageParams(obj, obs);
        return '{���/�����} ��� {�����} ��  {��������} {��� obj/�����} ���� ��� '
               + '{��� obs/�����}.<<withTensePresent>> ';
    }

    /* cannot move obj in our out of container cont */
    cannotMoveThroughContainerMsg(obj, cont)
    {
        gMessageParams(obj, cont);
        return '{���/�����} ��� {�����} ��  {��������} {��� obj/�����} ���� ��� '
               + '{��� cont/�����}.<<withTensePresent>> ';
    }

    /* cannot move obj because cont is closed */
    cannotMoveThroughClosedMsg(obj, cont)
    {
        gMessageParams(cont);
        return '{���/�����} ��� {�����} ��  �� {����} ���� ����� {� cont/�����} ����� '
               + '������{-��-�-�}. ';
    }

    /* cannot fit obj into cont through cont's opening */
    cannotFitIntoOpeningMsg(obj, cont)
    {
        gMessageParams(obj, cont);
        return '{���/�����} ��� {�����} ��  �� {����} ���� ����� {� obj/�����} ����� ���� �����{-��-�-�} ��� �� ���� ���� {���� cont/�������}.<<withTensePresent>> ';
    }

    /* cannot fit obj out of cont through cont's opening */
    cannotFitOutOfOpeningMsg(obj, cont)
    {
        gMessageParams(obj, cont);
        return '{���/�����} ��� {�����} ��  �� {����} ���� ����� {� obj/�����} ����� ���� �����{-��-�-�} ��� �� ���� ��� {��� cont/�����}.<<withTensePresent>> ';
    }

    /* actor 'obj' cannot reach in our out of container 'cont' */
    cannotTouchThroughContainerMsg(obj, cont)
    {
        gMessageParams(obj, cont);
        return '{� obj/�����} ��� {�����} ������ ���� ��� '
               + '{��� cont/�����}. ';
    }

    /* actor 'obj' cannot reach through cont because cont is closed */
    cannotTouchThroughClosedMsg(obj, cont)
    {
        gMessageParams(obj, cont);
        return '{� obj/�����} ��� {�����} ��  �� {����} ���� �����
               {� cont/�����} ����� ������{-��-�-�}.<<withTensePresent>> ';
    }

    /* actor cannot fit hand into cont through cont's opening */
    cannotReachIntoOpeningMsg(obj, cont)
    {
        gMessageParams(obj, cont);
        return '�� ���� {��� obj/�����} ��� ������ ���� {���� cont/�������}';
    }

    /* actor cannot fit hand into cont through cont's opening */
    cannotReachOutOfOpeningMsg(obj, cont)
    {
        gMessageParams(obj, cont);
        return '�� ���� {��� obj/�����} ��� ������ ���� ��� {��� cont/�����}. ';
    }

    /* the object is too large for the actor to hold */
    tooLargeForActorMsg(obj)
    {
        gMessageParams(obj);
        return '{� obj/�����} ����� ���� �����{-��-�-�}. {���/�����} ��� {�����} ��  {������}.<<withTensePresent>> ';
    }

    /* the actor doesn't have room to hold the object */
    handsTooFullForMsg(obj)
    {
        return '�� ����� {���/���/���} {�����|����} ������ ��� �� ��������� '
               + obj.tonNameObj + '. ';
    }

    /* the object is becoming too large for the actor to hold */
    becomingTooLargeForActorMsg(obj)
    {
        gMessageParams(obj);
        return '{���/�����} ��� {�����} ��  {����} ���� ������ ����� {� obj/�����}
                �� ������� ���� �����{-��-�-�} ��� ��  {����� actor} �� �� {������ actor}.<<withTensePresent>>';
    }

    /* the object is becoming large enough that the actor's hands are full */
    handsBecomingTooFullForMsg(obj)
    {
        gMessageParams(obj);
        return '{���/�����} ��� {�����} ��  {����} ���� ������ ����� �� ����� {���/���/���} �� �������� ��� ��� �� ������ {��� obj/�����}. ';
    }

    /* the object is too heavy (all by itself) for the actor to hold */
    tooHeavyForActorMsg(obj)
    {
        gMessageParams(obj);
        return '{� obj/�����} ����� ���� ���{-��-��-�} ��� {�����/�����}. ';
    }

    /*
     *   the object is too heavy (in combination with everything else
     *   being carried) for the actor to pick up 
     */
    totalTooHeavyForMsg(obj)
    {
        gMessageParams(obj);
        return '{� obj/�����} ����� ���� ���{-��-��-�}. {���/�����} ������ ��  {�����} ���� ���� �����.<<withTensePresent>> ';
    }

    /* object is too large for container */
    tooLargeForContainerMsg(obj, cont)
    {
        gMessageParams(obj, cont);
        return '{� obj/�����} ����� ���� �����{-��-�-�} ��� {��� cont/�����}. ';
    }

    /* object is too large to fit under object */
    tooLargeForUndersideMsg(obj, cont)
    {
        gMessageParams(obj, cont);
        return '{� obj/�����} ����� ���� �����{-��-�-�} ��� �� ���� ���� ��� {��� cont/�����}. ';
    }

    /* object is too large to fit behind object */
    tooLargeForRearMsg(obj, cont)
    {
        gMessageParams(obj, cont);
        return '{� obj/�����} ����� ���� �����{-��-�-�} ��� �� ���� ���� ��� {��� cont/�����}. ';
    }

    /* container doesn't have room for object */
    containerTooFullMsg(obj, cont)
    {
        gMessageParams(obj, cont);
        return '{� cont/�����} {�����} ��� �����{-��-�-�} ��� �� ������� {��� obj/�����}. ';
    }

    /* surface doesn't have room for object */
    surfaceTooFullMsg(obj, cont)
    {
        gMessageParams(obj, cont);
        return '��� {������� |������} ����� ��� {��� obj/�����} ���� '
               + '{���� cont/�������}. ';
    }

    /* underside doesn't have room for object */
    undersideTooFullMsg(obj, cont)
    {
        gMessageParams(obj, cont);
        return '��� {������� |������} ����� ��� {��� obj/�����} ���� ��� '
               + '{��� cont/�����}. ';
    }

    /* rear surface/space doesn't have room for object */
    rearTooFullMsg(obj, cont)
    {
        gMessageParams(obj, cont);
        return '��� {������� |������} ����� ��� {��� obj/�����} ���� ��� '
               + '{��� cont/�����}. ';
    }

    /* the current action would make obj too large for its container */
    becomingTooLargeForContainerMsg(obj, cont)
    {
        gMessageParams(obj, cont);
        return '{���/�����} ��� {�����} ��  {����} ���� ������ ����� �� ����� {��� obj/�����} ���� <<withListCaseAccusative>>�����{-��-�-�} ��� {��� cont/�����}.<<withTensePresent>> ';
    }

    /*
     *   the current action would increase obj's bulk so that container is
     *   too full 
     */
    containerBecomingTooFullMsg(obj, cont)
    {
        gMessageParams(obj, cont);
        return '{���/�����} ��� {�����} ��  {����} ���� ������ ����� {� obj/�����}
            ��� �� ������� ��� ���� {���� cont/�������}.<<withTensePresent>> ';
    }

    /* trying to put an object in a non-container */
    notAContainerMsg = '{���/�����} ��� {�����} ��  {����} ������ ���� {���� iobj/�������}.<<withTensePresent>> '

    /* trying to put an object on a non-surface */
    notASurfaceMsg = '{� iobj/�����} ��� ���� ������ ��������� ���� ����� �� ������ �� ����������� ����.<<withTensePresent>> '

    /* can't put anything under iobj */
    cannotPutUnderMsg =
        '{���/�����} ��� {�����} ��  {����} ������ ���� ��� {��� iobj/�����}.<<withTensePresent>> '

    /* nothing can be put behind the given object */
    cannotPutBehindMsg = '{���/�����} ��� {�����} ��  {����} ������ ���� ��� {��� iobj/�����}.<<withTensePresent>> '

    /* trying to put something in itself */
    cannotPutInSelfMsg = '{���/�����} ��� {�����} ��  {����} {��� dobj/�����} ���� {itself}.<<withTensePresent>> '

    /* trying to put something on itself */
    cannotPutOnSelfMsg = '{���/�����} ��� {�����} ��  {����} {��� dobj/�����} ���� {itself}.<<withTensePresent>> '

    /* trying to put something under itself */
    cannotPutUnderSelfMsg = '{���/�����} ��� {�����} ��  {����} {��� dobj/�����} ���� ��� {itself}.<<withTensePresent>> '

    /* trying to put something behind itself */
    cannotPutBehindSelfMsg = '{���/�����} ��� {�����} ��  {����} {��� dobj/�����} ���� ��� {itself}.<<withTensePresent>> '

    /* can't put something in/on/etc a restricted container/surface/etc */
    cannotPutInRestrictedMsg =
        '{���/�����} ��� {�����} ��  {����} {��� dobj/�����} ���� {���� iobj/�������}.<<withTensePresent>> '
    cannotPutOnRestrictedMsg =
        '{���/�����} ��� {�����} ��  {����} {��� dobj/�����} ���� {���� iobj/�������}.<<withTensePresent>> '
    cannotPutUnderRestrictedMsg =
        '{���/�����} ��� {�����} ��  {����} {��� dobj/�����} ���� ��� {��� iobj/�����}.<<withTensePresent>> '
    cannotPutBehindRestrictedMsg =
        '{���/�����} ��� {�����} ��  {����} {��� dobj/�����} ���� ��� {��� iobj/�����}.<<withTensePresent>> '

    /* trying to return something to a remove-only dispenser */
    cannotReturnToDispenserMsg =
        '{���/�����} ��� {�����} ��  {����} {����/��� dobj} ���� {���� iobj/�������}.<<withTensePresent>> '

    /* wrong item type for dispenser */
    cannotPutInDispenserMsg =
        '{���/�����} ��� {�����} ��  {����} {����/��� dobj} ���� {���� iobj/�������}.<<withTensePresent>> '

    /* the dobj doesn't fit on this keyring */
    objNotForKeyringMsg = '{� dobj/�����} ��� {�����} {���� iobj/�������}. '

    /* the dobj isn't on the keyring */
    keyNotOnKeyringMsg = '{� dobj/�����} ��� {�����} �������{-�����-����-����} {���� iobj/�������}. '

    /* can't detach key (with no iobj specified) because it's not on a ring */
    keyNotDetachableMsg = '{� dobj/�����} ��� {�����} �������{-�����-����-����} �� ������. '

    /* we took a key and attached it to a keyring */
    takenAndMovedToKeyringMsg(keyring)
    {
        gMessageParams(keyring);
        return '{���/�����} {�����} {��� dobj/�����} ��� {���/���/��}
            {������ actor} {���� keyring/�������}. ';
    }

    /* we attached a key to a keyring automatically */
    movedKeyToKeyringMsg(keyring)
    {
        gMessageParams(keyring);
        return '{���/�����} {������} {��� dobj/�����} {���� keyring/�������}. ';
    }

    /* we moved several keys to a keyring automatically */
    movedKeysToKeyringMsg(keyring, keys)
    {
        gMessageParams(keyring);
        return '{���/�����} {������} '
            + (keys.length() > 1 ? '�� �������' : '�� ������')
            + ' {���/���/���} {���� keyring/�������}. ';
    }

    /* putting y in x when x is already in y */
    circularlyInMsg(x, y)
    {
        gMessageParams(x, y);
        return '{���/�����} ��� {�����} ��  �� {����} ���� ����� {� x/�����} {�����} ���� {���� y/�������}.<<withTensePresent>> ';
    }

    /* putting y in x when x is already on y */
    circularlyOnMsg(x, y)
    {
        gMessageParams(x, y);
        return '{���/�����} ��� {�����} ��  �� {����} ���� ����� {� x/�����} {�����} ���� {���� y/�������}.<<withTensePresent>> ';
    }

    /* putting y in x when x is already under y */
    circularlyUnderMsg(x, y)
    {
        gMessageParams(x, y);
        return '{���/�����} ��� {�����} ��  �� {����} ���� ����� {� x/�����} {�����} ���� ��� {��� y/�����}.<<withTensePresent>> ';
    }

    /* putting y in x when x is already behind y */
    circularlyBehindMsg(x, y)
    {
        gMessageParams(x, y);
        return '{���/�����} ��� {�����} ��  �� {����} ���� ����� {� x/�����} {�����} ���� ��� {��� y/�����}.<<withTensePresent>> ';
    }

    /* taking dobj from iobj, but dobj isn't in iobj */
    takeFromNotInMsg = '{� dobj/�����} ��� {�����} ���� {���� iobj/�������}. '

    /* taking dobj from surface, but dobj isn't on iobj */
    takeFromNotOnMsg = '{� dobj/�����} ��� {�����} ���� {���� iobj/�������}. '

    /* taking dobj from under something, but dobj isn't under iobj */
    takeFromNotUnderMsg = '{� dobj/�����} ��� {�����} ���� ��� {��� iobj/�����}. '

    /* taking dobj from behind something, but dobj isn't behind iobj */
    takeFromNotBehindMsg = '{� dobj/�����} ��� {�����} ���� ��� {��� iobj/�����}. '

    /* taking dobj from an actor, but actor doesn't have iobj */
    takeFromNotInActorMsg = '{� iobj/�����} ��� {���} {��� dobj/�����}. '

    /* actor won't let go of a possession */
    willNotLetGoMsg(holder, obj)
    {
        gMessageParams(holder, obj);
        return '{� holder/�����} ��� <<withTenseStigFuture>>{�����} {�����/�����} ��  {������} {��� obj/�����}.<<withTensePresent>> ';
    }

    /* must say which way to go */
    whereToGoMsg = '������ �� ����� ������� ���� ���������� ��� {���/�����} {����} ��  {�������}.<<withTensePresent>> '

    /* travel attempted in a direction with no exit */
    cannotGoThatWayMsg = '{���/�����} ��� {�����} ��  {�������} ���� �� ����.<<withTensePresent>> '

    /* travel attempted in the dark in a direction with no exit */
    cannotGoThatWayInDarkMsg = '{�����|����} ���� ��������. {���/�����} ��� {�����} ��� {�������}. '

    /* we don't know the way back for a GO BACK */
    cannotGoBackMsg = '{���/�����} ��� {����} ��� ��  {���������} ��� ���� �� ������.<<withTensePresent>> '

    /* cannot carry out a command from this location */
    cannotDoFromHereMsg = '{���/�����} ��� {�����} ��  {����} ���� ������ ��� {����|������} �� ������. <<withTensePresent>> '

    /* can't travel through a close door */
    cannotGoThroughClosedDoorMsg(door)
    {
        gMessageParams(door);
        return '{���/�����} ��� {�����} ��  �� {����} ����, ����� {� door/�����} ����� '
               + '������{-��-�-�}.<<withTensePresent>> ';
    }

    /* cannot carry out travel while 'dest' is within 'cont' */
    invalidStagingContainerMsg(cont, dest)
    {
        gMessageParams(cont, dest);
        return '{���/�����} ��� {�����} ��  �� {����} ���� ����� {� dest/�����} ����� {���� cont}.<<withTensePresent>> ';
    }

    /* cannot carry out travel while 'cont' (an actor) is holding 'dest' */
    invalidStagingContainerActorMsg(cont, dest)
    {
        gMessageParams(cont, dest);
        return '{���/�����} ��� {�����} ��  �� {����} ���� ����� {� cont/�����} {������} {��� dest/�����}.<<withTensePresent>> ';
    }
    
    /* can't carry out travel because 'dest' isn't a valid staging location */
    invalidStagingLocationMsg(dest)
    {
        gMessageParams(dest);
        return '{���/�����} ��� {�����} ��  {���} �������� {���� dest}.<<withTensePresent>> ';
    }

    /* destination is too high to enter from here */
    nestedRoomTooHighMsg(obj)
    {
        gMessageParams(obj);
        return '{� obj/�����} {�����} ���� ���� ��� �� ����� ���������{-��-�-�} ��� ���� �� ������. ';
    }

    /* enclosing room is too high to reach by GETTING OUT OF here */
    nestedRoomTooHighToExitMsg(obj)
    {
        return '{�����|����} ���� ������ �� ���� ��� �� ������ �� ����� ���� ������ ��� ���� �� ������. ';
    }

    /* cannot carry out a command from a nested room */
    cannotDoFromMsg(obj)
    {
        gMessageParams(obj);
        return '{���/�����} ��� {�����} ��  �� {����} ���� ��� {��� obj/�����}. ';
    }

    /* cannot carry out a command from within a vehicle in a nested room */
    vehicleCannotDoFromMsg(obj)
    {
        local loc = obj.location;
        gMessageParams(obj, loc);
        return '{���/�����} ��� {�����} ��  �� {����} ���� ����� {� obj/�����} {�����} {���� loc}.<<withTensePresent>> ';
    }

    /* cannot go that way in a vehicle */
    cannotGoThatWayInVehicleMsg(traveler)
    {
        gMessageParams(traveler);
        return '{���/�����} ��� {�����} ��  {����} ���� ������ {���� traveler}.<<withTensePresent>> ';
    }

    /* cannot push an object that way */
    cannotPushObjectThatWayMsg(obj)
    {
        gMessageParams(obj);
        return '{���/�����} ��� {�����} ��  {�������} ���� ������ ��� ���������� ����������� {��� obj/�����}.<<withTensePresent>> ';
    }

    /* cannot push an object to a nested room */
    cannotPushObjectNestedMsg(obj)
    {
        gMessageParams(obj);
        return '{���/�����} ��� {�����} ��  {�������} {��� obj/�����} ����. ';
    }

    /* cannot enter an exit-only passage */
    cannotEnterExitOnlyMsg(obj)
    {
        gMessageParams(obj);
        return '{���/�����} ��� {�����} ��  {������} ���� {���� obj/�������} ��� {���|����}. ';
    }

    /* must open door before going that way */
    mustOpenDoorMsg(obj)
    {
        gMessageParams(obj);
        return '{���/�����} ������ ����� ��  {������} {��� obj/�����}. ';
    }

    /* door closes behind actor during travel through door */
    doorClosesBehindMsg(obj)
    {
        gMessageParams(obj);
        return '<.p>���� {���/�����} {������} ���� ��� {��� obj/�����}, {�����}
			{�������|�������} ���� {���/���/���}. ';
    }

    /* the stairway does not go up/down */
    stairwayNotUpMsg = '{� dobj/�����} ��� ���� {�������} ���� ���� �� ����. '
    stairwayNotDownMsg = '{� dobj/�����} ��� ���� {�������} ���� ���� �� ����. '

    /* "wait" */
    timePassesMsg = '� ������ {�����|��������}... '

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
        return '{���/�����} ������ ��  {����} ��� �������� '
            + gLibMessages.whomPronoun
            + ' {it actor/he} {����} ��  {�����}.<<withTensePresent>> ';
    }

    /* "yell" */
    okayYellMsg = '{���/�����} {������} ��� ��� ������ {�����}. '

    /* "jump" */
    okayJumpMsg = '{���/�����} {�����} ����, ��� {�������������} ��� ���� ������ ��� ���� <<withTenseAoristos>>{�������}. '

    /* cannot jump over object */
    cannotJumpOverMsg = '{���/�����} ��� {�����} ��  {�����} ���� ��� {��� dobj/�����}.<<withTensePresent>> '

    /* cannot jump off object */
    cannotJumpOffMsg = '{���/�����} ��� {�����} ��  {�����} ��� {��� dobj/�����}.<<withTensePresent>> '

    /* cannot jump off (with no direct object) from here */
    cannotJumpOffHereMsg = '��� ������� ������� ����� ���� �� {�����} ��  {�����} ��� ���� �� ������. '

    /* failed to find a topic in a consultable object */
    cannotFindTopicMsg =
        '{���/�����} ��� {������} ���� ��� ����� ���� {���� dobj/�������}. '

    /* an actor doesn't accept a command from another actor */
    refuseCommand(targetActor, issuingActor)
    {
        gMessageParams(targetActor, issuingActor);
        return '{� targetActor/�����} {��������} �� ������ {���/���/���}.<<withTensePresent>> ';
    }

    /* cannot talk to an object (because it makes no sense to do so) */
    notAddressableMsg(obj)
    {
        gMessageParams(obj);
        return '{���/�����} ��� {�����} ��  {�����} {���� obj/�������}. ';
    }

    /* actor won't respond to a request or other communicative gesture */
    noResponseFromMsg(other)
    {
        gMessageParams(other);
        return '{� other/�����} ��� {�������}. ';
    }

    /* trying to give something to someone who already has the object */
    giveAlreadyHasMsg = '{� iobj/�����} {���} ��� {��� dobj/�����}. '

    /* can't talk to yourself */
    cannotTalkToSelfMsg = '� ����������� �� ��� ����� {���/���/���}
        ��� �� ����� ������ ����������. '

    /* can't ask yourself about anything */
    cannotAskSelfMsg = '� ����������� �� ��� ����� {���/���/���}
        ��� �� ����� ������ ����������. '

    /* can't ask yourself for anything */
    cannotAskSelfForMsg = '� ����������� �� ��� ����� {���/���/���}
        ��� �� ����� ������ ����������. '

    /* can't tell yourself about anything */
    cannotTellSelfMsg = '� ����������� �� ��� ����� {���/���/���}
        ��� �� ����� ������ ����������. '

    /* can't give yourself something */
    cannotGiveToSelfMsg = '�� �� ���������� {� dobj/�����} ���� ����� {���/���/���}
        ��� ���� ������ �����������. '
    
    /* can't give something to itself */
    cannotGiveToItselfMsg = '�� �� ���������� {� dobj/�����} ���� ����� {���/���/���}
        ��� ���� ������ �����������. '

    /* can't show yourself something */
    cannotShowToSelfMsg = '� �������� {��� dobj/�����} ���� ����� {���/���/���} ��� ���� ������ �����������. '

    /* can't show something to itself */
    cannotShowToItselfMsg = '� �������� {��� dobj/�����} ���� ����� {���/���/���}
        ��� �� ���� ������ �����������. '

    /* can't give/show something to a non-actor */
    cannotGiveToMsg = '{���/�����} ��� {�����} ��  {����} ���� {������/����� iobj}.<<withTensePresent>> '
    cannotShowToMsg = '{���/�����} ��� {�����} ��  {������} ���� {������/����� iobj}.<<withTensePresent>> '

    /* actor isn't interested in something being given/shown */
    notInterestedMsg(actor)
    {
        return '\^' + '{� actor/�����} ��� �������� �� ������������. ';
    }

    /* vague ASK/TELL (for ASK/TELL <actor> <topic> syntax errors) */
    askVagueMsg = '<.parser>� ������� ��� ������������ ����� ��� ������.
        ��������, ������������� ��� ������ ���� ��� ������� ��� �� ���� (� ���� �� ����).<./parser> '
    tellVagueMsg = '<.parser>� ������� ��� ������������ ����� ��� ������.
        ��������, ������������� ��� ���� ������� ��� �� ���� (� ���� � ����).<./parser> '

    /* object cannot hear actor */
    objCannotHearActorMsg(obj)
    {
        return '\^' + '{� obj/�����} ������ ��� {�����}. ';
    }

    /* actor cannot see object being shown to actor */
    actorCannotSeeMsg(actor, obj)
    {
        return '\^' + '{� actor/�����} ������ ��� {�����}. '
            + obj.tonNameObj + '. ';
    }

    /* not a followable object */
    notFollowableMsg = '{���/�����} ��� {�����} ��  {��������} {��� dobj/�����}. '

    /* cannot follow yourself */
    cannotFollowSelfMsg = '{���/�����} ��� {�����} ��  {��������} ��� ����� {���/���/���}. '

    /* following an object that's in the same location as the actor */
    followAlreadyHereMsg = '{� dobj/�����} {�����} ������� �� ���� �� ������. '

    /*
     *   following an object that we *think* is in our same location (in
     *   other words, we're already in the location where we thought we
     *   last saw the object go), but it's too dark to see if that's
     *   really true 
     */
    followAlreadyHereInDarkMsg = '{� dobj/�����} �� ������ �� ��������� ������� �� ���� �� ������, ���� {���/�����} ��� {�����} {��� dobj/�����}. '

    /* trying to follow an object, but don't know where it went from here */
    followUnknownMsg = '{���/�����} ��� {���} ����� ��� �� ��� ���� {� dobj/�����}
       ��� {���|����}. '

    /*
     *   we're trying to follow an actor, but we last saw the actor in the
     *   given other location, so we have to go there to follow 
     */
    cannotFollowFromHereMsg(srcLoc)
    {
        return '� ��������� ��������� ���� ����� {���/�����} <<withTenseAoristos>>{�����} {��� dobj/�����} ���� '
            + srcLoc.getDestName(gActor, gActor.location) + '. ';
    }

    /* acknowledge a 'follow' for a target that was in sight */
    okayFollowInSightMsg(loc)
    {
        return '{���/�����} {��������} {��� dobj/�����} '
            + loc.actorIntoName + '. ';
    }

    /* obj is not a weapon */
    notAWeaponMsg = '{���/�����} ��� {�����} ��  {����������} �� ���� �� {��� iobj/�����}. '

    /* no effect attacking obj */
    uselessToAttackMsg = '{���/�����} ��� {�����} ��  {����������} {���� dobj/�������}. '

    /* pushing object has no effect */
    pushNoEffectMsg = '�� �������� {��� dobj/�����} ��� ���� ������ ����������. '

    /* default 'push button' acknowledgment */
    okayPushButtonMsg = '<q>����.</q> '

    /* lever is already in pushed state */
    alreadyPushedMsg =
        '{� dobj/�����} {�����} ��� ��� ����� {���/���/���}. '

    /* default acknowledgment to pushing a lever */
    okayPushLeverMsg = '{���/�����} {�������} {��� dobj/�����} ����� �� �����. '

    /* pulling object has no effect */
    pullNoEffectMsg = '�� �������� {��� dobj/�����} ��� {���} ������ ����������. '

    /* lever is already in pulled state */
    alreadyPulledMsg =
        '{� dobj/�����} {�����} ��� ������{-�����-����-����} ���� ����. '

    /* default acknowledgment to pulling a lever */
    okayPullLeverMsg = '{���/�����} {������} {��� dobj/�����} ����� �� �����. '

    /* default acknowledgment to pulling a spring-loaded lever */
    okayPullSpringLeverMsg = '{���/�����} {������} {��� dobj/�����}, ���
        ���������� ���� ���� ������ {���/���/���} ���� ����� {���/�����} {���/���/��} {�����}. '

    /* moving object has no effect */
    moveNoEffectMsg = '� �������� {��� dobj/�����} ��� ���� ������ ������� ����������. '

    /* cannot move object to other object */
    moveToNoEffectMsg = '���� ��� �� ������ ������ ����������. '

    /* cannot push an object through travel */
    cannotPushTravelMsg = '���� ��� �� ������ ������ ����������. '

    /* acknowledge pushing an object through travel */
    okayPushTravelMsg(obj)
    {
        return '<.p>{���/�����} {�������} ' + obj.tonNameObj
            + ' ���� ���� �������. ';
    }

    /* cannot use object as an implement to move something */
    cannotMoveWithMsg =
        '{���/�����} ��� {�����} ��  {��������} ���� �� {��� iobj/�����}. '

    /* cannot set object to setting */
    cannotSetToMsg = '{���/�����} ��� {�����} ��  {����} {��� dobj/�����} �� ������ �������. '

    /* invalid setting for generic Settable */
    setToInvalidMsg = '{� dobj/�����} ��� {���} ������ ������ �������. '

    /* default 'set to' acknowledgment */
    okaySetToMsg(val)
        { return '�������, {� dobj/�����} {�����} ������{-�����-����-����} ��� ' + val + '. '; }

    /* cannot turn object */
    cannotTurnMsg = '{���/�����} ��� {�����} ��  {������} {��� dobj/�����}. '

    /* must specify setting to turn object to */
    mustSpecifyTurnToMsg = '{���/�����} ������ ��  {����} ��� ������������ ��� ������� ���� ����� {����} �� {������} {��� dobj/�����}. '

    /* cannot turn anything with object */
    cannotTurnWithMsg =
        '{���/�����} ��� {�����} ��  {������} ������ �� {��� iobj/�����}. '

    /* invalid setting for dial */
    turnToInvalidMsg = '{� dobj/�����} ��� {���} ������ ������ �������. '

    /* default 'turn to' acknowledgment */
    okayTurnToMsg(val)
        { return '�������, {� dobj/�����} {�����} ���� ���������{-��-�-�} ���� ���� ' + val + '. '; }

    /* switch is already on/off */
    alreadySwitchedOnMsg = '{� dobj/�����} {�����} ��� �����{-��-�-�}. '
    alreadySwitchedOffMsg = '{� dobj/�����} {<<withTensePresent>>[�����]|<<withTenseAoristos>>[�����]} ��� �������{-��-�-�}. '

    /* default acknowledgment for switching on/off */
    okayTurnOnMsg = '�������, {� dobj/�����} {�����} ���� �����{-��-�-�}. '
    okayTurnOffMsg = '�������, {� dobj/�����} {�����} ���� �������{-��-�-�}. '

    /* flashlight is on but doesn't light up */
    flashlightOnButDarkMsg = '{���/�����} {<<withTensePresent>>[����������]|<<withTenseAoristos>>[����������]} {��� dobj/�����}, ����
        ��� {���������|������} ������. '

    /* default acknowledgment for eating something */
    okayEatMsg = '{���/�����} { <<withTensePresent>>[����]|<<withTenseAoristos>>[����]} {��� dobj/�����}. '

    /* object must be burning before doing that */
    mustBeBurningMsg(obj)
    {
        return '{���/�����} ������ ��  {�����} ' + obj.tonNameObj
            + ' ���� {� actor/�����}  {�����} ��  {����} ����. ';
    }

    /* match not lit */
    matchNotLitMsg = '{� dobj/�����} ��� {�����} ����{-�����-����-����}. '

    /* lighting a match */
    okayBurnMatchMsg =
        '{���/�����} {������} {��� dobj/�����}, ������������� ��� ����� �����. '

    /* extinguishing a match */
    okayExtinguishMatchMsg = '{���/�����} {�����} {��� dobj/�����} ��� {�����} ������������ �� ��� ������� ������. '

    /* trying to light a candle with no fuel */
    candleOutOfFuelMsg =
        '{� dobj/�����} {�����} ������ ������������ ���{-�����-����-����}. {�����} ��� {�����} �� ������. '

    /* lighting a candle */
    okayBurnCandleMsg = '{���/�����} {�����} {��� dobj/�����}. '

    /* extinguishing a candle that isn't lit */
    candleNotLitMsg = '{� dobj/�����} ��� {�����} ����{-�����-����-����}. '

    /* extinguishing a candle */
    okayExtinguishCandleMsg = '�����. '

    /* cannot consult object */
    cannotConsultMsg =
        '{� dobj/�����} ��� {�����} ���� ��� {���/�����} {�����} ��  {�������������}. '

    /* cannot type anything on object */
    cannotTypeOnMsg = '{���/�����} ��� {�����} ��  {�����������} ������ {���� dobj/�������}. '

    /* cannot enter anything on object */
    cannotEnterOnMsg = '{���/�����} ��� {�����} ��  {������} �� ��������� {���� dobj/�������}. '

    /* cannot switch object */
    cannotSwitchMsg = '{���/�����} ��� {�����} ��  {������} {��� dobj/�����}. '

    /* cannot flip object */
    cannotFlipMsg = '{���/�����} ��� {�����} ��  �������{������} {��� dobj/�����}. '

    /* cannot turn object on/off */
    cannotTurnOnMsg =
        '{� dobj/�����} ��� {�����} ���� ��� {���/�����} {�����} ��  {����������}. '
    cannotTurnOffMsg =
        '{� dobj/�����} ��� {�����} ���� ��� {���/�����} {�����} ��  ��{����������}. '

    /* cannot light */
    cannotLightMsg = '{���/�����} ��� {�����} ��  {������} {��� dobj/�����}. '

    /* cannot burn */
    cannotBurnMsg = '{� dobj/�����} ��� {�����} ���� ��� {���/�����} {�����} ��  {����}. '
    cannotBurnWithMsg =
        '{���/�����} ��� {�����} ��  {����} ������ �� {��� iobj/�����}. '

    /* cannot burn this specific direct object with this specific iobj */
    cannotBurnDobjWithMsg = '{���/�����} ��� {�����} ��  {�����} {��� dobj/�����}
                          �� {��� iobj/�����}. '

    /* object is already burning */
    alreadyBurningMsg = '{� dobj/�����} ��� {�����}. '

    /* cannot extinguish */
    cannotExtinguishMsg = '{���/�����} ��� {�����} ��  {�����} {��� dobj/�����}. '

    /* cannot pour/pour in/pour on */
    cannotPourMsg = '{� dobj/�����} ��� {�����} ���� ��� {���/�����} {�����} ��  {����}. '
    cannotPourIntoMsg =
        '{���/�����} ��� {�����} ��  {����} ������ ���� {���� iobj/�������}. '
    cannotPourOntoMsg =
        '{���/�����} ��� {�����} ��  {����} ������ ���� {���� iobj/�������}. '

    /* cannot attach object to object */
    cannotAttachMsg =
        '{���/�����} ��� {�����} ��  {������} {��� dobj/�����} �� ������. '
    cannotAttachToMsg =
        '{���/�����} ��� {�����} ��  {������} ������ {���� iobj/�������}. '

    /* cannot attach to self */
    cannotAttachToSelfMsg =
        '{���/�����} ��� {�����} ��  {������} {��� dobj/�����} ���� ����� {���/���/���}. '

    /* cannot attach because we're already attached to the given object */
    alreadyAttachedMsg =
        '{� dobj/�����} {�����} ��� �������{-�����-����-����} �� {��� iobj/�����}. '

    /*
     *   dobj and/or iobj can be attached to certain things, but not to
     *   each other 
     */
    wrongAttachmentMsg =
        '{���/�����} ��� {�����} ��  {������} {��� dobj/�����} �� {��� iobj/�����}. '

    /* dobj and iobj are attached, but they can't be taken apart */
    wrongDetachmentMsg =
        '{���/�����} ��� {�����} ��  {������} {��� dobj/�����} ��� {��� iobj/�����}. '

    /* must detach the object before proceeding */
    mustDetachMsg(obj)
    {
        gMessageParams(obj);
        return '{���/�����} ������ ��  {������} {��� obj/�����} ���� {� actor/�����}
            �������� �� �� ����� ����. ';
    }

    /* default message for successful Attachable attachment */
    okayAttachToMsg = '�����. '

    /* default message for successful Attachable detachment */
    okayDetachFromMsg = '�����. '

    /* cannot detach object from object */
    cannotDetachMsg = '{���/�����} ��� {�����} ��  {������} {��� dobj/�����}. <<withTensePresent>> '
    cannotDetachFromMsg =
        '{���/�����} ��� {�����} ��  {������} ������ ��� {��� iobj/�����}. <<withTensePresent>> '

    /* no obvious way to detach a permanent attachment */
    cannotDetachPermanentMsg =
        '��� �������� �� ������� ������ �� ���������� {� dobj/�����}. '

    /* dobj isn't attached to iobj */
    notAttachedToMsg = '{� dobj/�����} ��� {�����} �������{-�����-����-����} {���� iobj/�������}. '

    /* breaking object would serve no purpose */
    shouldNotBreakMsg =
        '�� ������� {��� dobj/�����} ��� �� �������� �� ������. '

    /* cannot cut that */
    cutNoEffectMsg = '{� iobj/�����} ��� {����} {��� dobj/�����}. '

    /* can't use iobj to cut anything */
    cannotCutWithMsg = '{���/�����} ��� {�����} ��  {����} �� ��������� �� {��� iobj/�����}. <<withTensePresent>> '

    /* cannot climb object */
    cannotClimbMsg =
        '{� dobj/�����} ��� <<withTensePresent>>{�����} ���� ��� {���/�����} <<withTensePresent>>{�����} ��  {����������}. '

    /* object is not openable/closable */
    cannotOpenMsg = cannot1+cannot2//'{� dobj/�����} ��� {�����} ���� ��� {���/�����} <<withTensePresent>>{�����}' + ' �� {������}. '
	cannot1= '{� dobj/�����} ��� {�����} ���� ��� {���/�����} <<withTensePresent>>{�����}'
	cannot2= ' �� {������}.  '
    cannotCloseMsg =
        '{� dobj/�����} ��� {�����} ���� ��� {���/�����} {�����} ��  {������}.<<withTensePresent>> '

    /* already open/closed */
    alreadyOpenMsg = '{� dobj/�����} {�����} ��� ������{-��-�-�}. '
    alreadyClosedMsg = '{� dobj/�����} {�����} ��� ������{-��-�-�}. '

    /* already locked/unlocked */
    alreadyLockedMsg = '{� dobj/�����} {�����} ��� ������{-�����-����-����}. '
    alreadyUnlockedMsg = '{� dobj/�����} {�����} ��� ���������{-��-�-�}. '

    /* cannot look in container because it's closed */
    cannotLookInClosedMsg = '{� dobj/�����} {�����} ������{-��-�-�}. '

    /* object is not lockable/unlockable */
    cannotLockMsg =
        '{� dobj/�����} ��� {�����} ���� ��� {���/�����} {�����} ��  {��������}.<<withTensePresent>> '
    cannotUnlockMsg =
        '{� dobj/�����} ��� {�����} ���� ��� {���/�����} {�����} ��  ��{��������}.<<withTensePresent>> '

    /* attempting to open a locked object */
    cannotOpenLockedMsg = '{� dobj/�����} {�����} ���������{-��-�-�}. '

    /* object requires a key to unlock */

    unlockRequiresKeyMsg =
        '{���/�����} {����������} ��� ������ ��� ��  ��{��������} {��� dobj/�����}.<<withTensePresent>> '

    /* object is not a key */
    cannotLockWithMsg =
        '{� iobj/�����} ��� {��������} ��������{-��-�-�} ��� �� ��������� ���� ������. '
    cannotUnlockWithMsg =
        '{� iobj/�����} ��� {��������} ��������{-��-�-�} ��� �� ����������� ���� ������. '

    /* we don't know how to lock/unlock this */
    unknownHowToLockMsg =
        '�� ����� �������� ��� ������ �� ��������� {� dobj/�����}. '
    unknownHowToUnlockMsg =
        '�� ����� �������� ��� ������ �� ����������� {� dobj/�����}. '

    /* the key (iobj) does not fit the lock (dobj) */
    keyDoesNotFitLockMsg = '{� iobj/�����} ��� {��������} ���� ���������. '

    /* found key on keyring */
    foundKeyOnKeyringMsg(ring, key)
    {
        gMessageParams(ring, key);
        return '{���/�����} {��������} ���� ������ ��� {��� ring/�����} ���
            {������} ��� {��� key/�����} ��������� ���� ���������. ';
    }

    /* failed to find a key on keyring */
    foundNoKeyOnKeyringMsg(ring)
    {
        gMessageParams(ring);
        return '{���/�����} {��������} ���� ������ ��� {��� ring/�����},
            ���� {���/�����} ��� {�����} ��  {������} ������ ��� �� ��������� ���� ���������.<<withTensePresent>> ';
    }

    /* not edible/drinkable */
    cannotEatMsg = '{� dobj/�����} ��� {��������} ��� ���� ��� ������ �� �������. '
    cannotDrinkMsg = '{� dobj/�����} ��� {��������} �� ����� ���� ��� {���/�����} {�����} ��  {����}.<<withTensePresent>> '

    /* cannot clean object */
    cannotCleanMsg =
        '{���/�����} ��� {����} ��� ��  {��������} {��� dobj/�����}<<withTensePresent>>. '
    cannotCleanWithMsg =
        '{���/�����} ��� {�����} ��  {��������} ���� �� {��� iobj/�����}.<<withTensePresent>> '

    /* cannot attach key (dobj) to (iobj) */
    cannotAttachKeyToMsg =
        '{���/�����} ��� {�����} ��  {������} {��� dobj/�����} �� {��� iobj/�����}.<<withTensePresent>> '

    /* actor cannot sleep */
    cannotSleepMsg = '{���/�����} ��� {����������} ���� ���� �� ������. '

    /* cannot sit/lie/stand/get on/get out of */
    cannotSitOnMsg =
        '{� dobj/�����} ��� {�����} ���� ���� ��� ����� {���/�����} {�����} ��  {�������}.<<withTensePresent>> '
    cannotLieOnMsg =
        '{� dobj/�����} ��� {�����} ���� ���� ��� ����� {���/�����} {�����} ��  {�������}.<<withTensePresent>> '
    cannotStandOnMsg = '{���/�����} ��� {�����} ��  {��������} ���� {���� dobj/�������}.<<withTensePresent>> '
    cannotBoardMsg = '{���/�����} ��� {�����} ��  {������������} {���� dobj/�������}.<<withTensePresent>> '
    cannotUnboardMsg = '{���/�����} ��� {�����} ��  {������} ��� {��� dobj/�����}.<<withTensePresent>> '
    cannotGetOffOfMsg = '{���/�����} ��� {�����} ��  {���������} ��� {��� dobj/�����}.<<withTensePresent>> '

    /* standing on a PathPassage */
    cannotStandOnPathMsg = '�� {���/�����} {����} ��  {��������} {��� dobj/�����}, ������ ���� �� �� {���}.<<withTensePresent>> '

    /* cannot sit/lie/stand on something being held */
    cannotEnterHeldMsg =
        '{���/�����} ��� {�����}  ��  {����} ���� ������ ��� <<withTensePresent>>{������} {��� dobj/�����}. '

    /* cannot get out (of current location) */
    cannotGetOutMsg = '{���/�����} ��� {�����} ���� �� ���� ��� �� ����� ��  {�����} �� {������������}.<<withTensePresent>> '

    /* actor is already in a location */
    alreadyInLocMsg = '{���/�����} {�����} ��� {���� dobj}. '

    /* actor is already standing/sitting on/lying on */
    alreadyStandingMsg = '{���/�����} ��� {��������}. '
    alreadyStandingOnMsg = '{���/�����} ��� {��������} {���� dobj}. '
    alreadySittingMsg = '{���/�����} ��� {�������}. '
    alreadySittingOnMsg = '{���/�����} ��� {�������} {���� dobj}. '
    alreadyLyingMsg = '{���/�����} {���} ��� �������� ����. '
    alreadyLyingOnMsg = '{���/�����} {���} ��� �������� {���� dobj}. '

    /* getting off something you're not on */
    notOnPlatformMsg = '{���/�����} ��� {�����} {���� dobj}. '

    /* no room to stand/sit/lie on dobj */
    noRoomToStandMsg =
        '��� {�������| ������} ����� ���� {���/�����}  ��  {��������} {���� dobj}.<<withTensePresent>> '
    noRoomToSitMsg =
        '��� {�������| ������} ����� ���� {���/�����}  ��  {�������} {���� dobj}.<<withTensePresent>> '
    noRoomToLieMsg =
        '��� {�������| ������} ����� ���� {���/�����}  ��  {�������} {���� dobj}.<<withTensePresent>> '

    /* default report for standing up/sitting down/lying down */
    okayPostureChangeMsg(posture)
        { return '�������, ���� ' + posture.participle + '. '; }

    /* default report for standing/sitting/lying in/on something */
    roomOkayPostureChangeMsg(posture, obj)
    {
        gMessageParams(obj);
        return '�������, ���� ' + posture.participle + ' {���� obj}. ';
    }

    /* default report for getting off of a platform */
    okayNotStandingOnMsg = '�������, ��� {�����} ��� ���� {���� dobj}. '

    /* cannot fasten/unfasten */
    cannotFastenMsg = '{���/�����} ��� {�����}  ��  {����} {��� dobj/�����}. '
    cannotFastenToMsg =
        '{���/�����} ��� {�����}  ��  {����} ������ {���� iobj/�������}.<<withTensePresent>> '
    cannotUnfastenMsg = '{���/�����} ��� {�����}  ��  {����} {��� dobj/�����}.<<withTensePresent>> '
    cannotUnfastenFromMsg =
        '{���/�����} ��� {�����} ��  {����} ������ ��� {��� iobj/�����}.<<withTensePresent>> '

    /* cannot plug/unplug */
    cannotPlugInMsg = '{���/�����} ��� {�����} ������� ����� ��� ��  {������} {��� dobj/�����}.<<withTensePresent>> '
    cannotPlugInToMsg =
        '{���/�����} ��� {�����} ������� ����� ��  {������} �� ��������� ���� {���� iobj/�������}.<<withTensePresent>> '
    cannotUnplugMsg = '{���/�����} ��� {�����} ������� ����� ���� ��  ���{������} {��� dobj/�����}.<<withTensePresent>> '
    cannotUnplugFromMsg =
        '{���/�����} ��� {�����} ��  ���{������} ���� ��� {��� iobj/�����}.<<withTensePresent>> '

    /* cannot screw/unscrew */
    cannotScrewMsg = '{���/�����} ��� {�����} ������� ����� ��  {������} {��� dobj/�����}.<<withTensePresent>> '
    cannotScrewWithMsg =
        '{���/�����} ��� {�����} ��  {������} ���� �� {��� iobj/�����}.<<withTensePresent>> '
    cannotUnscrewMsg = '{���/�����} ��� {�����} ������� ����� ��� ��  ��{������} {��� dobj/�����}. '
    cannotUnscrewWithMsg =
        '{���/�����} ��� {�����} ��  ��{������} �� ��������� �� {��� iobj/�����}.<<withTensePresent>> '

    /* cannot enter/go through */
    cannotEnterMsg =
        '{�������/������ dobj} ��� {�����} ���� ��� ����� {���/�����} {�����} ��  {����������}.<<withTensePresent>> '
    cannotGoThroughMsg =
        '{�������/������ dobj} ��� {�����} ���� ���� ��� �� ����� {���/�����} {�����} ��  {������}.<<withTensePresent>> '
        
    /* can't throw something at itself */
    cannotThrowAtSelfMsg =
        '{���/�����} ��� {�����} ��  {�����} {������� dobj/������} ���� ����� {���/���/���}.<<withTensePresent>> '

    /* can't throw something at an object inside itself */
    cannotThrowAtContentsMsg = '{���/�����} ������ ����� ��  {������} {��� iobj/�����}
        ��� {��� dobj/�����} ������ {����� actor} {����} ���� ������.<<withTensePresent>> '

    /* can't throw through a sense connector */
    cannotThrowThroughMsg(target, loc)
    {
        gMessageParams(target, loc);
        return '{���/�����} ��� {�����} ��  {�����} ������ ���� ��� {��� loc/�����}. ';
    }

    /* shouldn't throw something at the floor */
    shouldNotThrowAtFloorMsg =
        '{���/�����} �� {������|������} ���� �� { [��������]|<<withTenseYpers>>[��������]} {�� dobj/����} ����.<<withTensePresent>> '

    /* THROW <obj> <direction> isn't supported; use THROW AT instead */
    dontThrowDirMsg =
        ('<.parser>������ �� ������ ��� ����� �� �� ������ ' + (gActor.referralPerson == ThirdPerson
                      ? ' {� actor/�����}' : '')
         + ' ��  {�����} {��� dobj/�����}.<./parser> ')

    /* thrown object bounces off target (short report) */
    throwHitMsg(projectile, target)
    {
        gMessageParams(projectile, target);
        return '{� projectile/�����} {�����|�������} {��� target/�����} ����� ������ ������� ����������. ';
    }

    /* thrown object lands on target */
    throwFallMsg(projectile, target)
    {
        gMessageParams(projectile, target);
        return '{� projectile/�����} {�������������|������������} ���� {���� target/�������}. ';
    }

    /* thrown object bounces off target and falls to destination */
    throwHitFallMsg(projectile, target, dest)
    {
        gMessageParams(projectile, target);
        return '{� projectile/�����} {�����|�������} {��� target/�����}
            ����� ������ ������� ����������, ��� {� projectile/�����} {������|�����} '
            + dest.putInName + '. ';
    }

    /* thrown object falls short of distant target (sentence prefix only) */
    throwShortMsg(projectile, target)
    {
        gMessageParams(projectile, target);
        return '{� projectile/�����} {������|�����} ������ ��� '
               + '{��� target/�����}. ';
    }
        
    /* thrown object falls short of distant target */
    throwFallShortMsg(projectile, target, dest)
    {
        gMessageParams(projectile, target);
        return '{� projectile/�����} {������|�����} ' + dest.putInName
            + ' ������ ��� {��� target/�����}. ';
    }

    /* target catches object */
    throwCatchMsg(obj, target)
    {
        return '\^' + target.oName + ' '
            + tSel('������', '������')
            + ' ' + obj.tonNameObj + '. ';
    }

    /* we're not a suitable target for THROW TO (because we're not an NPC) */
    cannotThrowToMsg = '{���/�����} ��� {�����} �� {�����} �� ��������� {���� iobj/�������}. '

    /* target does not want to catch anything */
    willNotCatchMsg(catcher)
    {
        return '\^' + '��� �������� ' + catcher.oName + ' �� ����� �� ������ �� ���������. ';
    }

    /* cannot kiss something */
    cannotKissMsg = '�� �� �� {�����} {��� dobj/�����} ��� {���������} ����. '

    /* person uninterested in being kissed */
    cannotKissActorMsg
        = '���������� �� ��� ����� ���� ������ {���� dobj/�������}. '

    /* cannot kiss yourself */
    cannotKissSelfMsg = '{���/�����} ��� {�����} ��  {�����} ��� ����� {���/���/���}.<<withTensePresent>> '

    /* it is now dark at actor's location */
    newlyDarkMsg = '{���������|�����������} ����� �� ������� �������. '
;

/*
 *   Non-player character verb messages.  By default, we inherit all of
 *   the messages defined for the player character, but we override some
 *   that must be rephrased slightly to make sense for NPC's.
 */
npcActionMessages: playerActionMessages
    /* "wait" */
    timePassesMsg = '{���/�����} {[��������]|<<withTenseAoristos>>[��������]}<<withTensePresent>>... '

    /* trying to move a Fixture/Immovable */
    cannotMoveFixtureMsg = '{���/�����} ��� {�����} ��  {��������} {��� dobj/�����}. '
    cannotMoveImmovableMsg = '��� {�����} ��  {��������} {��� dobj/�����}. '

    /* trying to take/move/put a Heavy object */
    cannotTakeHeavyMsg =
        '{That dobj/he} {�����} ���� ���{-��-��-�} ��� ��   {�����} �� �� {��������}.<<withTensePresent>> '
    cannotMoveHeavyMsg =
        '{That dobj/he} {�����} ���� ���{-��-��-�} ��� ��   {�����} �� �� {��������}.<<withTensePresent>> '
    cannotPutHeavyMsg =
        '{That dobj/he} {�����} ���� ���{-��-��-�} ��� ��   {�����} �� �� {��������}.<<withTensePresent>> '

    /* trying to move a component object */
    cannotMoveComponentMsg(loc)
    {
        return '{���/�����} ��� {�����} �� ��  {����} ����, ����� {� dobj/�����} <<withTensePresent>>{�����} ����� ' + loc.touNameObj + '. ';
    }

    /* default successful 'take' response */
    okayTakeMsg = '{���/�����} {[������]|<<withTenseAoristos>>[������]} {��� dobj/�����}.<<withTensePresent>> '

    /* default successful 'drop' response */
    okayDropMsg = '{���/�����} {�����} {��� dobj/�����} ����. '

    /* default successful 'put in' response */
    okayPutInMsg = '{���/�����} {����} {��� dobj/�����} ���� {���� iobj/�������}. '

    /* default successful 'put on' response */
    okayPutOnMsg = '{���/�����} {����} {��� dobj/�����} ���� {���� iobj/�������}. '

    /* default successful 'put under' response */
    okayPutUnderMsg =
        '{���/�����} {����} {��� dobj/�����} ���� ��� {��� iobj/�����}. '

    /* default successful 'put behind' response */
    okayPutBehindMsg =
        '{���/�����} {����} {��� dobj/�����} ���� ��� {��� iobj/�����}. '

    /* default succesful response to 'wear obj' */
    okayWearMsg =
        '{���/�����} {�����} {��� dobj/�����}. '

    /* default successful response to 'doff obj' */
    okayDoffMsg = '{���/�����} {�����} {��� dobj/�����}. '

    /* default successful responses to open/close */
    okayOpenMsg = '{���/�����} {[������]|<<withTenseAoristos>>[������]} {��� dobj/�����}.<<withTensePresent>> '
    okayCloseMsg = '{���/�����} {[������]|<<withTenseAoristos>>[������]} {��� dobj/�����}.<<withTensePresent>> '

    /* default successful responses to lock/unlock */
    okayLockMsg = '{���/�����} {[��������] | <<withTenseAoristos>>[��������]} {��� dobj/�����}.<<withTensePresent>> '
    okayUnlockMsg = '{���/�����} ��{[��������] | <<withTenseAoristos>>[��������]} {��� dobj/�����}.<<withTensePresent>> '

    /* push/pull/move with no effect */
    pushNoEffectMsg = '{���/�����} {[��������]|<<withTenseAoristos>>[��������]} ��   {�������} {��� dobj/�����}, �� ������ '
                      + '������� ����������.<<withTensePresent>>. '
    pullNoEffectMsg = '{���/�����} {[��������]|<<withTenseAoristos>>[��������]} ��   {������} {��� dobj/�����}, �� ������ '
                      + '������� ����������.<<withTensePresent>> '
    moveNoEffectMsg = '{���/�����} {[��������]|<<withTenseAoristos>>[��������]} ��   {��������} {��� dobj/�����}, �� ������ '
                      + '������� ����������.<<withTensePresent>> '
    moveToNoEffectMsg = '{���/�����} {�����} {��� dobj/�����} ���� ���� ��� {�����|����}. '

    whereToGoMsg =
        '�� ������ �� ��������� ���� �� ���� ���������� {���/�����} �� {������|������} �� { [�������]|<<withTenseYpers>>[�������]}.<<withTensePresent>> '

    /* object is too large for container */
    tooLargeForContainerMsg(obj, cont)
    {
        gMessageParams(obj, cont);
        return '{���/�����} ��� {�����} �� ��  {����} ����, ����� {� obj/�����} <<withTensePresent>>{�����}
            ���� �����{-��-�-�} ��� {��� cont/�����}.<<withTensePresent>> ';
    }

    /* object is too large for underside */
    tooLargeForUndersideMsg(obj, cont)
    {
        gMessageParams(obj, cont);
        return '{���/�����} ��� {�����} �� ��  {����} ����, ����� {� obj/�����}
            ��� <<withTenseStigFuture>>{�����} ���� ��� {��� cont/�����}.<<withTensePresent>> ';
    }

    /* object is too large to fit behind something */
    tooLargeForRearMsg(obj, cont)
    {
        gMessageParams(obj, cont);
        return '{���/�����} ��� {�����} �� ��  {����} ����, ����� {� obj/�����}
            ��� <<withTenseStigFuture>>{�����} ���� ��� {��� cont/�����}.<<withTensePresent>> ';
    }

    /* container doesn't have room for object */
    containerTooFullMsg(obj, cont)
    {
        gMessageParams(obj, cont);
        return '{���/�����} ��� {�����} �� ��  {����} ����, ����� {� cont/�����} <<withTensePresent>>{�����}
            ��� ��������{-��-��-��} ��� ��  {�����} {��� obj/�����}.<<withTensePresent>> ';
    }

    /* surface doesn't have room for object */
    surfaceTooFullMsg(obj, cont)
    {
        gMessageParams(obj, cont);
        return '{���/�����} ��� {�����} �� ��  {����} ����, ����� ��� {�������| ������}
            ����� ��� {��� obj/�����} ���� {���� cont/�������}.<<withTensePresent>> ';
    }

    /* the dobj doesn't fit on this keyring */
    objNotForKeyringMsg = '{���/�����} ��� {�����} �� ��  {����} ����, ����� {that dobj/he}
        ��� <<withTensePresent>>{�����} {���� iobj/�������}.<<withTensePresent>> '

    /* taking dobj from iobj, but dobj isn't in iobj */
    takeFromNotInMsg = '{���/�����} ��� {�����} �� ��  {����} ����, �����
        {� dobj/�����}  ��� <<withTensePresent>>{�����} ���� {���� iobj/�������}.<<withTensePresent>> '

    /* taking dobj from surface, but dobj isn't on iobj */
    takeFromNotOnMsg = '{���/�����} ��� {�����} �� ��  {����} ����, �����
        {� dobj/�����}  ��� <<withTensePresent>>{�����} ���� {���� iobj/�������}.<<withTensePresent>> '

    /* taking dobj under something, but dobj isn't under iobj */
    takeFromNotUnderMsg = '{���/�����} ��� {�����} �� ��  {����} ����, �����
        {� dobj/�����}  ��� <<withTensePresent>>{�����} ���� ��� {��� iobj/�����}.<<withTensePresent>> '

    /* taking dobj from behind something, but dobj isn't behind iobj */
    takeFromNotBehindMsg = '{���/�����} ��� {�����} �� ��  {����} ����, �����
        {� dobj/�����} ��� <<withTensePresent>>{�����} ���� ��� {��� iobj/�����}.<<withTensePresent>> '

    /* cannot jump off (with no direct object) from here */
    cannotJumpOffHereMsg = '��� {�������|������} ������ ����� ��� ����� �� {�����} ��  {�����}.<<withTensePresent>> '

    /* should not break object */
    shouldNotBreakMsg = '{���/�����} ��� {����} ��  {����} {��� dobj/�����}.<<withTensePresent>> '

    /* report for standing up/sitting down/lying down */
    okayPostureChangeMsg(posture)
        { return '{���/�����} ' + posture.msgVerbI + '. '; }

    /* report for standing/sitting/lying in/on something */
    roomOkayPostureChangeMsg(posture, obj)
    {
        gMessageParams(obj);
        return '{���/�����} ' + posture.msgVerbT + ' {on obj}. ';
    }

    /* report for getting off a platform */
    okayNotStandingOnMsg = '{���/�����} {[���������]|<<withTenseAoristos>>[���������]} {offof dobj}.<<withTensePresent>> '

    /* default 'turn to' acknowledgment */
    okayTurnToMsg(val)
        { return '{���/�����} {������} {��� dobj/�����} ���� ' + val + '. '; }

    /* default 'push button' acknowledgment */
    okayPushButtonMsg = '{���/�����} {�����} {��� dobj/�����}. '

    /* default acknowledgment for switching on/off */
    okayTurnOnMsg = '{���/�����} {����������} {��� dobj/�����}. '
    okayTurnOffMsg = '{���/�����} ��{����������} {��� dobj/�����}. '

    /* the key (iobj) does not fit the lock (dobj) */
    keyDoesNotFitLockMsg = '{���/�����} {��������} �� {the iobj/he}, ����
                         {it iobj/he} ��� {�����} ���� ���������. '

    /* acknowledge entering "follow" mode */
    okayFollowModeMsg = '<q>�������, �� ���������� {��� dobj/�����}.</q> '

    /* note that we're already in "follow" mode */
    alreadyFollowModeMsg = '<q>�������� ��� {��� dobj/�����}.</q> '

    /* extinguishing a candle */
    okayExtinguishCandleMsg = '{���/�����} {�����} {��� dobj/�����}. '

    /* acknowledge attachment */
    okayAttachToMsg =
        '{���/�����} {������} {��� dobj/�����} {��� iobj/�������}. '

    /* acknowledge detachment */
    okayDetachFromMsg =
        '{���/�����} ���{������} {��� dobj/�����} ��� {��� iobj/�����}. '

    /*
     *   the PC's responses to conversational actions applied to oneself
     *   need some reworking for NPC's 
     */
    cannotTalkToSelfMsg = '{���/�����} ��� <<withTenseStigFuture>>{���������} ���� �� �� ��  {�����}
	���� ����� {���/���/���}.<<withTensePresent>> '
    cannotAskSelfMsg = '���/�����} ��� <<withTenseStigFuture>>{���������} ���� �� �� ��  {�����}
	���� ����� {���/���/���}.<<withTensePresent>> '
    cannotAskSelfForMsg = '���/�����} ��� <<withTenseStigFuture>>{���������} ���� �� �� ��  {�����}
	���� ����� {���/���/���}.<<withTensePresent>> '
    cannotTellSelfMsg = '���/�����} ��� <<withTenseStigFuture>>{���������} ���� �� �� ��  {�����}
	���� ����� {���/���/���}.<<withTensePresent>> '
    cannotGiveToSelfMsg = '���/�����} ��� <<withTenseStigFuture>>{���������} ���� �� �� ��  {����}
	{��� dobj/�����} ���� ����� {���/���/���}.<<withTensePresent>> '
    cannotShowToSelfMsg = '{���/�����} ��� <<withTenseStigFuture>>{���������} ���� �� �� ��  
       ������ {��� dobj/�����} ���� ����� {���/���/���}.<<withTensePresent>> '
;

/* ------------------------------------------------------------------------ */
/*
 *   Standard tips
 */

scoreChangeTip: Tip
    "�� �� ������������ �� ��� ������������ ��� ��� ������� ��� ���� ��� ������,
	�������������� <<aHref('��������� �����������', '��������� �����������', '�������������� ����������� ��� �� ����')>>."
;

footnotesTip: Tip
    "���� ������� �� [�������], ���� ����� ��������, ���������� �� ��� �����������,
    ��� ����� �������� �� ��������� ��������������� ����������� ������������� ��� ��� ������. ��� ����������:
    <<aHref('����������� 1', '����������� 1', '����� ����������� [1]')>>.
    �� ������������� ������� ��������� ������������ ����������� ��� ���� �� ������ �������������
    ���� ��� ����� ����������� ��� ��� �������. �� �� ������������ �� ��� ������� ������� �������������,
	�������� �� �������� ��� �������� ���� ��������������� <<aHref('�������������', '�������������', '������� ��������� �������������')>>."
;

oopsTip: Tip
    "�� ���� ���� ��� ������� ����������� �����, �������� �� �� ���������� ��������������� ���� 
	������������� ��� �� ���������� ����. 
	���� ���� ��� � ������� ����������� ��� ������� ����, 
	�������� �� ���������� ��� ����������� ����� ��������������� �� ���� 
	�� ��� ������� ������ ���."
;

fullScoreTip: Tip
    "��� �������� ����������� ���������� ��� ����, ��������������
    <<aHref('������ ����', '������ ����')>>."
;

exitsTip: Tip
    "�������� �� �������� ��� ������ �� ��� ������� �� ��� ������ ������.
    <<aHref('��������� ������', '��������� ������',
            '������������ ��� ������ ���������� ������')>>
    ������� �� ����� ������ ��� ������ ����������,
    <<aHref('��������� ������', '��������� ������', '��������� ��� ������ ���� ���������� ��������')>>
    ������� ��� ����� ����� ������ �� ���� ��������� ��������,
    <<aHref('������ �������', '������ �������', '������������ ���� ��� ������ ������')>>
    ������� ��� �� ���, ���
    <<aHref('������ ���������', '������ ���������', '�������������� ���� ��� ������ ������')>>
    ������������� ��� �� ��� ���� ������ ������."
;

undoTip: Tip
    "�� � ������� ��� ��� ������� �� ���� ��� ���������, �� ��������� ��� ������� ����� �� ��� ��� ������ ���� ��������������� <<aHref('��������', '��������',
        '�������� ��� ��� ��������� �������')>>. ������� ����� �� �� ������ ������������� ��� �� ���������� ������ ���������� �������� ���. "
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
    showListPrefixWide(itemCount, pov, parent) { "{���/�����} {�����}<<withListCaseAccusative>><<withListArtIndefinite>> "; }
    showListSuffixWide(itemCount, pov, parent) { " ���. "; }

    /* show the tall prefix */
    showListPrefixTall(itemCount, pov, parent) { "{E��/�����} {�����}:<<withListCaseAccusative>><<withListArtIndefinite>>"; }
;

/*
 *   The basic room lister for dark rooms 
 */
darkRoomLister: Lister
    showListPrefixWide(itemCount, pov, parent)
        { "���� ��� ������� {���/�����} {�����}<<withListCaseAccusative>><<withListArtIndefinite>> "; }

    showListSuffixWide(itemCount, pov, parent) { ". "; }

    showListPrefixTall(itemCount, pov, parent)
        { "���� ��� ������� {���/�����} {�����}:<<withListCaseAccusative>><<withListArtIndefinite>>"; }
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
        { "\^<<remoteRoom.inRoomName(pov)>>, {���/�����} {�����}<<withListCaseAccusative>><<withListArtIndefinite>> "; }
    showListSuffixWide(itemCount, pov, parent)
        { ". "; }

    showListPrefixTall(itemCount, pov, parent)
        { "\^<<remoteRoom.inRoomName(pov)>>, {���/�����} {�����}:<<withListCaseAccusative>><<withListArtIndefinite>>"; }

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
        { "<<buildSynthParam('���/�����', parent)>> {��������}<<withListCaseAccusative>><<withListArtIndefinite>> "; }
    showListSuffixWide(itemCount, pov, parent)
        { ". "; }

    showListPrefixTall(itemCount, pov, parent)
        { "<<buildSynthParam('���/�����', parent)>> {��������}<<withListCaseAccusative>><<withListArtIndefinite>>:"; }
    showListContentsPrefixTall(itemCount, pov, parent)
        { "<<buildSynthParam('���/�����', parent)>>, ��� {��������}<<withListCaseAccusative>><<withListArtIndefinite>>:"; }

    showListEmpty(pov, parent)
        { "<<buildSynthParam('���/�����', parent)>> {���} ����� �����. "; }
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
//###I replaced the english semicolon ; with the greek semicolon �
    phraseSepPat = static new RexPattern(',(?! ��� )|�| ��� |<rparen>')

    /*
     *   Once we've made up our mind about the format, we'll call one of
     *   these methods to show the final sentence.  These are all separate
     *   methods so that the individual formats can be easily tweaked
     *   without overriding the whole combined-inventory-listing method. 
     */
    showInventoryEmpty(parent)
    {
        /* empty inventory */
        "<<buildSynthParam('���/�����', parent)>> {���} ����� �����. ";
    }
    showInventoryWearingOnly(parent, wearing)
    {
        /* we're carrying nothing but wearing some items */
        "<<buildSynthParam('���/�����', parent)>> ��� {��������} ������,
        ��� {�����} <<wearing>>. ";
    }
    showInventoryCarryingOnly(parent, carrying)
    {
        /* we have only carried items to report */
        "<<buildSynthParam('���/�����', parent)>> {��������} <<carrying>>. ";
    }
    showInventoryShortLists(parent, carrying, wearing)
    {
        local nm = gSynthMessageParam(parent);
        
        /* short lists - combine carried and worn in a single sentence */
        "<<buildParam('���/�����', nm)>> {��������} <<carrying>>,
        ��� {�����} <<wearing>>. ";
    }
    showInventoryLongLists(parent, carrying, wearing)
    {
        local nm = gSynthMessageParam(parent);

        /* long lists - show carried and worn in separate sentences */
        "<<buildParam('���/�����', nm)>> {��������} <<carrying>>.
        <<buildParam('���/�����', nm)>> {�����} <<wearing>>. ";
    }

    /*
     *   For 'tall' listings, we'll use the standard listing style, so we
     *   need to provide the framing messages for the tall-mode listing.  
     */
    showListPrefixTall(itemCount, pov, parent)
        { "<<buildSynthParam('���/�����', parent)>> {��������} :"; }
    showListContentsPrefixTall(itemCount, pov, parent)
        { "<<buildSynthParam('����/�����', parent)>>, ��� {��������}:"; }
    showListEmpty(pov, parent)
        { "<<buildSynthParam('���/�����', parent)>> {���} ����� �����. "; }
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
        "<.p><<buildSynthParam('���/�����', parent)>> {�����} <<wearing>>. ";
    }
    showInventoryCarryingOnly(parent, carrying)
    {
        /* we have only carried items to report */
        "<.p><<buildSynthParam('���/�����', parent)>> {��������} <<carrying>>. ";
    }
    showInventoryShortLists(parent, carrying, wearing)
    {
        local nm = gSynthMessageParam(parent);

        /* short lists - combine carried and worn in a single sentence */
        "<.p><<buildParam('���/�����', nm)>> {��������} <<carrying>>,
        ��� {�����} <<wearing>>. ";
    }
    showInventoryLongLists(parent, carrying, wearing)
    {
        local nm = gSynthMessageParam(parent);

        /* long lists - show carried and worn in separate sentences */
        "<.p><<buildParam('���/�����', nm)>> {��������} <<carrying>>.
        <<buildParam('���/�����', nm)>> {�����} <<wearing>>. ";
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
        "<<buildSynthParam('���/�����', parent)>> {�����} <<wearing>>. ";
    }
    showInventoryCarryingOnly(parent, carrying)
    {
        /* we have only carried items to report */
        "<<buildSynthParam('���/�����', parent)>> {��������} <<carrying>>. ";
    }
    showInventoryShortLists(parent, carrying, wearing)
    {
        local nm = gSynthMessageParam(parent);

        /* short lists - combine carried and worn in a single sentence */
        "<<buildParam('���/�����', nm)>> {��������} <<carrying>>, ��� {�����} <<wearing>>. ";
    }
    showInventoryLongLists(parent, carrying, wearing)
    {
        local nm = gSynthMessageParam(parent);

        /* long lists - show carried and worn in separate sentences */
        "<<buildParam('���/�����', nm)>> {��������} <<carrying>>.
        <<buildParam('���/�����', nm)>> {�����} <<wearing>>. ";
    }
;

/*
 *   Base contents lister for things.  This is used to display the contents
 *   of things shown in room and inventory listings; we subclass this for
 *   various purposes 
 */
class BaseThingContentsLister: Lister
    showListPrefixWide(itemCount, pov, parent)
        { "\^<<parent.oName>> {��������|��������}<<withListCaseAccusative>> "; }
    showListSuffixWide(itemCount, pov, parent)
        { ". "; }
    showListPrefixTall(itemCount, pov, parent)
        { "<<parent.oName>> {��������|��������}:<<withListCaseAccusative>>"; }
    showListContentsPrefixTall(itemCount, pov, parent)
        { "<<parent.enasName>>, ��� {��������|��������}:<<withListCaseNominative>>"; }
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
        { "\^<<parent.itOnom>> ��������<<withListCaseAccusative>><<withListArtIndefinite>> "; }
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
        "\^<<parent.openStatus>>,<<withListCaseAccusative>><<withListArtIndefinite>> ��� �������� ";
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
        defaultDescReport('{���/�����} ��� {�����} ������ ' + parent.objInPrep
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
        defaultDescReport('{���/�����} ��� {�����} ������ ���������� ���� <<parent.stonNameObj>>. ');
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
            "<<withListCaseGenitive>>�� ������� {��� parent/�����} ����������� <<withListCaseAccusative>><<withListArtIndefinite>>";
        else
            "{� pov/�����} ������� {��� parent/�����}, �������������� <<withListCaseAccusative>><<withListArtIndefinite>>";
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
        <<itemCount == 1 ? tSel('�����', '����') : tSel('�����', '����')>><<withListCaseNominative>><<withListArtIndefinite>> ";
    }
    showListSuffixWide(itemCount, pov, parent)
    {
        ".<<withListCaseAccusative>><<withListArtIndefinite>> ";
    }
    showListPrefixTall(itemCount, pov, parent)
    {
        "\^<<parent.objInPrep>> <<parent.stonNameObj>>
        <<itemCount == 1 ? tSel('�����', '����') : tSel('�����', '����')>>:<<withListCaseNominative>><<withListArtIndefinite>>";
    }
	//##We add the Suffix so we can return to the default case of the listcase (Accusative)
	showListSuffixTall(itemCount, pov, parent) 
    {
        "<<withListCaseAccusative>><<withListArtIndefinite>>";
    }
    showListContentsPrefixTall(itemCount, pov, parent)
    {
        "<<parent.enasName>>, <<parent.objInPrep>> {����} ����{-��-�-�} <<withListCaseNominative>><<withListArtIndefinite>>
        <<itemCount == 1 ? tSel('�����', '����') : tSel('�����', '����')>>:";
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
        { "� ���������� <<parent.touNameObj>> �����������<<withListCaseAccusative>><<withListArtIndefinite>> "; }
    showListSuffixWide(itemCount, pov, parent)
        { " ��� ����. "; }
    showListPrefixTall(itemCount, pov, parent)
        { "� ���������� <<parent.touNameObj>> �����������<<withListCaseAccusative>><<withListArtIndefinite>>:"; }
;
 
/* contents lister for an Underside, used in a long description */
undersideDescContentsLister: DescContentsLister, BaseUndersideContentsLister
    showListPrefixWide(itemCount, pov, parent)
    {
        "���� ��� <<parent.tonNameObj>>
        <<itemCount == 1 ? tSel('�����', '����')
                         : tSel('�����', '����')>><<withListCaseNominative>><<withListArtIndefinite>> ";
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
        { "� ���������� <<parent.touNameObj>> �����������<<withListCaseAccusative>><<withListArtIndefinite>> "; }
    showListSuffixWide(itemCount, pov, parent)
        { " ���� ��� <<parent.itObj>>. "; }
    showListPrefixTall(itemCount, pov, parent)
        { "� ���������� <<parent.touNameObj>> �����������:<<withListCaseAccusative>><<withListArtIndefinite>>"; }
;
 
/* long-description contents lister for a RearContainer/Surface */
rearDescContentsLister: DescContentsLister, BaseRearContentsLister
    showListPrefixWide(itemCount, pov, parent)
    {
        "���� ��� <<parent.tonNameObj>>
        <<itemCount == 1 ? tSel('�����', '����')
                         : tSel('�����', '����')>><<withListCaseNominative>> ";
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
        " (<<parent.objInPrep>> {����} ����{-��-�-�} <<
          cnt == 1 ? tSel('�����', '����') : tSel('�����', '����')>> <<withListCaseNominative>><<withListArtIndefinite>> ";
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
        { " (��� {��������|��������} <<withListCaseAccusative>><<withListArtIndefinite>>"; }
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
        { " (�� �������{-�����-����-����} <<withListCaseAccusative>><<withListArtIndefinite>> "; }
    showListSuffixWide(cnt, pov, parent)
        { " )"; }
;


/*
 *   Contents lister for "examine <keyring>" 
 */
keyringExamineContentsLister: DescContentsLister
    showListEmpty(pov, parent)
    {
	"\^<<parent.oName>> <<parent.verbEimai>> ����{-��-�-�}. ";
    }
    showListPrefixWide(cnt, pov, parent)
    {
        "<<parent.stonNameObj>>
        <<cnt == 1 ? tSel('�����', '����')
                   : tSel('�����', '����')>> �������{-�����-����-����} <<withListCaseNominative>><<withListArtIndefinite>>";
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
        { " (�������� "; }
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
        { "<.p>\^<<parent.oName>><<parent.verbEimai>> �������{-�����-����-����} �� <<withListCaseAccusative>><<withListArtIndefinite>>"; }
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
        " {�����|����} <<isHim ? '������������' : isHer ?  '�����������' : isHimPlural ? '������������' : isHerPlural ? '������������' : isItPlural ? '�����������' : '�����������'>>
         �� <<withListCaseAccusative>><<parent.tonNameObj>>.<<withListCaseAccusative>><<withListArtIndefinite>> ";
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
        "<.p>�� ������ �� ������ ";
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
                " � ";
            else
                ", � ";
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
            "� ���� ������� ������ {������|��������} ";
        else
            "�� �������� ������ {�������|���������} ";
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
                " ����";

            /* show the destination */
            " ���� <<obj.tonDestName_>>";
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
                ", ��� ";
            else
                " ��� ";
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
    showListPrefixWide(cnt, pov, parent) { " (� "; }
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
            " � ";
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
        "<.roompara><.parser>�������� ������: ";
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
        "��� {��������|�������} �������� ������. ";
    }
;

/*
 *   Show room exits in the status line (used in HTML mode only)
 */
statuslineExitLister: ExitLister
    showListEmpty(pov, parent)
    {
        "<<statusHTML(3)>><b>������:</b> <i>�����</i><<statusHTML(4)>>";
    }
    showListPrefixWide(cnt, pov, parent)
    {
        "<<statusHTML(3)>><b>������:</b> ";
    }
    showListSuffixWide(cnt, pov, parent)
    {
        "<<statusHTML(4)>>";
    }
    showListItem(obj, options, pov, infoTab)
    {
        "<<aHref(obj.dir_.name, obj.dir_.name, '�������� ' + obj.dir_.name,
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
                        curTxt += ' ��� ������ ' + addTxt;
                    else if (addTxt != '')
                        curTxt = addTxt;
                }
            }

            /* add a separator before this item if it isn't the first */
            if (txt != '' && curTxt != '')
                txt += ', ������ ';

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
        "<<isExplicit ? '' : '('>>{��� askingActor/�����} {�����} ";
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
            "<<isExplicit ? '' : '('>>{��� askingActor/�����} ��� {���} ������
            ������������ ��� ��� {���� �� ������|������ �� ������} �� ���� ��������� ��
            {��� targetActor/�����}.<<isExplicit ? '' : ')'>> ";
        }
    }

    showListSeparator(options, curItemNum, totalItems)
    {
        /* use "or" as the conjunction */
        if (curItemNum + 1 == totalItems)
            ", � ";
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
    groupPrefix = "���� {it targetActor/him} ��� "
;

/* TELL ABOUT suggestion list group */
suggestionTellGroup: SuggestionListGroup
    groupPrefix = "��� {it targetActor/him} ��� "
;

/* ASK FOR suggestion list group */
suggestionAskForGroup: SuggestionListGroup
    groupPrefix = "���� {it targetActor/him} ��� "
;

/* GIVE TO suggestions list group */
suggestionGiveGroup: SuggestionListGroup
    groupPrefix = "���� {it targetActor/him} "
;

/* SHOW TO suggestions */
suggestionShowGroup: SuggestionListGroup
    groupPrefix = "����� {it targetActor/him} "
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
            "��� ��� � ���";
        }
        else
        {
            /* inherit the default behavior */
            inherited(pov, lister, lst, options, indent, infoTab);
        }
    }
    groupPrefix = "���";
;
