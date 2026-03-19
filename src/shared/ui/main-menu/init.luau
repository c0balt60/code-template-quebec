local React = require("@packages/react")
local ReactSpring = require("@packages/react_spring")

local useData = require("@shared/ui/hooks/useData")
local MenuContext = require(script.Context.MenuContext)

local e = React.createElement
local useState = React.useState
local useSpring = ReactSpring.useSpring

type MenuProps = {}

local function MainMenuView(props: MenuProps)
	local data = useData()

	return e("Frame", {
		AnchorPoint = Vector2.new(0.5, 0.5),
		Size = UDim2.fromScale(1, 1),
	})
end

local function MainMenuApp(props: MenuProps)
	return e(MenuContext.Provider, {}, {
		MainMenu = e(MainMenuView, props),
	})
end

return MainMenuApp
