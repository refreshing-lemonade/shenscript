

memory.usememorydomain("RAM")
--	You can edit any of these variables to be a 0 or 1 depending on what you want
local gamestate = 1
--0 is normal, 1 is training for variable gamestate
local viewhitboxes = 0
local restorehealth = 1
local stunonnext = 0
local dummyalwaysact = 0
--	end of variables you could change
local trialnumber = 1
local playerchar = "none"
local combo = 0
local stunonnextbit = true
local frameadv = 0
local frameadv2 = 0
local p1controller = memory.readbyte(0x00F5)
local playercharhex = memory.readbyte(0x053F)
local p1state = memory.readbyte(0x051C)
local p2state = memory.readbyte(0x061C)
local p1actionable = false
local p2actionable = false
local lastp1state = 0
local lastp2state = 0
local p1statecopy = 0
local p2statecopy = 0
local temp = 0
local viewerselection = 0
local blockstun = 0
local blockstun2 = 0
local a_effective = {1, 2, 3}
local lock = false
local buttons = {}
local record_inputs = {}
for i=1, 3 do
	record_inputs[i] = 0 end
record_inputs[1] = 255
local record_frame = 0
local play_frame = 0
local length_frame = 0

local function hitboxviewer()
--hitbox viewer
	memory.writebyte(0x0555, 1)
	memory.writebyte(0x0655, 1)
	
	temp = 148800 + (memory.readbyte(0x053F) * 80) + (8 * (p1state - 4))
	
	--gel and john are weird and I hate them code
	if memory.readbyte(0x053F) == 128 then
		temp = 148800 + (40 * 80) + (8 * (p1state - 4))
	end
	if memory.readbyte(0x053F) == 129 then
		temp = 148800 + (41 * 80) + (8 * (p1state - 4))
	end
	
	memory.usememorydomain("PRG ROM")
	
	if p1state > 3 and p1state < 14 then
	temp = memory.readbyte(temp)
	end
	if p1state < 4 or p1state > 13 then
	temp = 0
	end
	
	memory.usememorydomain("RAM")
	memory.writebyte(0x554, temp)
	
	temp = 148800 + (memory.readbyte(0x063F) * 80) + (8 * (p2state - 4))
	
	if memory.readbyte(0x063F) == 128 then
		temp = 148800 + (40 * 80) + (8 * (p2state - 4))
	end
	if memory.readbyte(0x063F) == 129 then
		temp = 148800 + (41 * 80) + (8 * (p2state - 4))
	end
	
	memory.usememorydomain("PRG ROM")
	
	if p2state > 3 and p2state < 14 then
	temp = memory.readbyte(temp)
	end
	if p2state < 4 or p2state > 13 then
	temp = 0
	end
	
	memory.usememorydomain("RAM")
	memory.writebyte(0x654, temp)
--menu stuff
	if memory.readbyte(0x00D9) == 0 and memory.readbyte(0x00A0) == 194 and memory.readbyte(0x00F5) == 1 then
		viewerselection = viewerselection + 1
		if viewerselection > 13 then viewerselection = 4 end
	end
	if memory.readbyte(0x00D9) == 0 and memory.readbyte(0x00A0) == 194 and memory.readbyte(0x00F5) == 2 then
		viewerselection = viewerselection - 1
		if viewerselection < 4 then viewerselection = 13 end
	end
	
	if memory.readbyte(0x00D9) == 0 and memory.readbyte(0x00A0) == 194 and p1state == 0 and memory.readbyte(0x051A) == 5 and memory.readbyte(0x051B) == 1 then
			memory.writebyte(0x051D, viewerselection)
	end
	
	if memory.readbyte(0x00D9) == 0 then gui.text(25,95,"You are viewing action state " .. viewerselection) end
	
end

local function commonfunctions()
	p1controller = memory.readbyte(0x00F5)
	playercharhex = memory.readbyte(0x053F)
	p1statecopy = p1state
	p2statecopy = p2state
	p1state = memory.readbyte(0x051C)
	p2state = memory.readbyte(0x061C)
	if p1statecopy ~= p1state then lastp1state = p1statecopy end
	if p2statecopy ~= p2state then lastp2state = p2statecopy end
	p1actionable = false
	p2actionable = false
	if p1state < 4 then p1actionable = true end
	if p1state == 15 and memory.readbyte(0x0524) == 0 then p1actionable = true
	elseif p1state == 3 and lastp1state == 16 then p1actionable = false end
	if p2state < 4 then p2actionable = true end
	if p2state == 15 and memory.readbyte(0x0624) == 0 then p2actionable = true
	elseif p2state == 3 and lastp2state == 16 then p2actionable = false end
	
	
