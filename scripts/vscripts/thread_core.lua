--[[
	Basic thread system
	By Azokal
]]

ThreadCore = {}

function ThreadCore:Init()
	self.ThreadTable = {}
	return self
end

function ThreadCore:AddThead(from, amount)
	if self.ThreadTable[from] ~= nil then
		self.ThreadTable[from] = self.ThreadTable[from] + amount
	else
		self.ThreadTable[from] = amount
	end
end

function ThreadCore:GetTopOne()
	local result = 0
	local biggestValue = 0
	for key, value in pairs(self.ThreadTable) do
		if result == 0 then
			result = key
			biggestValue = value
		else
			if value > biggestValue then
				result = key
				biggestValue = value
			end
		end
	end
	return result
end