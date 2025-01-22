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
    name = '� ���� ��� �������'
    byline = 'by ������� ��������'
    htmlByline = 'by <a href="mailto:your-email@host.com">
                  ������� ��������</a>'
    version = '1'
    authorEmail = '������� �������� <your-email@host.com>'
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
       "� ���������� ��� ������� ����������� ������!\b";
     }
     showGoodbye()
     {
       "<.p>�����!\b";
     }
     maxScore = 6     
     beforeRunsBeforeCheck = nil     
;


me: Actor
    /* the initial location */
    location = outsideHouse
;

+ Wearable '���� ����� ��������/�����' '����[-��-�-�] ��������'
    "����� ������ ����, ���� �� ������� �����."
    wornBy = me
    dobjFor(Doff)
    {
        check()
        {
            failCheck('��� ������� �� ��������� ����������! ');
        }
    }
;
+ Wearable '�������� ���������� *������' '��������[-��-�-�] �����'
    "�� ������ ������������ ���� ��� �� ���� ��� ��� �����."
	isHerPlural = true
    wornBy = me
    dobjFor(Doff)
    {
        check()
        {
            failCheck('��� ������� �� ��������� ���������! ');
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

outsideHouse : OutdoorRoom '������� ��� �����' 
   "������, �������� ��� �������� �������� ��������� ��� ���� ���� ��� �� ��� �������� ���� �������.
   �������� ��� ��� ��� �����, �������� �����. ��� ����� ��������� ��� �������� ��� ����� �����. �� ������ ���� ��� �� ����� ��� ����� ���������
�� ���� �����, ��� ��������� ������� �� ���� ��� ����, ��� �� ����������� �������� ��� ����� ���. 
��� ������������ ������� �� ���������� ��� ����� �������� �� ������� ���� ���� ������.   "

   south = darkForest
   northwest = mistyRoom
   in = houseDoor
   north asExit(in)
   isIt=true
;
+Enterable ->insideHouse '����� �����/������' '����[-��-�-�] �����'
   "�� ������ ��� ����� ���������� ��� ����� �����, ������� �� ������ ��� �������� ������ ��� ������� ��� ������� ��� �� ���� �� ������ ��������. 
   �� ����� ���� ���� ������������� �� ������� ��� ��� �� ������ �� ������� ��� ��� ��� ������. 
   � ����� ����� ��� ����������, ������� �� ��� ���� ���� ����� ���, ���� ������, 
   ������� ������ �����, ��� �� ��������� ��� ��������� ���� ������ ��� ��� 
   ����������� ���� ���� ��� ����� �� ����. 
   �� �������� ����� ����� ��� �����, ����������� ��� ���� ���� ����� ��� ������� �� ����������� ��� �� ���� �� ������. 
   
   <br><br>��� ����, ��� ���� ��� �����������, ��� ������� �� ��������� ���� ��� ��� ���������. ����, ����, ��� ������� ������. "
   location = outsideHouse
   isIt =true
   cannotCleanMsg = dobjMsg('��� ����� ����� ��� ���� ������ ����� ��� ������. ')
    notASurfaceMsg = iobjMsg('��� ������� �� ������� ��� �����. ')
	cannotTakeMsg = '��� �������� ��� ����� ���� ���� ��� ����; ���� ���� ���� ��������. '
 
;

+ houseDoor : LockableWithKey, Door '����� ������ �����' '����[-��-�-�] �����'
    "� ����� ��� ������� ����� ����� ��� ������, �� �� ����� ��� �� ���� �������� ��� �� ������ ��� �� �����, �������������� ��������� ��� ������ ��� ����� ���. 
	��� ������������ ��������� ���� �������� ��� ����, ���������� �� ���� ������������� ��� ����� ���.  "
    isHer =true
	keyList = [houseKey]
	
	
;

+Decoration '���� �����/������' '���[-��-�-�] �����'
 "� ���� ����� ��������� ���� ���, ��������� ��� ����������� ������� �������� ��� ����������� ���� ����.
 � ��������� ��� ����� ������ ��� �������. ���� ��� ���� ������ ���� ��� ��� ��������� ��� ������� ���� �� ����, ��� ��� �� ������ 
 ��������� �� ��������� ��� ������ ���."
 isHer =true
;

+ Distant '�������� ����� �����' '�����'
    "�� �������� ����� ��������� ��� �����. "
    tooDistantMsg = '����� ���� ������ ��� ���� ������. '
	isIt = true
;
+ Distant '����� ��������' '��������'
    "�� �������� ������ ������������. "
    tooDistantMsg = '����� ���� ������ ��� ���� ������. '
	isIt = true
;


+Decoration '������������ ��������� ����' '��������[-�����-����-����] ����'
 "��� ����� ������ �������� ��� ��� ������"
 isHer =true
 ;



houseWindow : SenseConnector, Fixture '��������' '��������'
  "�� �������� ����� ���� ���� �� �������� ������ ��� ����� ���� �� ��� ����. �������� ��� ���� ����� �� ����������. "

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
         "������ ���� ��� �� ��������. ������� �� ���������� �� ��������� ��� �������. ";     
      }
      else
      {
         otherLocation = outsideHouse;
         "��������� ��� ��� �� �������� ������� �� ���� �� �������� ��� ������ ���� �� �����. ";         
      }
      gActor.location.listRemoteContents(otherLocation);     

    }
  }   
  connectorMaterial = adventium
  locationList = [outsideHouse, insideHouse]
  isIt=true