--ALL
	if memory.readbyte(0x00D9) == 58 then
		stunonnextbit = true
		if p1controller == 32 then
			gamestate = gamestate + 1
		end
		if p1controller == 32 and gamestate == 2 then
			gamestate = 0
		end
		
		if p1controller == 64 and stunonnext < 3 then
			stunonnext = stunonnext + 1
			if stunonnext == 3 then
				stunonnext = 0
			end
		end
		if p1controller == 128 then
			viewhitboxes = viewhitboxes + 1
			if viewhitboxes > 1 then viewhitboxes = 0 end
		end
		
		if p1controller == 1 then
			viewerselection = viewerselection + 1
			if viewerselection > 15 then viewerselection = -4 end
		end
		if p1controller == 2 then
			viewerselection = viewerselection - 1
			if viewerselection < -4 then viewerselection = 15 end
		end
		if p1controller == 4 then
			dummyalwaysact = dummyalwaysact + 1
			if dummyalwaysact > 1 then
				dummyalwaysact = 0
			end
		end
		if p1controller == 8 then
			restorehealth = restorehealth + 1
			if restorehealth > 1 then
				restorehealth = 0
			end
		end
	
	end
	
	if gamestate == 0 then
		gui.text(50,30,"Training Setting: OFF")
	end
	if gamestate == 1 then
		gui.text(50,30,"Training Setting: TRAINING")
	end
	if gamestate == 2 then
		gui.text(50,30,"Training Setting: TRIALS")
	end
	
	if gamestate == 0 then
		gui.text(50,60,"    Controls:\nA: Toggle hitboxes. B: Stun settings. Up: Max HP. Down: Reversal setting. \nLeft/Right: P2 action state.")
	else
		if restorehealth == 1 then
		memory.writebyte(0x0529, 88)
		memory.writebyte(0x0629, 88)
		end
		if stunonnext == 1 and stunonnextbit == true then
			memory.writebyte(0x062B, memory.readbyte(0x062C) - 1)
			if memory.readbyte(0x062A) > 0 then
				stunonnextbit = false
			end
		end
		if stunonnext == 2 then
			memory.writebyte(0x052B,0)
			memory.writebyte(0x062B,0)
		end
	end	
	
