using System;

namespace KeraLua
{
    /// Operation value used by Arith method
    public enum LuaOperation : int32
    {
        /// adition(+)
        Add = 0,
        /// substraction (-)
        Sub = 1,
        /// Multiplication (*)
        Mul = 2,

        /// Modulo (%)
        Mod = 3,

        /// Exponentiation (^)
        Pow = 4,
        /// performs float division (/)
        Div = 5,
        /// performs floor division (//)
        Idiv = 6,
        /// performs bitwise AND
        Band = 7,
        /// performs bitwise OR (|)
        Bor  = 8,
        /// performs bitwise exclusive OR (~)
        Bxor = 9,
        /// performs left shift
        Shl  = 10,
        /// performs right shift
        Shr  = 11,
        /// performs mathematical negation (unary -)
        Unm  = 12,
        /// performs bitwise NOT (~)
        Bnot = 13,
    }

	extension LuaOperation
	{
		[Inline]
		public static implicit operator int32(LuaOperation op)
		{
			return op.Underlying;
		}
	}
}