;
///////////////////////////////////////////////////////
insideHouse : Room '������' '������'
  "��������� ��� ��������� ��� �������, ���� �� ��� ���� ��������� ������ �����������, ����������� ����������� ����� ����� �������. 
  �� ���� �������� ���� �� ��� �����, ������������� �������. ���� ���, �������� ��������� ��������� ��� ������, ��� ������� �� ����� ��������. "  
   out = houseDoorInside
   south asExit(out)
   isIt = true
   
   remoteRoomContentsLister(other)
    {
        return new CustomRoomLister('���� ��� �� ��������, {���/�����} {�����}', 
                                    ' ��� ������.');
    }
   	up : TravelMessage 
  {  
    destination = inpatari 
    canTravelerPass(traveler) 
             { return traveler.isIn(chair) && traveler.posture==standing; }
           explainTravelBarrier(traveler) 
            { "�� ������ ����� ���� ����. "; }  
			
			travelDesc =  "�� �� �� ������� ���� ���� ������� ����������� �� ������� ���� ��� ������.<.p>"
  }
;
+ houseDoorInside : Lockable, Door -> houseDoor '�����' '�����';

+Candle '������� ����������� ����*�����' '������� ����'
	 "����� ��� ������� ���� ��� ������ ���� ��� ����� ���� ��������, � ����� ���� ������ �� ����� �������� ��� ��� �����������."
	 isIt =true
	;

+Surface '����� ������������� ������ �������' '�������'
"�� ������� �������� ���������, ������ �� ����� �� ��� ��������� �����."
isIt=true

;

+Fixture '������� ���� ������ ������ ������/���������' '������[-��-�-�] ������'
	"����� ��� ����� ���� ����� ���� ������� ������ �� ����������� �����������. �������� ��� ���� ��� ����� �� ��������� �� �������. 
	� ������ ��������� ��� ������� ��������, �� �� ����� ��������� ��� �� ��������� ����������"
	remoteInitSpecialDesc(actor) { "���� ��� �� �������� ������� �� ���� ���� �� ������������ ���� ���� �����";}
	isIt=true
	dobjFor(Climb) remapTo(Up)
;

///////////////////////////////////////////////////////////////////////////////
inpatari : Room '������'
	"�� ������ ����� ���� ������ ������������� ����� ��� ���� ������ �� ��������. ������� �� �������� 
	��� ������ ���� ����������. ���� ����� ������ ����� ������ ��� ����� ������.
	��� ���� �������� ��������� �� ������� ���� ��� ��� �������� ��� ������� ���� ����� �����."
	out = insideHouse
   down asExit(out) 
	
	enteringRoom(traveler) 
    {	    
        if(!traveler.hasSeen(self) && traveler == gPlayerChar)	
            addToScore(1, '��������� ��� ������. ');	    	    
    } 
	
	
	isIt =true
;