--training mode
	if gamestate == 1 then
	
	--Dummy/reversal
		if memory.readbyte(0x00D9) == 62 then
			if p2state == 0 and memory.readbyte(0x0624) == 0 and lastp2state == 15 and viewerselection > 3 then
				memory.writebyte(0x061D,viewerselection)
			end
			if p2state == 0 and memory.readbyte(0x0624) == 0 and lastp2state == 16 and viewerselection > 3 then
				memory.writebyte(0x061D,viewerselection)
			end
			
			if p2state == 0 and memory.readbyte(0x0624) == 0 and lastp2state == 3 and viewerselection > 3 and viewerselection ~= 15 then
				memory.writebyte(0x061D,viewerselection)
			end
			if p2state == 0 and memory.readbyte(0x0624) == 0 and dummyalwaysact == 1 and viewerselection > 3 then
				memory.writebyte(0x061D,viewerselection)
			end
			
			if p2state == 0 and viewerselection == -1 and dummyalwaysact == 0 and lastp2state > 14 then
				if memory.readbyte(0x00f6) ~= 130 and memory.readbyte(0x0624) < 2 then
				joypad.set({Left=true, A=true}, 2)
				end
			end
			if p2state == 0 and memory.readbyte(0x0624) == 0 and dummyalwaysact == 1 and viewerselection == -1 then
				if memory.readbyte(0x00f6) ~= 130 and memory.readbyte(0x0624) < 2 then
				joypad.set({Left=true, A=true}, 2)
				end
			end
			if viewerselection == 15 then
				joypad.set({Down=true}, 2)
			end
			if viewerselection == 3 and dummyalwaysact == 1 then
				joypad.set({Up=true}, 2)
			end
			if p2state == 0 and lastp2state > 14 and viewerselection == 3 and memory.readbyte(0x0624) == 0 and dummyalwaysact == 0 then
				if memory.readbyte(0x00f6) ~= 8 and memory.readbyte(0x0624) < 2 then
				joypad.set({Up=true}, 2)
				end
			end
			--recording
			if viewerselection == -2 then
				play_frame = 0
				temp = joypad.get(2)
				record_inputs[record_frame] = temp
				record_frame = record_frame + 1
			end
			--playback
			if (viewerselection == -3 or viewerselection == -4) and (dummyalwaysact == 1 or (dummyalwaysact == 0 and (p2actionable or (not p2actionable and play_frame > 0)))) then
				if record_inputs[play_frame + 1] ~= 255 then
					joypad.set(record_inputs[play_frame], 2)
					play_frame = play_frame + 1
				else
				play_frame = 0
				if viewerselection == -3 then viewerselection = 0 end
				end
			end
			
		else
			play_frame = 0
			if record_frame > 0 and (viewerselection == -3 or viewerselection == -4) then
				record_inputs[record_frame + 1] = 255
				length_frame = record_frame
				record_frame = 0
			end
		end
		
		gui.text(25,430,"Playback: " .. play_frame .. " / " .. length_frame)
		
		if viewerselection == 0 then gui.text(25,200,"Dummy state: Player")
		elseif viewerselection == -1 then gui.text(25,200,"Dummy state: Throw")
		elseif viewerselection == -2 then gui.text(25,200,"Dummy state: RECORDING")
		elseif viewerselection == -3 then gui.text(25,200,"Dummy state: PLAYBACK")
		elseif viewerselection == -4 then gui.text(25,200,"Dummy state: PLAYBACK (loop)")
		elseif viewerselection ~= 0 then gui.text(25,200,"Dummy state: " .. viewerselection) end
		if dummyalwaysact == 1 then gui.text(40,215,"Reversal only: No")
		elseif dummyalwaysact == 0 then gui.text(40,215,"Reversal only: Yes") end
	
	--Restore health
	if restorehealth == 0 then
		gui.text(25,230,"Restore Health: OFF")
		--Display health values
		temp = memory.readbyte(0x0529)
		gui.text(40,245,"Player 1 HP: " .. temp)
		temp = memory.readbyte(0x0629)
		gui.text(40,260,"Player 2 HP: " .. temp)
	elseif restorehealth == 1 then gui.text(25,230,"Restore Health: ON")
	end
		
	--Display stun values
	if stunonnext < 2 then
		temp = memory.readbyte(0x052B)
		gui.text(40,275,"P1 Stun: " .. temp)
		temp = memory.readbyte(0x062B)
		gui.text(40,290,"P2 Stun: " .. temp)
		end
		if restorehealth == 1 then gui.text(25,230,"Restore Health: ON")
	end	
	
	--Blockstun
	temp = memory.readbyte(0x0624)
	gui.text(25,305,"Blockstun/Hitstun: " .. temp)
	if 15 <= memory.readbyte(0x061C) and temp ~= blockstun - 1 and blockstun > 0 then blockstun2 = blockstun end
	gui.text(40,320,"Previous: " .. blockstun2)
	
	--Effective Stun
	temp = memory.readbyte(0x0624)
	
	if memory.readbyte(0x062A) > 0 and lock == false then --if applied damage are nonzero
		a_effective[1] = memory.readbyte(0x062B)
		a_effective[3] = 0
		lock = true
	elseif p1actionable == true and memory.readbyte(0x0624) == 0 and lock == true then
		a_effective[2] = memory.readbyte(0x062B)
		lock = false
		a_effective[3] = a_effective[2] - a_effective[1]
		a_effective[2] = 0
		a_effective[1] = 0
	end
	
	if stunonnext < 2 then
		gui.text(25,335,"Effective stun: " .. a_effective[3])
	end
	
	blockstun = temp
	
	--Charge and motion inputs
	
	gui.text(25,350,"P1 Back Charge: " .. memory.readbyte(0x05A2))
	gui.text(25,365,"P1 Down Charge: " .. memory.readbyte(0x05A3))
	gui.text(40,380,"   [" .. memory.readbyte(0x05A4) .. "]\n[" .. memory.readbyte(0x05A6) .. "]\n   [" .. memory.readbyte(0x05A5) .. "]")
	gui.text(65,380,"\n   [" .. memory.readbyte(0x05A7) .. "]")
	
	--Stop JMF CE timer
		memory.writebyte(0x0042, 59)
	
	--Hitbox viewer
		if viewhitboxes == 0 then gui.text(25,185,"Hitbox Visualizer: OFF")
		elseif viewhitboxes == 1 then gui.text(25,185,"Hitbox Visualizer: ON")
		hitboxviewer()
		end
		
	--Invincibility status
		if memory.readbyte(0x0527) == 1 then gui.text(25,110,"P1 Invincible: True")
		elseif memory.readbyte(0x0527) == 0 then gui.text(25,110,"P1 Invincible: False") end
		if memory.readbyte(0x0627) == 1 then gui.text(25,125,"P2 Invincible: True")
		elseif memory.readbyte(0x0627) == 0 then gui.text(25,125,"P2 Invincible: False") end
	
	--Stun
			--only applies to player 2, player 1 is always normal
		if stunonnext == 0 then
			gui.text(25,170,"Stun: Normal")
		elseif stunonnext == 1 and stunonnextbit == true then
			gui.text(25,170,"Stun: Next Hit (true)")
		elseif stunonnext == 1 and stunonnextbit == false then
			gui.text(25,170,"Stun: Next Hit (false)")
		elseif stunonnext == 2 then
			gui.text(25,170,"Stun: None")
		end
		
	--Scaling Level
		temp = memory.readbyte(0x0629)
		if temp >= 48 then gui.text(25,140,"P1 Scaling Level: 0")
		elseif temp <= 47 and temp > 31 then gui.text(25,140,"P1 Scaling Level: 1")
		elseif temp <= 31 and temp > 15 then gui.text(25,140,"P1 Scaling Level: 2")
		else gui.text(25,140,"P1 Scaling Level: 3") end
		
		temp = memory.readbyte(0x0529)
		if temp >= 48 then gui.text(25,155,"P2 Scaling Level: 0")
		elseif temp <= 47 and temp > 31 then gui.text(25,155,"P2 Scaling Level: 1")
		elseif temp <= 31 and temp > 15 then gui.text(25,155,"P2 Scaling Level: 2")
		else gui.text(25,155,"P2 Scaling Level: 3") end
	
	--Frame Advantage
		--on hit/whiff
		if p1state > 3 and p2state < 4 and p1state ~= 15 then
			if frameadv > 0 then frameadv = 0 end
			frameadv = frameadv - 1
		end
		if p1state < 4 and p2state > 3 and p2state ~= 15 then
			if frameadv < 0 then frameadv = 0 end
			frameadv = frameadv + 1
		end
		if p1state == 16 and p1statecopy ~= 16 then
			if p2state ~= lastp2state and p2state > 3 and p2state < 14 then frameadv = 0 end
			frameadv = 0
		end
		if p2state == 16 and p2statecopy ~= 16 then
			if p1state ~= lastp1state and p1state > 3 and p1state < 14 then frameadv = 0 end
			frameadv = 0
		end
		
		if p2state == 16 and lastp2state ~= 16 and p1state ~= lastp1state and p1state > 3 and p1state < 14 then
			frameadv = 0
		end
		if p1state == 16 and lastp1state ~= 16 and p2state ~= lastp2state and p2state > 3 and p2state < 14 then
			frameadv = 0
		end
		
		if p1actionable == true and p2actionable == false and p1state ~= lastp1state and p2state ~= lastp2state and p1state > 3 and p1state < 14 and p2state > 3 and p2state < 14 then
			frameadv = 0
		end
		if p1actionable == false and p2actionable == true and p1state ~= lastp1state and p2state ~= lastp2state and p1state > 3 and p1state < 14 and p2state > 3 and p2state < 14 then
			frameadv = 0
		end
		
		if p1actionable == false and p2state ~= lastp2state and p2state > 3 and p2state < 14 then
			frameadv = 0
		end
		if p2actionable == false and p1state ~= lastp1state and p1state > 3 and p1state < 14 then
			frameadv = 0
		end
		
		--on block (does not work for moves with 0 blockstun)
		if p1state == 15 and memory.readbyte(0x0524) > 0 and p2state < 4 then
			if frameadv > 0 then frameadv = 0 end
			frameadv = frameadv - 1
		end
		if p2state == 15 and memory.readbyte(0x0624) > 0 and p1state < 4 then
			if frameadv < 0 then frameadv = 0 end
			frameadv = frameadv + 1
		end
		if p2state > 3 and p1state == 15 and p2state ~= 15 and memory.readbyte(0x0524) == 0 then
			if frameadv < 0 then frameadv = 0 end
			frameadv = frameadv + 1
		end
		if p1state > 3 and p2state == 15 and p1state ~= 15 and memory.readbyte(0x0624) == 0 then
			if frameadv > 0 then frameadv = 0 end
			frameadv = frameadv - 1
		end
		
		if memory.readbyte(0x0524) > 0 and p1state == 15 and p2actionable == false then
			frameadv = 0
		end
		if memory.readbyte(0x0624) > 0 and p2state == 15 and p1actionable == false then
			frameadv = 0
		end
		--on non-KD or airborne hit
		if p1state == 3 and lastp1state == 16 then
			if frameadv > 0 then frameadv = 0 end
			frameadv = frameadv - 1
		end
		if p2state == 3 and lastp2state == 16 then
			if frameadv < 0 then frameadv = 0 end
			frameadv = frameadv + 1
		end
		
		
		--conditions to finalize frame advantage
		if p1state < 4 and p2state < 4 and memory.readbyte(0x051F) == 0 and memory.readbyte(0x061F) == 0 and frameadv ~= 0 then
			frameadv2 = frameadv
			frameadv = 0
		end
		if p1state == 15 and p2actionable == true and lastp2state ~= 16 and memory.readbyte(0x0524) == 0 and frameadv ~= 0 then
			frameadv2 = frameadv
			frameadv = 0
		end
		if p1actionable == true and lastp1state ~= 16 and p2state == 15 and memory.readbyte(0x0624) == 0 and frameadv ~= 0 then
			frameadv2 = frameadv
			frameadv = 0
		end
		if p1actionable == true and p2actionable == true and p1statecopy > 3 and p1statecopy ~= 15 and p2statecopy > 3 and p2statecopy ~= 15 and lastp1state ~= 16 and frameadv == 0 then
			frameadv2 = frameadv
			frameadv = 0
		end
		if p1actionable == true and p2actionable == true and p1statecopy > 3 and p1statecopy ~= 15 and p2statecopy > 3 and p2statecopy ~= 15 and lastp2state ~= 16 and frameadv == 0 then
			frameadv2 = frameadv
			frameadv = 0
		end
		
		gui.text(25,80,"P1 frame advantage: " .. frameadv2)
		if memory.readbyte(0x00D9) == 58 and frameadv ~= 0 then
		gui.text(25,95,"Current frame advantage innacurate since you paused")
		end
		
	end
	
