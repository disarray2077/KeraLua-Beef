using System;

namespace KeraLua
{
    /// Whenever a hook is called, its ar argument has its field event set to the specific event that triggered the hook
    public enum LuaHookEvent : int32
    {
        /// The call hook: is called when the interpreter calls a function. The hook is called just after Lua enters the new function, before the function gets its arguments.
        Call = 0,
        /// The return hook: is called when the interpreter returns from a function. The hook is called just before Lua leaves the function. There is no standard way to access the values to be returned by the function.
        Return = 1,
        /// The line hook: is called when the interpreter is about to start the execution of a new line of code, or when it jumps back in the code (even to the same line). (This event only happens while Lua is executing a Lua function.)
        Line = 2,
        /// The count hook: is called after the interpreter executes every count instructions. (This event only happens while Lua is executing a Lua function.)
        Count = 3,
        /// Tail Call
        TailCall = 4,
    }

	extension LuaHookEvent
	{
		[Inline]
		public static implicit operator int32(LuaHookEvent op)
		{
			return op.Underlying;
		}
	}
}