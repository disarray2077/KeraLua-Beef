using System;

namespace KeraLua
{
    /// <summary>
    /// Used by Compare
    /// </summary>
    public enum LuaCompare : int32
    {
        /// <summary>
        ///  compares for equality (==)
        /// </summary>
        Equal = 0,
        /// <summary>
        ///  compares for less than 
        /// </summary>
        LessThen = 1,
        /// <summary>
        /// compares for less or equal 
        /// </summary>
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