--character trial mode
	if memory.readbyte(0x00D9) == 58 then
		playerchar = "none"
		combo = 0
	end
	if memory.readbyte(0x00D9) == 62 then
			if playercharhex == 32 then playerchar = "blaze" end
		end
	
	--memory.writebyte(0x063F, 32)
	--memory.writebyte(0x00b0, 28)
	--memory.writebyte(0x0540, 0)
	--memory.writebyte(0x0640, 0)
	
end

local function trials()
	--ashu loops, wai loops
end

local function chartrials()
	if playerchar == "none"	then
		--gui.text(25,50,"Select a trial")
	end
	--blaze trials
	if playerchar == "blaze" then
		if trialnumber == 1 then
		gui.text(25,50,"Trial 1\nJump Kick (Blocked)\nThrow")
			if combo == 0 then
				joypad.set({Down=true}, 2)
				restorehealth = 1
				if p1state == 7 and memory.readbyte(0x0624) > 0 then
					combo = 1
				end
			end
			if combo == 1 then
				restorehealth = 0
				if memory.readbyte(0x00f6) ~= 130 then
				joypad.set({Left=true, A=true}, 2)
				end
				if p1state == 12 then
				combo = 2
				end
				if memory.readbyte(0x052A) > 0 then
				combo = 0
				end
			end
			if combo == 2 then gui.text(25,25,"COMPLETE!")
			restorehealth = 1
			end
		end
	end
end

while true do
	memory.usememorydomain("RAM")
	commonfunctions()
	if gamestate == 2 then trials() end
	--chartrials() --This is a work in progress
	emu.frameadvance()
end
