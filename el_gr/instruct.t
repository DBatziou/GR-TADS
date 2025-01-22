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
        '���� ��� ���� ��� �� �����',
        '���� ��� ��� ���� ������',
        '��� ���� ���� ��� ��� ���������� ����',
        '����� ��� ��������� ���� ����',
        '���� �� ����� ���� ����',
        '��� (� ���)'
    ]

    /* conversation verb abbreviations */
    conversationAbbr = "\n\t���� ��� (����) ������ �� ������� ��� �������� ��
                        � (����)
                        \n\t��� ��� (����) ������ �� ������� ��� �������� �� � (����)"

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
        "�������� �� �������� �� ������ ���������� �������� ���� � 
		�������� ���� �������� ������� �� ��� �������. 
		��� ����������, �������� �� ����� ���� ��� ���� ��� �� ����� � ��� ���� ������ ��� ��� ���������.
		������ ����� �� �������������� ��� ������� ���� ��� � ��� ���. �� �������� ��� �� ���������� ����� ������, 
		�������� ��� ���������� �� ��������� ���������� ��������� ���� <q>����
        ��� ������ ��� ������� �� �������� �� ��������.</q>
        ���� ������������ �����������, �� ����� �� �������� ������������ �� ������ ��� ������������ ����������� 
		� ������ ���������� ��� ����� ���������� ���� �������, ���� ��� ��������� ������ ���� �� ����� ��� ����. 
		������, ��� ���� ���� ������� ��� ������ ��� ���������� ��� 
		�� <i>������</i> �� �������� ��� ������ ������������ ��������� ����, ��� ������� ����� �� ��� �� ����������.

        \b��� ������ �� �������� � �� ����� ���� ���� ��������� ����� �������� ���������, �������� �� ������������ ��� 
		������� ���� ��� �� � ��� ��� ��� �� �. ��� ����������, ���� �������� �� ������ �� ��� ����, �������� �� 
		������������ ��� ������ ���� ��� ���� ��� �� ���������� ���� �� � ����������. ���� � ����� ����������� ���� 
		���� ��������� ���� ��� � ����������� ������ ���� � ���.

        <<firstObj(InConversationState, ObjInstances) != nil ?
          "\b��� �� ����������� ���� ���� ���������, �������������� ���� ����/����/��� (����� ���������). 
		  �� ����� ��� ����� ����������� �� ��������� ��� ������� ��� ����� ��������� ��� �� ���������� ��� ���������. � ����� ��� ���� ����/����/��� ����� ����� �����������, 
		  ����� �������� �� ���������� ��������� �� ���� � ��� ��� �� ���������." : "">>

        <<firstObj(SpecialTopic, ObjInstances) != nil ?
          "\b� ������� ������ ������������ �� ��������� ������� ������� 
		  ������� ����������, ����:

          \b\t(�� ��������� �� �����������, � �� ��������� ������� �� ���� ����������.)

          \b��� ������, �������� �� ��������������� ��� ��� ��� ������������� ������� ��������������� 
		  ��� ������� ���� �����������. �������� ������� 
		  �� ������������ ����� ��� ������� ���� ����� ������ ������ ���� ����� �������.

          \b\t&gt;����������
          \n\t&gt;������� ������� �� ���� ����������

          \b����� �� ������� ��������� ������� ���� �� ������������ ������ ��� ��������������, 
		  �������� ��� ���������� �� ��� ��������������� � �� ��� ���������� �� ����� ������� 
		  ������� ��� ��������. ��� ��������� ��� ���� ������� ��� ������ �� ������. ����� ����� �������� 
		  �������� ��� ����� ��� ������� ��� �� ������������� ������� ��� � ������� �� ��� ���������� ����� ���� 
		  ����� ����������. ���� � ������� ��������� ������� ��������, ��� ����������� ��� ������� ��� 
		  �������� �� ������. �������� ����� �� ��������������� ����������� ���� ������ ���� ��� ��� ��� ��� �������������." : "">>

        <<firstObj(SuggestedTopic, ObjInstances) != nil ?
          "\b��� ��� ����� �������� ��� �� �� �� ����������, �������� �� ��������������� 
		  ������ � ������ ��������� ���� ���� ��� ������ �� �������. ���� �� ��� ��������� ��� ����� ������� 
		  ��� �� ����� ��������� � ���������� ��� �� ����� �� ��������� �� �� ���� �������. � ������ ������ ������� 
		  ��� ��������� ��� �� ������ ���������, �������� �������� 
		  �� ������������ ��� ���� ������ ����� �� �� ��� ��������������� ��� �����." : "">>

        \b�������� ������ �� ��������������� �� ������ ���������� ��������������� �����������. 
		��� ����������, �������� �� ������ ���� �� ������� ����, ���� ���� ������� ���� ��������, � �� ������� ��� ����������� 
		�� �������, ���� ����� �� ������� ���� ��������. �������� ������ �� ���������� ������ ����������, 
		���� ���� ������� ��� ���� �� �� ����� � ���� �� �������� ���� ����.

        \b�� ��������� �����������, �������� �� �������� ��� ���� ��������� �� ����� ���� ��� ����. 
		���� ������� ��������������� �� ����� ��� ���������, ������������� ��� ����� ��� ��� �������� ��� ������ ��� ������ 
		� ���������� �� ���������, ��������������� ��� ���� ��������� ��� 
		�� ���������������� ��� ��� ������ ���� ��� ���� ��� ���������. ��� ����������:

        \b\t&gt;������, ������� ������

        \b�� ������� ��� ��� ������� ����� ������� ��� �� ����� ���������� �� ���������� ����� ���� ������� ���. �� ������������ ���������� ����� �� ���� ���� 
		������������� ��� ��� �� ������ �������� �,�� ���� ��������. "

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
        "�����. ";
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
        "� ������� ��������� �� ����������� ��� ������ ������ �������,
		������ ����������� ��� ����� ��� ��� ����� ��� ������������
		�� �� ��������� ������������ �����������. �� ������� ����� ��������.";

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
            ", ���� �������� �� ������������ ��� ������� �� ��� ������ (��� �� ��� ����������, ��� ����������). 
			������ �� ������������;
            \n(�� <<aHref('���', '�')>> �� ��� ��� ���������� � ���������� ��� �������, � ��������������
            <<aHref('�������', '�������')>> ��� �� ����������� �� ��� ������) &gt; ";

            /* ask for input */
            str = inputManager.getInputLine(nil, nil);

            /* if they want to capture them to a file, set up scripting */
            if (rexMatch('<nocase><space>*�(�(�(�(�(�(�?)?)?)?)?)?)?<space>*', str)
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
            else if (rexMatch('<nocase><space>*�.*', str) != str.length())
            {
                "����� �������. ";
                return;
            }
        }
        else
        {
            /* 
             *   they're already logging; just confirm that they want to
             *   see the instructions 
             */
            ". �� ������ �� �����������;
            \n(� ��� ��������) &gt; ";

            /* stop if they don't want to proceed */
            if (!yesOrNo())
            {
                "���������. ";
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
        "\b<b>�������� �������</b>\b
        ���������� ����� ��� ����������� ��� ������������� �� ��� ������� ��������������� ��� ������ ���� ���� ��� ������� ��� <q>��������</q>, 
		� ����� ������� ������� �� �����:
        \b";

        gLibMessages.mainCommandPrompt(rmcCommand);

        "\b����������� ����, ���������� ��������� ��� ��� �� ���: <q>�������, ����� �� ������������� ��������� ����, ��� ��������, 
		��� � ������� �� ����� �,�� ��� ������</q>, � <q>�������, ���� ������ �� ���� ����� ��� ������� ��������� ������ ������� ��� ��� ��������� ����������. 
		������ �������� �� ��� �� ����� �����������</q>. ������, ��� �� ��� ����� ������ ������� ��� ��� ��������������.

        \b���� ��������������, �� ����������� ���� ��� ����� ������ �������, �� ������ ������� ����������� ��� ��������, �������� 
		��� ����� ����� �� ������ � �� �������. �� ��� � ������ ������� ������ �� �������� 
		����������, ��� ������� �� ��� ����������� - �������� ���� ���� ���� �������� ��� ������ �� ���������.

        \b������, ������ �� ��������� �� ���������� �� ���� ��� ��� ���������� ���� ���� �������. �������, 
		��������� ��� ��� �������, ��� ��� ��� �������� ��������� ���� ������ �� ��������� �� ����� ��� ���������� �� ������ ������ �����������. 
		��� ����������, ��� ������ ��� ������, ������ �� ��������� ��� �� ������ ���� ������, ������� � 
		�������� - ���� ��� � ������� ��� �������� ���� ���� �� ��������, ��� ���������� �� ���������� ��' ����.

        \b��������, ��� ���������� �� ��������� ���� ���������� �������� ��� �� ���������� �� ������. 
		� ������ ��� ���������� ��� ����� �� ��������� ������. ��������, �� ��������� �� ��������������� ���� ��� ������� ����� ������ �����, 
		������������ ���������. ��� �� ��� ������� ��� ����, 
		��� ����� ������� ��� ��� ������� ��� �������� �� ���������������:";
        
        "\b
        \n\t ����� �������
        \n\t �������
        \n\t ������� ������ (� ���������, ��������������, ��� ���� ��������, � ����, ����, ����, ���)
        \n\t ��������
        \n\t ���� �� �����
        \n\t ����� ��� �����
        \n\t ����� ��� �����
        \n\t ������� �� ������
        \n\t ������ �� �����
        \n\t ������ �� �����
        \n\t ����� ���� ��� �����
        \n\t ����� ���� ��� �� ��������
        \n\t ���� ��� ����� ���� ��� �����
        \n\t ���� �� ����� ���� ��� �������
        \n\t ���� �� ������
        \n\t ����� �� ������
        \n\t ����� �� ��������
        \n\t ����� �� ���� �� �� ������
        \n\t ����� �� ������
        \n\t ����� ��� �����
        \n\t ����� �� �������
        \n\t ����� ��� ������ ��� 11
        \n\t ��� �� ��������
        \n\t ���� �� ����
        \n\t ���� ��� ���� ���� ������
        \n\t ���� ������� ��� ���� �� �� �����
        \n\t ���������� ��� ����� �� �� ������
        \n\t �������� ��� ����� �� �� ������
        \n\t ���������� ��� �����
        \n\t ���� ���� ��� ����������
        \n\t ����� ���� �������
        \n\t ����� ��� �������
        \n\t ������ ���� ��� �������
        \n\t ������� ��� �������
        \n\t ������������� ���� ���� ����������
        \n\t ��������� ��� ����� ���� ���������� ��������";

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
            "\b���� ����� ��� - ���� ���� ��� ���� ��������� ������� ��� �� ����������� ��� �� ������������ ��� ������� ����������� ��������.
			��� ���� ��������� ��� ������� ��� � ������� ��������� ��� ���� �� ��������� ���� ������� ����������, ��������� ����: ��������� �� �� ������ �� ������, 
			�������� �� �� ������ �� ��� � ������������ ��� ��� ������� ��� ������������ ��������.
			��� ���������� ��� ������ �� �������� �� ���������� ������� ������� ��� �� ������ �� ������ �����, ������ ��� ��� ���������� ������������ �������� ��������. ";
        else
            "\b�� ����������� ��� �� ������ ��� �� ����������� ��� �� ������������ ��� ������� ������������ ��������. ������ �� ����������� ������������ ��� ������� �������� 
			�������, ���� �� ���������� ��� ���� ���� ����� �� ��� ������� ��� �������������� ��������.";

        "\b������� ��� ����� ��� ������� ������� ����������� �������.
		� ������ ����� ������� (��� �������� �� ������������ �� ����� � ���� �� �) ��������� ��� ��������� ��� ��������� ����������.
		�������� �� ��������������� ����� ��� ������ ��� �� ���������� �� ����� ��� ������� �� �� ���������� ��� ��������� ���.
		� ������ ������� (� ���� ��) ��������� ��� ����� �� ��� ��� ��������� � ���������� ���.
		� ������ �������� (� �) ����� ��������� �� ������ ������ �������� ����������� ���� �������.";
    }

    /* Abbreviations chapter */
    showAbbrevChapter()
    {
        "\b<b>������������</b>
        \b�� �������������� ���������� ������� ������� ���� �����, �������� ��� �� �������������� ����� ��������������, 
		�������� �� ������������ ������� ��� ��� ��� ����� ����������������� �������:

        \b
        \n\t ����� ������� ������ �� ������� ��� ����� � ��� ����� ���������� �������� �
        \n\t ������� ������ �� ������� ��
        \n\t ������� ������ ������ �� ������� ������, � ����� ��� ����� � (������ �,�,�,
            ��,��,��,��,�� ��� �� ����, �� ��� �� ����)
        \n\t ����� ��� ����� ������ �� ������� �� ����������� ��� ����� � �� ��� ����� � � ��� �����
        \n\t �������� ������ �� ������� �
        <<conversationAbbr>>

        \b<b>������� ����� ������������ ��� ��� �������</b>
        \b���� �������� �������, �������� �� �������������� �������� � ���� �������� 
		��������. �������� �� �������������� ������ ���� �/�/�� ��� ����/���/��� ���� ����� ���������, 
		���� �������� �� ��� ����������� ��� �� ���������. ";

        if (truncationLength != nil)
        {
            "�������� �� ���������� ����������� ���� ��� ������ ��� <<
            spellInt(truncationLength)>> ��������, ���� �� ��������� �� ��� �� ������, 
			� ������� �� �������� �� ��������� ���������������. ���� ��������, ��� ����������, 
			��� ����� �������� �� ���������� ��� ���� ��������������������� �� <<
            '���������������������'.substr(1, truncationLength)
            >> � <<
            '���������������������'.substr(1, truncationLength+2)
            >>, ���� ��� �� <<
            '���������������������'.substr(1, truncationLength)
            >>SDF. ";
        }
    }

    /* Travel chapter */
    showTravelChapter()
    {
        "\b<b>������</b>
        \b�� ���� �������� ������ ��� ��������, � ���������� ��� ��������� �� ��� 
        <q>���������.</q>  � ������� ���������� ��� ��������� ���� � ���������� ��� ���������� 
		��� ����� ���� ��� ����, ���� ���� ��� �������������� �����. ���� ��������� ���� ������� 
		��� ������� ����� ��� ����������� ������� ���� ��� ��� ����� ��������� ���. �� ����� ����� ������� ���� ���������� ���� ����� 
		��� �� ������� ����� ������ �� ��� �������� �� ��������� ��� ���������.

        \b���� ��������� ����� ��� ��������� �������, ���� ������� ���������� ����� � ���� ��������. (������� ����� ���� ������� 
		������� ����� ��������� �� ������ ���������� ��� ��������, ���� ���� ����� ������� ������). ���� ������������ �����������, 
		� �������� �� ��� ��������� ����� �� ��� ������������ ������� �������. ����� � ���������� ��� ��������� �� ��� ���������, 
		������� ������ �� ��� ��� �� ������ �� ��� �� ������ ����� ��� ����������, �������� ��� ���������� �� ���������� ��� �� ������� 
		������ ��� ��������� ��� ����� ��� �����. ������������, ������ �� ������������ ��� ���� ����� ����� ���������, ���� ������ 
		��������� �� ��� ���� ���� � ���� ���� ������ ���� ������. �� ����� ��� �����������, ������ �� ����� ������� �� ����� ��� 
		������������� ������� �� �� ���� ��� ��������� ���, 
		���� ��� ���������� �� ��� ������������ ���� �� ���� (��� ����������, ����� ��� �������).

        \b��� �� ������������� ��� �� ��� ��������� ���� ����, ������� ���������������� ������� �����������: ������� ������, ������� ���������������, ������� ���� �.�.�.
		(�������� �� ������������ ��� ������� ������������ �� ��� ������ - �, �, � ,  - ��� ��� ��������� ��� ���� ��� ���� ������������ �� ��� �������� - ��, ��, ��, ��, ��, ��).
		� ������� �� ��� ���������� ����� ��� ��� ���������� ������������ ���� ��� ��������� ���� ����������, �������� ��� ���������� �� ���������� ���� ��� 
		������� ������������ ��� �� ����� �� ������� �����.

        \b���� ������������ �����������, � ��������� (�� ��� �������� ���������� ��� ����� ��� ������������ ��� �� ������� �� ��� ���������) �� ��� �������� ���� ���� ������ ��� ����, 
		�� ��� ��������� ������� ������ �� ����� �������.

        \b���� ������������ �����������, ���� � ������� ���������� ��� ����� � ��� �������, 
		��� �� ��������� �� �������� ��� ����� ��� �� ��������, ����� � ������� �� �� ����� ���� ��� ����. 
		���� ���� � ������� �������� ���� ��� ��� ����� ��������� �� �������� ���, 
		������� �� ������ �� �������������� ��� ����� ����.";
    }

    /* Objects chapter */
    showObjectsChapter()
    {
        "\b<b>���������� ������������</b>
        \b�������� �� ������ ���� ������� ����������� ��� � ���������� ��� ������ �� ��������� � �� ���������. 
		��� ������ �� ������ ����, �������������� ���� ��� �� ����� ��� ������������: ���� �� ������. 
		��� ������ �� ������ ���� ��� ��������� � ���������� ���, �������������� ���.

        \b������� ��� ���������� �� ����� ���� ������������� ������� �� ��� ������ ����� ��� � ���������� ��� ������� � ��������� ��� �����������. ��� ���������� �� ���������� ��� �� ���� ���� ������� ���� �����������.
		������ ������� ����� �� ����� ������� �� ������������ ��� ����������� ���� � ���� �� ��� ����, ��� ����������: ���� �� ������ ���� ������ � ���� �� ���� ���� ��� �������.
		��� �� ����� ��� ��������� ��� ��������, ������ �� ����� ������� �� ������������ �������� ����������� ��� ���������� ���� �� ���� ������, ���� ������� ��� ���������� ��� �������� �� ���������� ����������� �������� ��� 
		���������� �� ��� ������ � ��� �����.

        \b�������� �� ���������� ������ �������� ����������� (��� ������� ����� ������� �������� ��������) 
		����������� �� �����������, ���� ��� �������� �� ������ �� ��� ������ ����� (� ��������� �����������, 
		��� ����� �������� �� ������������ ���� �� � � ��, ���� ��� � ������). �� ������������ �������� 
		������� ����� ��� �������� �� ��������� ��� �� ����������� �� ��� ��� ��������� ������. ";
    }

    /* show the Conversation chapter */
    showConversationChapter()
    {
        "\b<b>������������� �� ����������</b>
        \b� ���������� ��� ������ �� ���������� ���� ����� � �������� ���� ���� �������. 
		��������, ������� �����, �� ��������������� �� ������ ���� ����������.\b";

        /* show the customizable conversation instructions */
        conversationInstructions;
    }

    /* Time chapter */
    showTimeChapter()
    {
        "\b<b>���</b>";

        if (isRealTime)
        {
            "\b� ������ ���� ������� ��������� ������� �� ��� ������� ��� ������. 
			��������, �������� ���� ��� �������� ������ �� ���������� �� <q>���������� �����,</q>  ��� �������� 
			��� �������� ��������� �� ������� ����� ��� ��� ����� ��������� ��� ������� ������ ���.

            \b��� ������ �� ����������� ��� ����� ��� �������� ��� ������������� ��� ��� ���������� ��� (� ���� ���������� ���� ����� ��� �� ���������), 
			�������� �� ��������������� �����.";
        }
        else
        {
            "\b� ������ ���� ������� ��������� ���� ���� ������ �������. 
			���� �������� ��� ������ ��� ��������� ��� ���������� �� ��������������� 
			��� ������� ������ ���. ���� ������ ������� ������� ��� ���� ����� ���� �������. 
			��� ������ �� ������� ������������ ������ ���� �������, ��� ���������� ������ ��������� ��� ��������� �� ������ ����, 
			�������� �� ��������������� �������� � ������� (� ���� �). ";
        }
    }

    /* Saving, Restoring, and Undo chapter */
    showSaveRestoreChapter()
    {
        "\b<b>���������� ��� ��������</b>
        \b�������� �� ������������ ��� ����������� ��� ��������� ����� ��� ���� ������� ��� ���� ������, ���� �� �������� 
		�������� �� ����������� ��� ������� ���� ���� ����. �� ����������� �� ����������� �� ��� ������ ���� ����� ��� ���������� ��� ��� �������� 
		�� ������������ ��� ����������� ����������� ���������� (��� ����� ��� ����� ��������� ���� ���� ����� ���).\b";

        switch (crueltyLevel)
        {
        case 0:
            "�' ����� ��� �������, � ���������� ��� ��� �� ������� ���� ��� ��� �� �������� ���� 
			�� ��� ��������� ���� ����� ������� �� ������������ ��� �������. �,�� �� �� ������ ���� ��������� ���, 
			�� �������� ����� �� ������ ���� ����� ��� �� ������������ ��� �������.
			��������, �� �������� �� ����� ��������� ��������, ��� ���������� �� ���������� ��� ��� ���������� 
			������ ��� �� �������������� ��� �� �� ��������� �� ��������.
			������, �������� ����� �� ����������� ��� ����� ������, ��� �� ��������� �� �������� ��� ��� �� ����������� �������� � ��� �� ������������ 
			������ ��� �������� ��� ������ �� ������ �� ������������ ����.";
            break;

        case 1:
        case 2:
            "����� ������ � ���������� ��� �� ������� ���� ������� � �� �������� �� ��� ������� ��������� ���� ��� 
			�� �������� �� ������������ ��� �������.
			��������, �� ������ �� ����������� �� ���� ��� 
            <<crueltyLevel == 1 ? '��� ����������' : '�����'>>
            ���� �� ��� ��������� �� ����������� ���� ���� �� ������ ���� ������. ";

            if (crueltyLevel == 2)
                "(�� ������ �� ���������� ��� �� ����� ������������ ��������� ���, ����� ������ �� ��� ����������������� ������ ��� ��� ��������� ���� ����� �������. 
				������ �� ������������ ��� ���������� �� ����������� �� ��� ������ ���� ��� ����� ��� ���� ��� <i>��������</i> ��� ���� �������.)";

            break;
        }

        "\b��� �� ������������ �� �������� ���� ���, �������������� ���������� ���� ������ �������.
			� ������� �� ��� ������� �� ����� ��� ������� ��� ����� ������ �� ����������� �� ��������.
			������ �� ���������� ��� ����� ������� ��������� ��� �� ������� ��� ��� � ������ �� ������ �� ���� ������ �������� ���� ��� �� ����������� �� ������.
			�� ������������� �� ������� ������ �������� ���� ��� ����������.
			������ �� ��������������� ��� ����� ������� ��� ��� ������� ��� ���� ���������� ���, 
			����� �� ��� ������ �� �������������� ����������� ������� ������ �� �� ���� �����.

        \b�������� �� ����������� ��� ������������ ������������ ���� ��������������� �������� �� ����������� ������ �������.
		� ������� �� ��� ������� �� ����� ��� ������� ��� ������ �� �����������.
		���� � ����������� �������� �� ������, ��� ���� ������� �� ����� ������� ���� ���� ���� ������������ ���� �� ������.";

        "\b<b>��������</b>
        \b����� �� �� ��� ����� ����������� �������� �� ���� ���, ������� �������� �� ����������� ��� ���������� ������� ��� ��������������� ��� ������ ��������.
		���� ���� ��� �������������� ��������, � ������� ��������� ��� �������� ���� �������, ������������� ��� ������� ���� ���� ���� ��������������� ����� ��� ������.
		� ������ �������� ������������ ���� �������� ��� ���������� �������, �������� ��� �������� ������������ ��� �����������/���������� (����������/��������), ���� ����� ���� ������� ��� �������� ����������� �� 
		��� ���������� ��������� � ������ ��� ����� ��� ������ �� ����������.";
    }

    /* Other Special Commands chapter */
    showSpecialCmdChapter()
    {
        "\b<b>������� ����� ������� �������</b>
        \b� ������� ������������ ������� ����� ������� ������� ��� ������ �� ��� ������ ��������.

        \b���� (� ���� �):  ������������� ��� ��������� ������. (��� � ��������� ������ ������� �������� ������ �������, 
		��������������� ���� � ��������� ������ ��� �������.)
        \b������� (� ���� ��): ������� �� ������� � ���������� ���.
        \b����� (� ���� �): ������� ��� ����� ��������� ��� ����� ���� ����� ��������� � ���������� ���.";

        /* if the exit lister module is active, mention the EXITS command */
        if (gExitLister != nil)
            "\b������: ������� ��� ����� ���� ��� ������� ������  ��� ��� �������� ���������.      location.
            \b������ �������/���������/���������/�����: ������� ��� ����� �� ��� ����� �� ��������
            ��������� �� ����� �� ��� �������. ������ ������� ��������� ��� ����� ������ ��� ������ ���������� ��� ������ ��������� ��� ������� �� ���� ��������� ��������.  EXITS OFF turns off both of these listings.
            ������ ��������� ����������� ���� �� ����� ������ ��� ������ ���������� ���
            ������ ������� ����������� ���� ��� ������ ������ ���� ���������� ��������.";
        
        "\b����:��������� ��� ���������� ���� �� ��� ������, ����� �� ���������� �� ��������������� ���� �������� ��� ������. �������� �� ��������������� ��� ������ ���� ���� ������ ���� ��� ���������� ��� ���������� ��� ��� ���������� ��� ���� ���� ����������� ������ ���. �������������� ���� ������������ ��� �� ���������� ����.
        \b����������� (� ���� �): ���������� ��� �������.
        \b������������: �������� ��� ������� ��� ��� ����.
        \b��������: ���������� ��� ���� ���� ������� ��� ������������ ���� ����������� �� ��� ������ ����������.
        \b����������: ���������� ��� �������� ���� ���� ��� ����� ������.
        \b�������: ������ ��� ��������� ��� ��������� ��� ���� �������, ������������� ��� �� ������������ ������� �� ��� ������ ���� �����, 
		���� �� �������� �� �� ��������� �������� � �� �� ����������.
        \b������� ��������: ���������� ��� ��������� ��� ���������� �� ��� ������ �������.
        \b��������: �������� ��� ��������� ������.
        \b���������� �����������:  ���������� ��� ��������� ��������� ��� ��� �������� ���� ������������, ������ ��� ������������� �� �����������. ���� �������� ��� �� ��������� ��� �� ������������� �������� 
		��� ������� ���� ��� �� ���������� ��� ��� �������� � �� ������ ������������ �� ����.
        \b�������� �����������: ���������� ���� ��� ��������� �������� ��� ������������ ������������ �� ��� ������ ���������� �����������. ";
    }
    
    /* Unknown Words chapter */
    showUnknownWordsChapter()
    {
        "\b<b>�������� ������</b>
        \b� ������� ��� �������� ���� ��� ������ ��� ��������� �������.
		������ ����� ��� ������������ �� �������������� ������ ���� ����� ��� ���������� ��� ������ ��� �������� �� �������.
		��� ��������������� ��� ������ �� ��� ���� ��� � ������� ��� ��������, � ������� �� ��� ���������� ��� �� �� ������������� ����.
		��� � ������� ��� �������� ��� ���� ��� ���� ��� ���������� ��� ��� �������� ������ �������� ��� ���� �� ������, �������� ������� 
		�� ��������� ��� �� ����������� ����� ����� ��� ����������� ��� ������ ��� ��� ����� ��������� ��� ��� �������. ";
    }

    /* Ambiguous Commands chapter */
    showAmbiguousCmdChapter()
    {
        "\b<b>������� �������</b>
        \b�� ��������������� ��� ������ ��� ���������� ������� ���������� �����������, � ������� �� ����������� �� ��������� �� ��������.
			���� ����� ������ �������� ��� �� ������� �� ��������, � ������� �� ����� ��� ������� ��� ��� ����������� ����������� ��� �� ���������� �� ��� ������.
			� ������� �� ��� ���������� ��� ��� ��������� ��� �� ����� ��� �����������, ��� �� ���������� ����������� ������� ������ ��� ��������� ��� �������� ��� ��� ����� ���.
			��� ����������:

        \b
        \n\t &gt;���� �� ������
        \n\t (���� �����)
        \n\t �� ������ ����� ���� ������ ���� �����. � ���� ��� ��������
        \n\t ������ ������ ���� ���� ��� �����.
        
        \b��� � ������ ��� ����� ������ ������ ���� � ������� �� ��� ������ �� ����� �� �������� ������ �������, �� ��� ������� ����������� ����������. 
		�������� �� ���������� �� ����� ��� ��������� ��������������� ��� ����������� �����������.

        \b
        \n\t &gt;���������� ��� �����
        \n\t �� �� ������ �� ��� ������������;
        \b
        \n\t &gt;������
        \n\t ���� ������ �������, �� ����� ������ � �� �������� ������;
        \b
        \n\t &gt;�����
        \n\t ����������.

        \b��� � ������� ��� ����� ��� ��� ����� ��� ��������� ��� ����������� ��� ��� ������ �� ����������� �� ��� ������ ������, 
		�������� ����� �� ��������������� ��� ��� ������ ���� �� ���������� ���� �������.";
    }

    /* Advance Command Formats chapter */
    showAdvancedCmdChapter()
    {
        "\b<b>��������� ����� �������</b>
        \b����� ������������� �� ��� �������� �������, 
		������ �� ��� ����������� ��� ��� �������� ������ ������� ��� �� 
		�������� �����������. ����� �� ������������ ������� ����� ������� ������������, 
		����� �������� ����� �� ������ �� ���� �������� �� ��� ����������� ������ ��� 
		������ ��� ���������. ������, �������� ������� ����� ��������� ��� ������������ 
		������ ������� ������ ������� �� �������������� ����� ��������������.

        \b<b>����� ������ ������������ ����������</b>
        \b���� ������������ �������, �������� �� ������� ���� �� ����� ����������� 
		���� �� ��� ������. �������������� ��� ���� ���, � ��� �����, ��� �� �����������
        �� ��� ����������� ��� �� ����:

        \b
        \n\t ���� �� �����, ��� ����� ��� �� ������
        \n\t ���� ��� ����� ��� �� ������ ���� ��� �����
        \n\t ��� �� ����� ��� �� ������
        
        \b�������� �� ��������������� ��� ���� �����/����/��� ��� �� ����� ��� �� ����������� �� ���
        �� ����������� ��� ����� ������� �� ��� ������, ��� �������� �� ��������������� ��� ���� ����� � ����� ��� � �� �������� � ���� ���
        (������ ���� ��� ���� �����/����/���) ��� �� ��������� ������ �����������:

        \b
        \n\t ���� �� ���
        \n\t ���� �� ����� ����� ��� ��� ����� ��� �� ������ ���� ��� �����
        \n\t ���� �� ����� ��� �� �����
        \n\t ���� �� ����� ��� �� ����

        \b� ������ ��� ���������� �� ��� �� ����������� ��� ������� ������ �� ����������� ��� ��� ������ ���, 
		������������ ��� ������������ ��� ���������� ���� �� ���� �����������. ��� ����������, ��� ������� ��� ����� 
		��� ��� ������ ��� �� ����� �������� ���� �����, � ������ ��� �� ��� 
		�� ����� �� ����� ��� �� ������, ���� � ������� �� ���������� ���� ��� �����.

        \b<b><q>�����, ����� , ����, ���, ���, ��</q> ��� <q>������, �����, ����, ����, ���, ��</q></b>
        \b�������� �� ��������������� �� �����/�����/����/���/���/�� ��� ������/�����/����/����/���/�� ��� �� ����������� ��� ��������� ����������� � �����������
        ��� ���������������� �� ��� ������:

        \b
        \n\t ���� �� �����
        \n\t ������ ��
        \n\t ���� ��� ����� ��� �� ������
        \n\t ���� �� ���� ��� �����

        \b<b>������ ������� ����������</b>
        \b�������� �� �������� ��������� ������� �� ��� ������ ������������� ��� �� �������
		� �� ��� ���� ����, � �� ��� ���� ������, � �� ��� ���� ������, � �� �����, � �� ����� ��� ��� ��� ����� ��� ������, � �� ��� 
		�� ��� ��� ����� ��� ������. ��� ����������:

        \b
        \n\t ���� ��� ����� ��� ���� ��� ���� ��� �����
        \n\t ���� �����. ������ ��.
        \n\t ���������� ��� ����� �� �� ������. ������ ���, ���� ������� ������.

        \b ��� �� �������� ��� ������������ ��� ��� ��� ������� ���, 
		�� ��� ���������� ��� ��� ������� ������ ��� �� �������� �� �������� ��� �������.";
    }

    /* General Tips chapter */
    showTipsChapter()
    {
        "\b<b>������ �������</b>
        \b���� ��� ��������� ��� �������� ������������ ��� ��� �������� 
		�������, ������ �� ��� ����������� ������� ����������� ���������. 
		���������� ������� �������� ��� ������������� �� �������� ������� ���������� ������������ ����������� 
		���� ������������ ��� �������.

        \b����������� �� �����, ������ ���� ���������� �� ��� ��� ���������, �������� ���������� �� �����������. 
		����� �� ����������� ������������ ��� ��� ����������� ���� ������ ��������� ��� ����������. ��� � ������� 
		���� ������������ �������� ��������� ���� ��� ������������, �������� ��� ����.

        \b������������ ���� ����� ��� ��������, ��� �� �������� ������������ ������������ ��� ����� ����������. 
		���� ��������� ��� ��� ��������� ��� ����� ����, ��������� ���� ��� ������� ���. ���� �� ��� �������� 
		�� ����� ������ �� �������� ������ ��� ��� ����� ����������� �����. ��� ���������, �������� �� ��������� 
		��� ����� ��� ��� ����� ������������� ��������, ���� ������ �� ������ ���� ��� ���������.

        \b��� �� �������� ��� ����������� ��� ���� � ������ �������� ���, �� ����������� ��� ����������� �� ����������� 
		������ ��� ����� ��������� ��� ��� �������. �� ������������ �� ��������������� �� ���� ��� �� �������� ��������� 
		�� ���� ��� <q>���� ��� ����� ���������</q>, �������� �� ��������� �� �����������. ���������� ������� ���� ��� �� 
		���������� �������� �� ����������.

        \bI��� ����������� �� ���������� ���� ��� ������ ��� ��� ������ ��� �������� �� ����������, ����� ������� ��� �� �������� ������. 
		��� ���� ���������� ��� ������������ �������������� (<q>��� ��������� ������</q> � <q>���� ��� ����� ���� ��� ������� �� ��������</q>), 
		���� ��������� ��� ����� �����. ������ ��� �� ������������ ���������� ��� 
		��������� ������ ������� ��� �� �������������� �� ��������. ��� � �������� ����� 
		��� ������������, ������ �� �������� ��� ��������� ��������. ��� ����������, 
		� ����� <q>T� ������� ���� <q>��� ������� �� �� �������� ���� ���!</q>\ ��� ������� �� ����� ��� �� ����� ���</q> &mdash;
        ������ �� ����������� ��� ������ �� ������ ��� ������ �� ����� � 
        ��� ������ �� ������ �� ����� ����� ����� ���� �� ��������.

        \b��� ��������� �������, ��������� �� ������� ���� ���� �� ������ 
		�������� ��� �� ���������� �� ���� ���� ��� ����. �������� ����� ��� 
		�� ������������ �� ���� ��� ��� �� ������ ��� ��������� ��� �� ��������. 
		� ���� ��� �������� ��� ��� ���������� ������ �� ��� ����� ������� �� ��� 
		������ ���������, ��� ����� �� ������� ��������� ������� �� ����� ���������� ��������������. 
		������� �������� �������������� �������� ���� ��������� �� �������� ������, ��������� � ����� ��� �����. 
		��� ������������ ��� �������, ����� �� ���������;

        \b�����, ��� ��� �� ���� ���������, �������� �� �������� �������. ��� ���������� ���� ��� ��������� 
		����� � ����� ���������� Usenet
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
VerbRule(instructions) '�������' : InstructionsAction
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

InstructionsMenu template '������' ->chapterProp;

/*
 *   The main instructions menu.  This can be used as a top-level menu;
 *   just call the 'display()' method on this object to display the menu.
 *   This can also be used as a sub-menu of any other menu, simply by
 *   inserting this menu into a parent menu's 'contents' list.  
 */
topInstructionsMenu: MenuItem '��� �� ������� �������� ������������ �����������';

/* the chapter menus */
+ MenuLongTopicItem
    isChapterMenu = true
    title = '��������'
    heading = nil
    menuContents()
    {
        "\b<b>Introduction</b>
        \b����� ������! �� ��� ����� ������ ���� ���� ��������� ������������ �����������
        , ����� �� ������� �� ��� ��������� �� ����������. ��� ��������� ��� ��� �� ������� 
		���� �� ����� ����������, �������� ������� �� ����������� ��� ������� �������, ���� 
		������ �� ������ �� ��������������� ABOUT ��� ������ ������� ��� ��� �������� ��� ������� ��������������� ����� ��� ��������.
        \b
        ��� �� ������������ � �������� ���� �������, ����� ����� �������� �� ��������. ";

        if (curKeyList != nil && curKeyList.length() > 0)
            "��� ����� ���� ���������, �������
            <b><<curKeyList[M_SEL][1].toUpper()>></b> 
			��� �� ����������� ��� ������� �������� � <b><<curKeyList[M_PREV][1].toUpper()>></b>
            ��� �� ����������� ��� ����� ���������. ";
        else
            "��� �� ������������� ������ ��� ���������, ����� ���� ����� ���������� 
		� �������������� �� ������� ����� ��������/�����. ";
    }
;

+ InstructionsMenu '������� �������' ->(&showCommandsChapter);
+ InstructionsMenu '�������������� �������' ->(&showAbbrevChapter);
+ InstructionsMenu '������' ->(&showTravelChapter);
+ InstructionsMenu '���������� ������������' ->(&showObjectsChapter);
+ InstructionsMenu '������������� �� ������ ����������'
    ->(&showConversationChapter);
+ InstructionsMenu '���' ->(&showTimeChapter);
+ InstructionsMenu '���������� ��� ��������' ->(&showSaveRestoreChapter);
+ InstructionsMenu '����� ������� �������' ->(&showSpecialCmdChapter);
+ InstructionsMenu '�������� ������' ->(&showUnknownWordsChapter);
+ InstructionsMenu '������� �������' ->(&showAmbiguousCmdChapter);
+ InstructionsMenu '���������� ��������� �������' ->(&showAdvancedCmdChapter);
+ InstructionsMenu '������ �������' ->(&showTipsChapter);

#endif /* INSTRUCTIONS_MENU */

