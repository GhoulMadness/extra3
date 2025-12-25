function TributeP1_Easy()
	local TrP1_E =  {}
	TrP1_E.playerId = 1
	TrP1_E.text = "Klickt hier, um den @color:0,255,0 leichten @color:255,255,255 Spielmodus zu spielen"
	TrP1_E.cost = { Gold = 0 }
	TrP1_E.Callback = TributePaid_P1_Easy
	TP1_E = AddTribute(TrP1_E)
end
function TributeP1_Normal()
	local TrP1_N =  {}
	TrP1_N.playerId = 1
	TrP1_N.text = "Klickt hier, um den @color:200,115,90 normalen @color:255,255,255 Spielmodus zu spielen"
	TrP1_N.cost = { Gold = 0 }
	TrP1_N.Callback = TributePaid_P1_Normal
	TP1_N = AddTribute(TrP1_N)
end
function TributeP1_Hard()
	local TrP1_H =  {}
	TrP1_H.playerId = 1
	TrP1_H.text = "Klickt hier, um den @color:200,60,60 schweren @color:255,255,255 Spielmodus zu spielen"
	TrP1_H.cost = { Gold = 0 }
	TrP1_H.Callback = TributePaid_P1_Hard
	TP1_H = AddTribute(TrP1_H)
end
function TributeP1_Challenge()
	local TrP1_C =  {}
	TrP1_C.playerId = 1
	TrP1_C.text = "Klickt hier, um den @color:255,0,0 Herausforderungs- @color:255,255,255 Spielmodus zu spielen"
	TrP1_C.cost = { Gold = 0 }
	TrP1_C.Callback = TributePaid_P1_Challenge
	TP1_C = AddTribute(TrP1_C)
end
function TributePaid_P1_Easy()
	Message("Ihr habt euch für den @color:0,255,0 leichten @color:255,255,255 Spielmodus entschieden! Gute Wahl!")
	--
	Sound.PlayGUISound(Sounds.VoicesMentor_COMMENT_GoodPlay_rnd_01,100)
	--
	Logic.RemoveTribute(1,TP1_N)
	Logic.RemoveTribute(1,TP1_H)
	Logic.RemoveTribute(1,TP1_C)
	--
	MultiplayerTools.GiveBuyableHerosToHumanPlayer( 4 )
	gvDiffLVL = 2.6
	--
	XGUIEng.SetText("TopMainMenuTextButton", gvMapText.." @color:0,255,0 LEICHT @cr "..
		" @color:230,0,240 "..gvMapVersion)
	--
	PrepareForStart()
end
function TributePaid_P1_Normal()
	Message("Ihr habt euch für den @color:200,115,90 normalen @color:255,255,255 Spielmodus entschieden! Gute Wahl!")
	--
	Sound.PlayGUISound(Sounds.VoicesMentor_COMMENT_GoodPlay_rnd_01,100)
	--
	Logic.RemoveTribute(1,TP1_E)
	Logic.RemoveTribute(1,TP1_H)
	Logic.RemoveTribute(1,TP1_C)
	--
	MultiplayerTools.GiveBuyableHerosToHumanPlayer( 3 )
	gvDiffLVL = 2.0
	--
	XGUIEng.SetText("TopMainMenuTextButton", gvMapText.." @color:200,115,90 NORMAL @cr "..
		" @color:230,0,240 "..gvMapVersion)
	--
	PrepareForStart()
end
function TributePaid_P1_Hard()
	Message("Ihr habt euch für den @color:200,60,60 schweren @color:255,255,255 Spielmodus entschieden! Gute Wahl!")
	--
	Sound.PlayGUISound(Sounds.VoicesMentor_COMMENT_GoodPlay_rnd_01,100)
	--
	Logic.RemoveTribute(1,TP1_E)
	Logic.RemoveTribute(1,TP1_N)
	Logic.RemoveTribute(1,TP1_C)
	--
	MultiplayerTools.GiveBuyableHerosToHumanPlayer( 2 )
	gvDiffLVL = 1.4
	--
	XGUIEng.SetText("TopMainMenuTextButton", gvMapText.." @color:200,60,60 SCHWER @cr "..
		" @color:230,0,240 "..gvMapVersion)
	--
	PrepareForStart()