+ ntoulapi : OpenableContainer, Heavy '����� ����� ����� ��������' '����[-��-�-�] ��������'
	" �� �������� ����� ����� ��� �����. ���� ��� ������� ��� ������� ��� ������ '��������'. ���� ���������, ���������� ���� �������� �� ������� ��� ���� ���."
	
	isIt=true
    
;


++ snake : Thing '������������ �����������/������' '�����������[-��-�-�] �����������'
"��� ������������ ����������� �������� ���� ��� ���� ������ �������. ��� �������� �������� ��� �� ����� ��������� ���� �������� ��� �� ���� ��� ��������."
	actionDobjTake()      
    {  
      "�������� �� ���� ��� �� ������� �� �������� �����������. ���� ��� ����� �������� ��� ��� ����� ���� ��� �������. 
	  ����� ��� ����. �� ������ ��� �� ��������� �� ���� ��� ���� �� ���� ���� ����� ����� ����. 
	  �� ���� �� ������.";  
        
      finishGameMsg(ftDeath, [finishOptionUndo]);  
    } 
	isIt=true
;

++ rope : Attachable, Thing '������ ����������� �����������/������' '����������[-��-�-�] �����������'
	"����� ��� ����������� �����������. � ��������� ��� ��� ����� ����."
	initSpecialDesc = "��� ����������� ����������� �������� ���� �������� ������ ��� ����������. �� ����� ������� ��� �� ������� �� ���������� �� ������� �������. ����� ������� ���������. "
	isIt=true
	dobjFor(ClimbDown) remapTo(Down)
	dobjFor(Take)
  {
	action()  
    {  
      if(!isHeldBy(gActor))  
      {
		  addToScore(1, '���������� �� ������. ');
		  inherited;
		  name = '����[-��-��-�] ������';
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
mistyRoom : OutdoorRoom '���� ���� ������'
"���� ���� ������ ������ ��� ������� ��� ���������������. �� ���� ��� ������� �� ���� ����� ��� ������� �� �����������."
isHer =true
southeast = outsideHouse
;

tin : OpenableContainer '����� ��������� ������/�����������' '����[-��-�-�] ������'
	@mistyRoom
    "����� ��� ����� ��������� ������ �� ������. "
	initSpecialDesc = "��� ����������� ��������� ��� ������"
    subLocation = &subSurface
    bulkCapacity = 5
	isIt = true
;

class Coin : Thing '�������/����*�������*�����*���������' '����'
    "�� ����� ��� ����� �����, ���� ��������� �� ������ ��� ���������� ��� ��� ������ ��� �������� <q>��� ����</q> ���� ���� ������. 
	� ���� ����� ��������� �� ��� ������
    <q>DECUS ET TUTAMEN</q>"
    isEquivalent = true
	isHer = true
;

+  Coin;
+  Coin;
+  Coin;
+  Coin;


houseKey : Key '����� ����������� ��������� �����������/����/������' '��������[-��-�-�] �����������'
	@tin
    "����� ��� ����� ����������� ������, �� ��� ������������ ������� ���� ��� ��� ��� �������� ����� �� ���������. "
    
	isIt=true
    remoteInitSpecialDesc(actor) { 
        
        "������� ��� ��������� ����� ����� �� �������� ��� ��� ����� ��� ���������� �� ���������� �� ������ ������� 
		������������ ��� ���� ����������."; }
    dobjFor(Take)
    {
        action()
        {
            if(!moved) addToScore(1, '�������� ��� ��������'); 
            inherited;
            name = '����[-��-�-�] ����������[-��-�-�] ������';
			isIt=true;
        }
    }
;
//////npc

stranger : Person '�������������� ��������/�����' '��������'
  @mistyRoom
  "����� ������� �� ���������� �� �������������� ��� ���� ��� ��� ����� �������� ��� ������. "
  //properName = '�����' 
  globalParamName = '�����'
  isHim = true
;

+ GiveShowTopic @ring
	topicResponse
  {
  "���� ��� ������ �� ���������, �� ������� ����� ������� ����� �������� �� ����� ���� ���� ����� ���.
  <q>������� �� ��������� ����.</q> ������������ ��� ��� ����� ��� �����.";
  addToScore (2, '�������� ����������� ���� ����. ');
     finishGameMsg(ftVictory, [finishOptionUndo,finishOptionFullScore]);
  }
;

+ DefaultGiveShowTopic, ShuffledEventList
  [
    '� ����� ����� �� ������ ��� �� �����������. <q>�� �� �� ���� ����;.</q>',
    '����� �� ���� ��� ��� ����������� �� ����. ',
    '<q>�� ����� ���������� ���������� �� ����� ��� ���� ���,</q> ����������� � �����. '
  ]
;

+ strangerTalking : InConversationState
  stateDesc = "�������� ��� ��������� ���� ���. " 
  specialDesc = "� �����, �� �� ������ ��� ��������, ��� ����. "
;

++ strangerWorking : ConversationReadyState
  stateDesc = "������ �� ��������� �� ������. "
  specialDesc = "��� �������� ������� ������� �� �������. "
  isInitState = true
 
;

+++ HelloTopic, StopEventList
  [
    '<q>���������,</q> ��� ��� ������������ �� ��������� ��� ������� ��� ��������� ��������.<.p>
     {� �����/�����} ������� �������, ��������� ������� �� ������.
	 <q>�� ��� ����� �� ��� ����� ����� �� ���������. ����� ��� ���������.</q>',
    '<q>�� ��� ����� ��� ������� �� ������.</q> ������� � ����� ���� ��� ��������� �� ��������. '
  ]
;

+++ ByeTopic
  "<q>�����, ��� ����.</q> ��� ��� ���� ��� ��� ����� �������.<.p>
   � ���� ������� ��� �� ������ ����� ��� ����� ����� ��� �������� ���. "
;

+++ ImpByeTopic
  "� ����� �� ������. "
;


++ DefaultAskTellTopic
   "<q>���� ����� � ����� ��� ������� �� <<gTopicText>>;</q> ��� �����.<.p>
   <q><<rand('<q>���� ��� �� �����,</q> ������� ������� ��������� ��� ��� �����.', '����� ����� ����� ���;' , '���� ������� ����!')>>.</q>"
;



///////////////////////////////////
darkForest : OutdoorRoom '���� ��� �������� �����'
   "���� ��� ����� ��� �������� ����� ���� ������� ����� ����� �� ������ �� ��������, � ������ ��� ������� ���� ��� ��� ���������� ������. 
   ��� ������� ��� �������� �� ������ �����, ��� ������, ��� ��������������� ��� ��� ������. "
    north = outsideHouse
    northeast = lake  
	south= clearing
	isIt=true
	
;
/////////////////////////////////
clearing : OutdoorRoom '������'    
   "������� �� ��� ������, ��� ����� �����, ���� �� ������� ��� ������� �������� �������, ��� �� ��������� �� ����������.
   ������� �� ���� ������ ����������� ������� ��� ����� ��� ��� ����, �� �� ������ ��� �� �������������� ��� ���� ������� ����.
   ��� ������ ���, �������� ��� ������ ������, �� ���� �� ��������� ��� ������ ���. 
   <br>��� �������� ������ ���� �� ������. "
    north = darkForest
    
	dobjFor(ClimbDown) remapTo(Down)
	isIt=true

	down : TravelMessage 
  {  
    destination = bottomOfWell 
    canTravelerPass(traveler) 
             { return rope.isAttachedTo(hook); }
           explainTravelBarrier(traveler) 
            { "�� ������ ����� ���� ����. "; }  
			
			travelDesc =  "������ �� ������ ���� ������. ��������� �� ������ �����������, ����, ����, �� �������� ���� �� ����, ���� ��� ������.<.p>"
  }
    south : FakeConnector {"����������� �� ��� ����������� �������� ��� �����, �� ��� ���� ��� �� ������. "}
;


+ well : Fixture, Thing '������� ����� ������' '������[-��-�-�] ����[-��-�-�] ������'
    "�� ������ �������� ������� ����, ��� ����� ����������� ����� ��� �������� ���� ���� ���. 
	�� ���� ����� ���� ��� ������, ����� ������� ��� ������. �������� ��� ���� ��� �� ��������� �� �������� �� ��� �� ������ ��� �������� ���� ����. " 
	isIt = true
	;

++hook : Attachable,Fixture ,Thing  '������������� �������' '��������[-�����-����-����] �������'
	"����� ���� ������������� ������ ���, ������ ��� ���� ��� ��������, �������� �� ����� ����� ������������."
	isHim =true
	isMajorItemFor(obj) {return obj==rope; } 
;
	
	
/////////////////////////////////
bottomOfWell: Room '���� ��� ������'
   "����� �������� ��� � ������� �� ������ ����� �������� ���� ��� ������. �� ����� ��� ����� ��� ��� ���������� ��� �� ��������� ��� �� ������.
   ��� ��� ������ ������� ��� ���� ��� ������ ��� ���� �����, ���� �������, ���� ��� ������� ��� �� ��������������, ��� ��������� ����� ��� ������� ��� �������. 
   �������� ��� ��� ����������� ��� ����� ���� �� ���� ���������. "
    out = clearing
	up asExit(out)
	down= mudRoom
	dobjFor(ClimbDown) remapTo(Down)
	dobjFor(Climb) remapTo(Up)
		isIt=true
	//dobjFor(ClimbUp) remapTo(Up)
;
///////////////////////////////////////
mudRoom: Room '���� ���� ��� ��������'
   "�� �� ����� ��� �� ��������� ���� ���� ����������� ��� ���� ��� ��������, �������� ��� ������� ��� ����������� ��� �� ������. �� ������ ����� �������� ��� ������� ��� ��� ��������� �� �� �������� ���� �� ����, ���� ��� �������� ������� ���.
	���� �� ���� �� �������� ���� ���� ������ ����� ��������������. ���� ��� �� ���� ��� ���������� ����� � �����."
    out = clearing
	up asExit(out)
	dobjFor(Climb) remapTo(Up)
	//dobjFor(ClimbUp) remapTo(Up)
	
;

+ ring : Thing '���������� ����������� ���������' '����������[-��-�-�] ���������'
    "�� ��������� ����������� ��� ��� ����������, �������� �������� ������������ �� �������. "
	isIt= true
;


//////////////////////////////////
lake : OutdoorRoom '����� ��� ������'    
   "������� ��� ��������� ��� �����, �� ���� ��� ������� ��� ����. ��� �������� ������ ��� ����������, ����������� ��� ��������� ��� ��� �������.
   ���� �������� ���� ������� ���� ��� ������� �� �����, ������� ��� ������. �������, ����, ��� ��� ����� ��� ���� ���� ���� �� ��� ��������.
	��� ����������� ������� ��� �������� ��� ������ ��� ����� ���� ��� ��� ���� ��� ��� �����. "
    southwest = darkForest
	isHer = true
    north : FakeConnector {"����������� �� ��� ��� ���� ����� ��� ����������. �� ������� �������� ���� ��� ����� ���� ������ ��� ����������. "}
	
;

+water : Thing '�����' '�����'
"� ����� �������� ���� ����������"
isHer = true
dobjFor(Cross)
  {
	action()  
    {  
     "���������� �� �������� �������� ���� ������� �� ������ ��� ������� ��� ������ �� ��������.
	 �� �� ������� ��� ����, ������� ��� ����.";  
        
      finishGameMsg(ftDeath, [finishOptionUndo]);  
	}
  }
  
  ;

+ chair : Chair '������ ����� �������[�]/�������[�]/���������[��]' '�����[-��-�-�] ����[-��-�-�] �������'
  "����� ��� ����� �������. ������ �� ��������� ��� ���� ������
	�������� ��� �� ������ �� ������ ������� ���� ���. "
	initSpecialDesc = "��� ����� ��������� ������� ��������� �������� ���� ��� ������ ��� ������. "
	isHer =true
	dobjFor(Take)
  {
	action()  
    {  
      if(!isHeldBy(gActor))  
      {
		  addToScore(1, '���������� ��� �������. ');
		  inherited;
	  }
	}
  }
	
  
;


////�������� ������

DefineTAction(Cross);

VerbRule(Cross)
    ('��������' | '�����') singleDobj
    : CrossAction
    verbPhrase = '����������/���������� (��)'
;

