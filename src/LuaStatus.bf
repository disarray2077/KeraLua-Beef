using System;

namespace KeraLua
{
    /// Lua Load/Call status return
    public enum LuaStatus : int32
    {
        /// success
        OK =  0,
        /// Yield
        Yield = 1,
        /// a runtime error.
        ErrRun = 2,
        /// syntax error during precompilation
        ErrSyntax = 3,
        /// memory allocation error. For such errors, Lua does not call the message handler.
        ErrMem = 4,
        /// error while running the message handler.
        ErrErr = 5,
    }

	extension LuaStatus
	{
		[Inline]
		public static implicit operator int32(LuaStatus status)
		{
			return status.Underlying;
		}
	}
}