end
function TributePaid_P1_Challenge()
	Message("Ihr habt euch für den @color:255,0,0 Herausforderungs-	@color:255,255,255 Spielmodus entschieden! Achtung: Auf dieser Stufe ist diese Karte extrem schwer!")
	--
	Sound.PlayGUISound(Sounds.VoicesMentor_COMMENT_GoodPlay_rnd_01,100)
	--
	Logic.RemoveTribute(1,TP1_E)
	Logic.RemoveTribute(1,TP1_N)
	Logic.RemoveTribute(1,TP1_H)
	--
	MultiplayerTools.GiveBuyableHerosToHumanPlayer( 1 )
	gvDiffLVL = 1.0
	gvChallengeFlag = 1
	--
	XGUIEng.SetText("TopMainMenuTextButton", gvMapText.." @color:255,0,0 HERAUSFORDERUNG @cr "..
		" @color:230,0,240 "..gvMapVersion)
	--
	PrepareForStart()
	--
	for i = 1,2 do
		ForbidTechnology(Technologies.B_Dome, i)
	end
end
function TributeNPC2_1()
	local amount = round(2000 / gvDiffLVL)
	local reward = round(1200 * gvDiffLVL)
	local TrNPC2_1 =  {}
	TrNPC2_1.playerId = 1
	TrNPC2_1.text = "Verkauft ".. amount .." Holz für ".. reward .." Taler"
	TrNPC2_1.cost = {Wood = amount}
	TrNPC2_1.Callback = TributeNPC2_1Payed
	TNPC2_1 = AddTribute(TrNPC2_1)
end
function TributeNPC2_1Payed()
    local briefing = {}
    local AP = function(_page) table.insert(briefing, _page) return _page end

    AP{
        title	= "@color:230,120,0 Langoh Schlitzohrius",
        text	= "@color:230,0,0 Freut mich, mit Euch Geschäfte machen zu können. @cr Handelt gerne weiter mit mir.",
		position = GetPosition("npc2"),
		action = function()
			AddGold(1, round(1200 * gvDiffLVL))
			TributeNPC2_2()
		end
    }

    StartBriefing(briefing)
end
function TributeNPC2_2()
	local amount = round(1200 / gvDiffLVL)
	local reward = round(900 * gvDiffLVL)
	local TrNPC2_2 =  {}
	TrNPC2_2.playerId = 1
	TrNPC2_2.text = "Verkauft ".. amount .." Eisen für ".. reward .." Taler"
	TrNPC2_2.cost = {Iron = amount}
	TrNPC2_2.Callback = TributeNPC2_2Payed
	TNPC2_2 = AddTribute(TrNPC2_2)
end
function TributeNPC2_2Payed()
	AddGold(1, round(900 * gvDiffLVL))
	TributeNPC2_3()
end
function TributeNPC2_3()
	local amount = round(5000 / gvDiffLVL)
	local reward = round(1700 * gvDiffLVL)
	local TrNPC2_3 =  {}
	TrNPC2_3.playerId = 1
	TrNPC2_3.text = "Verkauft ".. amount .." Holz für ".. reward .." Taler"
	TrNPC2_3.cost = {Wood = amount}
	TrNPC2_3.Callback = TributeNPC2_3Payed
	TNPC2_3 = AddTribute(TrNPC2_3)
end
function TributeNPC2_3Payed()
	AddGold(1, round(1700 * gvDiffLVL))
	TributeNPC2_4()
