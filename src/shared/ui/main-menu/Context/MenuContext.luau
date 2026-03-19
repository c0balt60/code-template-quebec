local React = require("@packages/react")
local Sift = require("@packages/sift")

local e = React.createElement
local useState = React.useState
local useCallback = React.useCallback

export type ContextType = {}

local defaultContext: ContextType = {}

local context = React.createContext(defaultContext)

local function MenuContextProvider(props: {
	children: React.ReactNode,
})
	-- Context
	local contextVal: ContextType = {}

	return e(context.Provider, {
		value = contextVal,
	}, props.children)
end

local function useContext()
	return React.createContext(defaultContext)
end

return {
	Context = context,
	Provider = MenuContextProvider,
	useContext = useContext,
}
