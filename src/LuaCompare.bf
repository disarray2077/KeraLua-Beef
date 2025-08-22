using System;

namespace KeraLua
{
    /// Used by Compare
    public enum LuaCompare : int32
    {
        /// compares for equality (==)
        Equal = 0,
        /// compares for less than
        LessThen = 1,
        /// compares for less or equal
        LessOrEqual = 2
    }

	extension LuaCompare
	{
		[Inline]
		public static implicit operator int32(LuaCompare status)
		{
			return status.Underlying;
		}
	}
}