end
function TributeNPC2_4()
	local amount = round(3000 / gvDiffLVL)
	local reward = round(1400 * gvDiffLVL)
	local TrNPC2_4 =  {}
	TrNPC2_4.playerId = 1
	TrNPC2_4.text = "Verkauft ".. amount .." Eisen für ".. reward .." Taler"
	TrNPC2_4.cost = {Iron = amount}
	TrNPC2_4.Callback = TributeNPC2_4Payed
	TNPC2_4 = AddTribute(TrNPC2_4)
end
function TributeNPC2_4Payed()
	AddGold(1, round(1400 * gvDiffLVL))
	TributeNPC2_3()
end
function TributeNPC5()
	local amount = round(10000 / gvDiffLVL)
	local TrNPC5 =  {}
	TrNPC5.playerId = 1
	TrNPC5.text = "Zahlt ".. amount .." Taler, Holz und Eisen, damit Oberkirch eigene Truppen aufstellen kann!"
	TrNPC5.cost = { Gold = amount, Wood = amount, Iron = amount }
	TrNPC5.Callback = TributOberkirchPayedBriefing
	TNPC5 = AddTribute(TrNPC5)
end
function TributOberkirchPayedBriefing()
    local briefing = {}
    local AP = function(_page) table.insert(briefing, _page) return _page end

    AP{
        title	= "@color:230,120,0 Bürgermeister von Oberkirch",
        text	= "@color:230,0,0 Dario! Habt vielen Dank für Eure großzügige Unterstützung!",
		position = GetPosition("npc5")
    }
	    AP{
        title	= "@color:230,120,0 Bürgermeister von Oberkirch",
        text	= "@color:230,0,0 Mit Eurem Geld kann ich endlich Truppen anheuern und das Dorf schützen.",
		position = GetPosition("stables")
    }
	    AP{
        title	= "@color:230,120,0 Bürgermeister von Oberkirch",
        text	= "@color:230,0,0 Wir werden an der Straße den schwarzen Rittern entgegen treten und sie in ihre dunken Höhlen zurückjagen! @cr Ha, das wird ihnen eine Lehre sein!",
		position = GetPosition("deploy1D"),
		action = function()
			MapEditor_SetupAI(4, round(gvDiffLVL), 3500 * gvDiffLVL, round(gvDiffLVL), "village1", round(gvDiffLVL), 0)
			MapEditor_Armies[4].offensiveArmies.strength = MapEditor_Armies[4].offensiveArmies.strength - round(3/gvDiffLVL)
			SetFriendly(1, 4)
			SetFriendly(2, 4)
			SetHostile(4, 6)
		end
    }

    StartBriefing(briefing)
end
function TributeNPC7()
	local amount = round(8000 / gvDiffLVL)
	local TrNPC7 =  {}
	TrNPC7.playerId = 1
	TrNPC7.text = "Zahlt ".. amount .." Taler, damit Euch der alte Mann erzählt, wohin der Dieb gelaufen ist!"
	TrNPC7.cost = { Gold = amount}
	TrNPC7.Callback = TributNPC7PayedBriefing
	TNPC7 = AddTribute(TrNPC7)
end
function TributNPC7PayedBriefing()
    local briefing = {}
    local AP = function(_page) table.insert(briefing, _page) return _page end

    AP{
        title	= "@color:230,120,0 Dubioser Wanderer",
        text	= "@color:230,0,0 Wohin der Dieb gelaufen ist? @cr Wer sagte hier etwas von einem Dieb? @cr Das war bloß so in einer schwarzen Kutte gehüllter Mann.",
		position = GetPosition("npc7")
    }
	    AP{
        title	= "@color:230,120,0 Dubioser Wanderer",
        text	= "@color:230,0,0 Naja, jedenfalls @cr der lief die Berge hoch. @cr Würde mich nicht wundern, wenn der auf dem Weg ein paar Mal den Boden geküsst hat, so schnell ist der gelaufen.",
		position = GetPosition("npc7"),
		action = function()
			CreateThiefs()
			StartSimpleJob("CheckForThiefs")
		end
    }

    StartBriefing(briefing)
end
