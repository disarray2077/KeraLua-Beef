using System;
using System.Text;
using System.Diagnostics;

namespace KeraLua
{
	static
	{
		internal static Result<void> GetBytes(this Encoding self, StringView text, out uint8[] bytes)
		{
			int len = self.GetEncodedSize(text);
			bytes = new uint8[len] (?);
			int actualLen = self.Encode(text, .(bytes));

			Debug.Assert(len == actualLen);

			if (len != actualLen)
				return .Err;

			return .Ok;
		}
	}
}
