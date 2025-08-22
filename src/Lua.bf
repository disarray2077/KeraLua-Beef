using System;
using System.Text;

using internal KeraLua;

namespace KeraLua
{
    /// Lua state class, main interface to use Lua library.
    public class Lua : IDisposable
    {
        private lua_State _luaState;
        private readonly Lua _mainState;

        /// Internal Lua handle pointer.
        public int Handle => _luaState;

        /// Encoding for the string conversions ASCII by default.
        public Encoding Encoding { get; set; }

        /// Returns a pointer to a raw memory area associated with the given Lua state. The application can use this area for any purpose; Lua does not use it for anything. Each new thread has this area initialized with a copy of the area of the main thread.
        public int* ExtraSpace => (int*)(void*)(_luaState - sizeof(int));

        /// Get the main thread object, if the object is the main thread will be equal this
        public Lua MainThread => _mainState ?? this;

        /// Initialize Lua state, and open the default libs
        /// @param openLibs flag to enable/disable opening the default libs
        public this(bool openLibs = true)
        {
            Encoding = System.Text.Encoding.ASCII;

            _luaState = LuaMethods.luaL_newstate();

            if (openLibs)
                OpenLibs();

            SetExtraObject(this, true);
        }

        /// Initialize Lua state with allocator function and user data value This method will NOT open the default libs. Creates a new thread running in a new, independent state. Returns NULL if it cannot create the thread or the state (due to lack of memory). The argument f is the allocator function; Lua does all memory allocation for this state through this function (see lua_Alloc). The second argument, ud, is an opaque pointer that Lua passes to the allocator in every call.
        /// @param allocator LuaAlloc allocator function called to alloc/free memory
        /// @param ud opaque pointer passed to allocator
        public this(LuaAlloc allocator, void* ud)
        {
            Encoding = System.Text.Encoding.ASCII;

            _luaState = LuaMethods.lua_newstate(allocator, ud);

            SetExtraObject(this, true);
        }

        private this(lua_State luaThread, Lua mainState)
        {
            _mainState = mainState;
            _luaState = luaThread;
            Encoding = mainState.Encoding;

            SetExtraObject(this, false);
        }

        /// Get the Lua object from IntPtr Useful for LuaFunction callbacks, if the Lua object was already collected will return null.
        public static Lua FromIntPtr(lua_State luaState)
        {
            if (luaState == 0)
                return null;

            Lua state = GetExtraObject<Lua>(luaState);
            if (state != null && state._luaState == luaState)
                return state;
			
			// Allocation removed from this function
			// If you want to allocate, call the constructor :)
			return null;
        }

        /// Finalizer, will dispose the lua state if wasn't closed
        public ~this()
        {
            Dispose();
        }

        /// Destroys all objects in the given Lua state (calling the corresponding garbage-collection metamethods, if any) and frees all dynamic memory used by this state
        public void Close()
        {
            if (_luaState == 0 || _mainState != null)
                return;

            LuaMethods.lua_close(_luaState);
            _luaState = 0;
        }

        /// Dispose the lua context (calling Close)
        public void Dispose()
        {
            Close();
        }

        private void SetExtraObject<T>(T obj, bool weak) where T : class
        {
            *ExtraSpace = (.)Internal.UnsafeCastToPtr(obj);
        }

        private static T GetExtraObject<T>(lua_State luaState) where T : class
        {
            int* extraSpace = (int*)(void*)(luaState - sizeof(int));
            return (T)Internal.UnsafeCastToObject((void*)*extraSpace);
        }


        /// Converts the acceptable index idx into an equivalent absolute index (that is, one that does not depend on the stack top).
        public int32 AbsIndex(int32 index)
        {
            return LuaMethods.lua_absindex(_luaState, index);
        }
        /// Performs an arithmetic or bitwise operation over the two values (or one, in the case of negations) at the top of the stack, with the value at the top being the second operand, pops these values, and pushes the result of the operation. The function follows the semantics of the corresponding Lua operator (that is, it may call metamethods).
        public void Arith(LuaOperation operation)
        {
            LuaMethods.lua_arith(_luaState, operation);
        }

        /// Sets a new panic function and returns the old one
        public LuaFunction AtPanic(LuaFunction panicFunction)
        {
            return LuaMethods.lua_atpanic(_luaState, panicFunction);
        }

        /// Calls a function. To call a function you must use the following protocol: first, the function to be called is pushed onto the stack; then, the arguments to the function are pushed in direct order; that is, the first argument is pushed first. Finally you call lua_call; nargs is the number of arguments that you pushed onto the stack. All arguments and the function value are popped from the stack when the function is called. The function results are pushed onto the stack when the function returns. The number of results is adjusted to nresults, unless nresults is LUA_MULTRET. In this case, all results from the function are pushed; Lua takes care that the returned values fit into the stack space, but it does not ensure any extra space in the stack. The function results are pushed onto the stack in direct order (the first result is pushed first), so that after the call the last result is on the top of the stack.
        public void Call(int32 arguments, int32 results)
        {
            LuaMethods.lua_callk(_luaState, arguments, results, 0, 0);
        }

        /// This function behaves exactly like lua_call, but allows the called function to yield
        public void CallK(int32 arguments, int32 results, lua_KContext context, LuaKFunction continuation)
        {
            LuaMethods.lua_callk(_luaState, arguments, results, context, continuation);
        }

        /// Ensures that the stack has space for at least n extra slots (that is, that you can safely push up to n values into it). It returns false if it cannot fulfill the request,
        public bool CheckStack(int32 nExtraSlots)
        {
            return LuaMethods.lua_checkstack(_luaState, nExtraSlots) != 0;
        }

        /// Compares two Lua values. Returns 1 if the value at index index1 satisfies op when compared with the value at index index2
        public bool Compare(int32 index1, int32 index2, LuaCompare comparison)
        {
            return LuaMethods.lua_compare(_luaState, index1, index2, comparison) != 0;
        }

        /// Concatenates the n values at the top of the stack, pops them, and leaves the result at the top. If n is 1, the result is the single value on the stack (that is, the function does nothing);
        public void Concat(int32 n)
        {
            LuaMethods.lua_concat(_luaState, n);
        }
        /// Copies the element at index fromidx into the valid index toidx, replacing the value at that position
        public void Copy(int32 fromIndex, int32 toIndex)
        {
            LuaMethods.lua_copy(_luaState, fromIndex, toIndex);
        }

        /// Creates a new empty table and pushes it onto the stack. Parameter narr is a hint for how many elements the table will have as a sequence; parameter nrec is a hint for how many other elements the table will have
        public void CreateTable(int32 elements, int32 records)
        {
            LuaMethods.lua_createtable(_luaState, elements, records);
        }

        /// Dumps a function as a binary chunk. Receives a Lua function on the top of the stack and produces a binary chunk that, if loaded again, results in a function equivalent to the one dumped
        public int32 Dump(LuaWriter writer, void* data, bool stripDebug)
        {
            return LuaMethods.lua_dump(_luaState, writer, data, stripDebug ? 1 : 0);
        }

        /// Generates a Lua error, using the value at the top of the stack as the error object. This function does a long jump (We want it to be inlined to avoid issues with managed stack)
        [Inline, NoReturn]
        public int32 Error()
        {
            return LuaMethods.lua_error(_luaState);
        }

        /// Controls the garbage collector.
        public int32 GarbageCollector(LuaGC what, int32 data)
        {
            return LuaMethods.lua_gc(_luaState, what, data);
        }

        /// Controls the garbage collector.
        /// @param data passed to lua_gc vargs
        /// @param data2 passed to lua_gc vargs
        public int32 GarbageCollector(LuaGC what, int32 data, int32 data2)
        {
            return LuaMethods.lua_gc(_luaState, what, data, data2);
        }

        /// Returns the memory-allocation function of a given state. If ud is not NULL, Lua stores in *ud the opaque pointer given when the memory-allocator function was set.
        public LuaAlloc GetAllocFunction(ref void* ud)
        {
            return LuaMethods.lua_getallocf(_luaState, ref ud);
        }

        /// Pushes onto the stack the value t[k], where t is the value at the given index. As in Lua, this function may trigger a metamethod for the "index" event (see §2.4). Returns the type of the pushed value.
        public LuaType GetField(int32 index, StringView key)
        {
            return (LuaType)LuaMethods.lua_getfield(_luaState, index, key.ToScopeCStr!());
        }

        /// Pushes onto the stack the value t[k], where t is the value at the given index. As in Lua, this function may trigger a metamethod for the "index" event (see §2.4). Returns the type of the pushed value.
        public LuaType GetField(LuaRegistry index, StringView key)
        {
            return (LuaType)LuaMethods.lua_getfield(_luaState, index, key.ToScopeCStr!());
        }

        /// Pushes onto the stack the value of the global name. Returns the type of that value
        public LuaType GetGlobal(StringView name)
        {
            return (LuaType)LuaMethods.lua_getglobal(_luaState, name.ToScopeCStr!());
        }

        /// Pushes onto the stack the value t[i], where t is the value at the given index
        /// @return Returns the type of the pushed value
        public LuaType GetInteger(int32 index, int64 i)
        {
            return (LuaType)LuaMethods.lua_geti(_luaState, index, i);
        }


        /// Gets information about a specific function or function invocation.
        /// @return This function returns false on error (for instance, an invalid option in what).
        public bool GetInfo(StringView what, LuaDebug* ar)
        {
            return LuaMethods.lua_getinfo(_luaState, what.ToScopeCStr!(), (int)(void*)ar) != 0;
        }

        /// Gets information about a specific function or function invocation.
        /// @return This function returns false on error (for instance, an invalid option in what).
        public bool GetInfo(StringView what, ref LuaDebug ar)
        {
            return GetInfo(what, &ar);
        }

        /// Gets information about a local variable of a given activation record or a given function.
        public StringView GetLocal(LuaDebug* ar, int32 n)
        {
            char8* ptr = LuaMethods.lua_getlocal(_luaState, (int)(void*)ar, n);
            return .(ptr);
        }

        /// Gets information about a local variable of a given activation record or a given function.
        public StringView GetLocal(ref LuaDebug ar, int32 n)
        {
            return GetLocal(&ar, n);
        }

        /// If the value at the given index has a metatable, the function pushes that metatable onto the stack and returns 1
        public bool GetMetaTable(int32 index)
        {
            return LuaMethods.lua_getmetatable(_luaState, index) != 0;
        }

        /// Gets information about the interpreter runtime stack.
        public int32 GetStack(int32 level, LuaDebug* ar)
        {
            return LuaMethods.lua_getstack(_luaState, level, (int)(void*)ar);
        }

        /// Gets information about the interpreter runtime stack.
        public int32 GetStack(int32 level, ref LuaDebug ar)
        {
            return GetStack(level, &ar);
        }


        /// Pushes onto the stack the value t[k], where t is the value at the given index and k is the value at the top of the stack.
        /// @return Returns the type of the pushed value
        public LuaType GetTable(int32 index)
        {
            return (LuaType)LuaMethods.lua_gettable(_luaState, index);
        }

        /// Pushes onto the stack the value t[k], where t is the value at the given index and k is the value at the top of the stack.
        /// @return Returns the type of the pushed value
        public LuaType GetTable(LuaRegistry index)
        {
            return (LuaType)LuaMethods.lua_gettable(_luaState, index);
        }


        /// Returns the index of the top element in the stack. 0 means an empty stack.
        /// @return Returns the index of the top element in the stack.
        public int32 GetTop() => LuaMethods.lua_gettop(_luaState);

        /// Pushes onto the stack the n-th user value associated with the full userdata at the given index and returns the type of the pushed value. If the userdata does not have that value, pushes nil and returns LUA_TNONE.
        /// @return Returns the type of the pushed value.
        public int32 GetIndexedUserValue(int32 index, int32 nth) => LuaMethods.lua_getiuservalue(_luaState, index, nth);

        /// Compatibility GetIndexedUserValue with constant 1
        public int32 GetUserValue(int32 index) => GetIndexedUserValue(index, 1);
        /// Gets information about the n-th upvalue of the closure at index funcindex. It pushes the upvalue's value onto the stack and returns its name. Returns NULL (and pushes nothing) when the index n is greater than the number of upvalues. For C functions, this function uses the empty string "" as a name for all upvalues. (For Lua functions, upvalues are the external local variables that the function uses, and that are consequently included in its closure.) Upvalues have no particular order, as they are active through the whole function. They are numbered in an arbitrary order.
        /// @return Returns the type of the pushed value.
        public StringView GetUpValue(int32 functionIndex, int32 n)
        {
            char8* ptr = LuaMethods.lua_getupvalue(_luaState, functionIndex, n);
            return .(ptr);
        }
            
		
        /// Returns the current hook function.
        public LuaHookFunction Hook => LuaMethods.lua_gethook(_luaState);

        /// Returns the current hook count.
        public int32 HookCount => LuaMethods.lua_gethookcount(_luaState);

        /// Returns the current hook mask.
        public LuaHookMask HookMask => (LuaHookMask)LuaMethods.lua_gethookmask(_luaState);

        /// Moves the top element into the given valid index, shifting up the elements above this index to open space. This function cannot be called with a pseudo-index, because a pseudo-index is not an actual stack position.
        public void Insert(int32 index) => LuaMethods.lua_rotate(_luaState, index, 1);

        /// Returns  if the value at the given index is a boolean
        public bool IsBoolean(int32 index) => Type(index) == LuaType.Boolean;

        /// Returns  if the value at the given index is a C(#) function
        public bool IsCFunction(int32 index) => LuaMethods.lua_iscfunction(_luaState, index) != 0;

        /// Returns  if the value at the given index is a function
        public bool IsFunction(int32 index) => Type(index) == LuaType.Function;

        /// Returns  if the value at the given index is an integer
        public bool IsInteger(int32 index) => LuaMethods.lua_isinteger(_luaState, index) != 0;

        /// Returns  if the value at the given index is light user data
        public bool IsLightUserData(int32 index) => Type(index) == LuaType.LightUserData;

        /// Returns  if the value at the given index is nil
        public bool IsNil(int32 index) => Type(index) == LuaType.Nil;

        /// Returns  if the value at the given index is none
        public bool IsNone(int32 index) => Type(index) == LuaType.None;

        /// Check if the value at the index is none or nil
        public bool IsNoneOrNil(int32 index) => IsNone(index) || IsNil(index);

        /// Returns  if the value at the given index is a number
        public bool IsNumber(int32 index) => LuaMethods.lua_isnumber(_luaState, index) != 0;

        /// Returns  if the value at the given index is a string or a number (which is always convertible to a string)
        public bool IsStringOrNumber(int32 index)
        {
            return LuaMethods.lua_isstring(_luaState, index) != 0;
        }

        /// Returns  if the value at the given index is a string NOTE: This is different from the lua_isstring, which return true if the value is a number
        public bool IsString(int32 index) => Type(index) == LuaType.String;

        /// Returns  if the value at the given index is a table.
        public bool IsTable(int32 index) => Type(index) == LuaType.Table;

        /// Returns  if the value at the given index is a thread.
        public bool IsThread(int32 index) => Type(index) == LuaType.Thread;

        /// Returns  if the value at the given index is a user data.
        public bool IsUserData(int32 index) => LuaMethods.lua_isuserdata(_luaState, index) != 0;

        /// Returns  if the given coroutine can yield, and 0 otherwise
        public bool IsYieldable => LuaMethods.lua_isyieldable(_luaState) != 0;

        /// Push the length of the value at the given index on the stack. It is equivalent to the '#' operator in Lua (see §3.4.7) and may trigger a metamethod for the "length" event (see §2.4). The result is pushed on the stack.
        public void PushLength(int32 index) => LuaMethods.lua_len(_luaState, index);

        /// Loads a Lua chunk without running it. If there are no errors, lua_load pushes the compiled chunk as a Lua function on top of the stack. Otherwise, it pushes an error message. The lua_load function uses a user-supplied reader function to read the chunk (see lua_Reader). The data argument is an opaque value passed to the reader function.
        public LuaStatus Load
            (LuaReader reader,
             void* data,
             StringView chunkName,
             StringView mode)
        {
            return (LuaStatus)LuaMethods.lua_load(_luaState,
                                                     reader,
                                                     data,
                                                     chunkName.ToScopeCStr!(),
                                                     mode.ToScopeCStr!());
        }

        /// Creates a new empty table and pushes it onto the stack
        public void NewTable() => LuaMethods.lua_createtable(_luaState, 0, 0);

        /// Creates a new thread, pushes it on the stack, and returns a pointer to a lua_State that represents this new thread. The new thread returned by this function shares with the original thread its global environment, but has an independent execution stack.
        public Lua NewThread()
        {
            lua_State thread = LuaMethods.lua_newthread(_luaState);
            return new Lua(thread, this);
        }

        /// This function creates and pushes on the stack a new full userdata, with nuvalue associated Lua values, called user values, plus an associated block of raw memory with size bytes. (The user values can be set and read with the functions lua_setiuservalue and lua_getiuservalue.) The function returns the address of the block of memory.
        public void* NewIndexedUserData(int32 size, int32 uv)
        {
            return LuaMethods.lua_newuserdatauv(_luaState, (uint) size, uv);
        }

        /// Compatibility NewIndexedUserData with constant parameter
        public void* NewUserData(int32 size)
        {
            return NewIndexedUserData(size, 1);
        }

        /// Pops a key from the stack, and pushes a key–value pair from the table at the given index (the "next" pair after the given key).
        public bool Next(int32 index) => LuaMethods.lua_next(_luaState, index) != 0;

        /// Calls a function in protected mode.
        public LuaStatus PCall(int32 arguments, int32 results, int32 errorFunctionIndex)
        {
            return (LuaStatus)LuaMethods.lua_pcallk(_luaState, arguments, results, errorFunctionIndex, 0, 0);
        }

        /// This function behaves exactly like lua_pcall, but allows the called function to yield
        public LuaStatus PCallK(int32 arguments,
            int32 results,
            int32 errorFunctionIndex,
            int32 context,
            LuaKFunction k)
        {
            return (LuaStatus)LuaMethods.lua_pcallk(_luaState,
                arguments,
                results,
                errorFunctionIndex,
                (lua_KContext)context,
                k);
        }

        /// Pops n elements from the stack.
        public void Pop(int32 n) => LuaMethods.lua_settop(_luaState, -n - 1);

        /// Pushes a boolean value with value b onto the stack.
        public void PushBoolean(bool b) => LuaMethods.lua_pushboolean(_luaState, b ? 1 : 0);

        /// Pushes a new C closure onto the stack. When a C function is created, it is possible to associate some values with it, thus creating a C closure (see §4.4); these values are then accessible to the function whenever it is called. To associate values with a C function, first these values must be pushed onto the stack (when there are multiple values, the first value is pushed first). Then lua_pushcclosure is called to create and push the C function onto the stack, with the argument n telling how many values will be associated with the function. lua_pushcclosure also pops these values from the stack.
        public void PushCClosure(LuaFunction func, int32 n)
        {
            LuaMethods.lua_pushcclosure(_luaState, func, n);
        }

        /// Pushes a C function onto the stack. This function receives a pointer to a C function and pushes onto the stack a Lua value of type function that, when called, invokes the corresponding C function.
        public void PushCFunction(LuaFunction func)
        {
            PushCClosure(func, 0);
        }

        /// Pushes the global environment onto the stack.
        public void PushGlobalTable()
        {
            LuaMethods.lua_rawgeti(_luaState, LuaRegistry.Index, (.)LuaRegistryIndex.Globals);
        }
        /// Pushes an integer with value n onto the stack.
        public void PushInteger(int64 n) => LuaMethods.lua_pushinteger(_luaState, n);

        /// Pushes a light userdata onto the stack. Userdata represent C values in Lua. A light userdata represents a pointer, a void*. It is a value (like a number): you do not create it, it has no individual metatable, and it is not collected (as it was never created). A light userdata is equal to "any" light userdata with the same C address.
        public void PushLightUserData(void* data)
        {
            LuaMethods.lua_pushlightuserdata(_luaState, data);
        }

        /// Pushes a reference data (Beef object)  onto the stack. This function uses lua_pushlightuserdata, but uses a GCHandle to store the reference inside the Lua side. The CGHandle is create as Normal, and will be freed when the value is pop
        public void PushObject<T>(T obj)
        {
            if(obj == null)
            {
                PushNil();
                return;
            }

            PushLightUserData(Internal.UnsafeCastToPtr(obj));
        }


        /// Pushes binary buffer onto the stack (usually UTF encoded string) or any arbitraty binary data
        public void PushBuffer(uint8[] buffer)
        {
            if(buffer == null)
            {
                PushNil();
                return;
            }

            LuaMethods.lua_pushlstring(_luaState, (.)buffer.Ptr, (.)buffer.Count);
        }
		
		/// Pushes binary buffer onto the stack (usually UTF encoded string) or any arbitraty binary data
		public void PushBuffer<CSize>(uint8[CSize] buffer) where CSize : const int
        {
#unwarn
            LuaMethods.lua_pushlstring(_luaState, (.)&buffer[0], (.)CSize);
        }

        /// Pushes a string onto the stack
        public void PushString(String value)
        {
            if(value == null)
            {
                PushNil();
                return;
            }

            uint8[] buffer = Encoding.GetBytes(value, .. ?);
            PushBuffer(buffer);
			delete buffer;
        }

        /// Pushes a string onto the stack
        public void PushString(StringView value)
        {
            uint8[] buffer = Encoding.GetBytes(value, .. ?);
            PushBuffer(buffer);
			delete buffer;
        }

        /// Push a instring using string.Format PushString("Foo {0}", 10);
        public void PushString(String value, params Object[] args)
        {
            PushString(scope String()..AppendF(value, params args));
        }

        /// Pushes a nil value onto the stack.
        public void PushNil() => LuaMethods.lua_pushnil(_luaState);

        /// Pushes a double with value n onto the stack.
        public void PushNumber(double number) => LuaMethods.lua_pushnumber(_luaState, number);

        /// Pushes the thread represented by L onto the stack. Returns true if this thread is the main thread of its state.
        public bool PushThread(Lua thread)
        {
            return LuaMethods.lua_pushthread(_luaState) == 1;
        }

		/// Pushes a copy of the element at the given index onto the stack. (lua_pushvalue)
		public void PushValue(int32 index)
		{
		    LuaMethods.lua_pushvalue(_luaState, index);
		}

        /// Returns true if the two values in indices index1 and index2 are primitively equal (that is, without calling the __eq metamethod). Otherwise returns false. Also returns false if any of the indices are not valid.
        public bool RawEqual(int32 index1, int32 index2)
        {
            return LuaMethods.lua_rawequal(_luaState, index1, index2) != 0;
        }

        /// Similar to GetTable, but does a raw access (i.e., without metamethods).
        /// @return Returns the type of the pushed value
        public LuaType RawGet(int32 index)
        {
            return (LuaType)LuaMethods.lua_rawget(_luaState, index);
        }

        /// Similar to GetTable, but does a raw access (i.e., without metamethods).
        /// @return Returns the type of the pushed value
        public LuaType RawGet(LuaRegistry index)
        {
            return (LuaType)LuaMethods.lua_rawget(_luaState, index);
        }

        /// Pushes onto the stack the value t[n], where t is the table at the given index. The access is raw, that is, it does not invoke the __index metamethod.
        /// @return Returns the type of the pushed value
        public LuaType RawGetInteger(int32 index, int64 n)
        {
            return (LuaType)LuaMethods.lua_rawgeti(_luaState, index, n);
        }

        /// Pushes onto the stack the value t[n], where t is the table at the given index. The access is raw, that is, it does not invoke the __index metamethod.
        public LuaType RawGetInteger(LuaRegistry index, int64 n)
        {
            return (LuaType)LuaMethods.lua_rawgeti(_luaState, index, n);
        }


        /// Pushes onto the stack the value t[k], where t is the table at the given index and k is the pointer p represented as a light userdata. The access is raw; that is, it does not invoke the __index metamethod.
        /// @return Returns the type of the pushed value.
        public LuaType RawGetByHashCode<T>(int32 index, T obj) where T : IHashable
        {
            return (LuaType)LuaMethods.lua_rawgetp(_luaState, index, (void*)obj.GetHashCode());
        }

        /// Returns the raw "length" of the value at the given index: for strings, this is the string length; for tables, this is the result of the length operator ('#') with no metamethods; for userdata, this is the size of the block of memory allocated for the userdata; for other values, it is 0.
        public int32 RawLen(int32 index)
        {
            return (int32)LuaMethods.lua_rawlen(_luaState, index);
        }

        /// Similar to lua_settable, but does a raw assignment (i.e., without metamethods).
        public void RawSet(int32 index)
        {
            LuaMethods.lua_rawset(_luaState, index);
        }

        /// Similar to lua_settable, but does a raw assignment (i.e., without metamethods).
        public void RawSet(LuaRegistry index)
        {
            LuaMethods.lua_rawset(_luaState, index);
        }

        /// Does the equivalent of t[i] = v, where t is the table at the given index and v is the value at the top of the stack. This function pops the value from the stack. The assignment is raw, that is, it does not invoke the __newindex metamethod.
        /// @param index index of table
        /// @param i value
        public void RawSetInteger(int32 index, int64 i)
        {
            LuaMethods.lua_rawseti(_luaState, index, i);
        }

        /// Does the equivalent of t[i] = v, where t is the table at the given index and v is the value at the top of the stack. This function pops the value from the stack. The assignment is raw, that is, it does not invoke the __newindex metamethod.
        public void RawSetInteger(LuaRegistry index, int64 i)
        {
            LuaMethods.lua_rawseti(_luaState, index, i);
        }


        /// Does the equivalent of t[p] = v, where t is the table at the given index, p is encoded as a light userdata, and v is the value at the top of the stack.
        public void RawSetByHashCode<T>(int32 index, T obj) where T : IHashable
        {
            LuaMethods.lua_rawsetp(_luaState, index, (void*)obj.GetHashCode());
        }

        /// Sets the Beef function f as the new value of global name
        public void Register(StringView name, LuaFunction func)
        {
            PushCFunction(func);
            SetGlobal(name);
        }


        /// Removes the element at the given valid index, shifting down the elements above this index to fill the gap. This function cannot be called with a pseudo-index, because a pseudo-index is not an actual stack position.
        public void Remove(int32 index)
        {
            Rotate(index, -1);
            Pop(1);
        }

        /// Moves the top element into the given valid index without shifting any element (therefore replacing the value at that given index), and then pops the top element.
        public void Replace(int32 index)
        {
            Copy(-1, index);
            Pop(1);
        }

        /// Starts and resumes a coroutine in the given thread L. To start a coroutine, you push onto the thread stack the main function plus any arguments; then you call lua_resume, with nargs being the number of arguments.This call returns when the coroutine suspends or finishes its execution. When it returns, * nresults is updated and the top of the stack contains the* nresults values passed to lua_yield or returned by the body function. lua_resume returns LUA_YIELD if the coroutine yields, LUA_OK if the coroutine finishes its execution without errors, or an error code in case of errors (see lua_pcall). In case of errors, the error object is on the top of the stack. To resume a coroutine, you clear its stack, push only the values to be passed as results from yield, and then call lua_resume. The parameter from represents the coroutine that is resuming L. If there is no such coroutine, this parameter can be NULL.
        public LuaStatus Resume(Lua from, int32 arguments, out int32 results)
        {
            return (LuaStatus)LuaMethods.lua_resume(_luaState, from?._luaState ?? 0, arguments, out results);
        }

        /// Compatibility Resume without results.
        public LuaStatus Resume(Lua from, int32 arguments)
        {
            int32 ignore;
            return (LuaStatus)LuaMethods.lua_resume(_luaState, from?._luaState ?? 0, arguments, out ignore);
        }

        /// Resets a thread, cleaning its call stack and closing all pending to-be-closed variables. Returns a status code: LUA_OK for no errors in closing methods, or an error status otherwise. In case of error, leaves the error object on the top of the stack,
        public int32 ResetThread()
        {
            return LuaMethods.lua_resetthread(_luaState);
        }

        /// Rotates the stack elements between the valid index idx and the top of the stack. The elements are rotated n positions in the direction of the top, for a positive n, or -n positions in the direction of the bottom, for a negative n. The absolute value of n must not be greater than the size of the slice being rotated. This function cannot be called with a pseudo-index, because a pseudo-index is not an actual stack position.
        public void Rotate(int32 index, int32 n)
        {
            LuaMethods.lua_rotate(_luaState, index, n);
        }

        /// Changes the allocator function of a given state to f with user data ud.
        public void SetAllocFunction(LuaAlloc alloc, ref void* ud)
        {
            LuaMethods.lua_setallocf(_luaState, alloc, ud);
        }

        /// Does the equivalent to t[k] = v, where t is the value at the given index and v is the value at the top of the stack.
        public void SetField(int32 index, StringView key)
        {
            LuaMethods.lua_setfield(_luaState, index, key.ToScopeCStr!());
        }

        /// Sets the debugging hook function.  Argument f is the hook function. mask specifies on which events the hook will be called: it is formed by a bitwise OR of the constants
        /// @param hookFunction Hook function callback
        /// @param mask hook mask
        /// @param count count (used only with LuaHookMas.Count)
        public void SetHook(LuaHookFunction hookFunction, LuaHookMask mask, int32 count)
        {
            LuaMethods.lua_sethook(_luaState, hookFunction, mask, count);
        }

        /// Pops a value from the stack and sets it as the new value of global name.
        public void SetGlobal(StringView name)
        {
            LuaMethods.lua_setglobal(_luaState, name.ToScopeCStr!());
        }

        /// Does the equivalent to t[n] = v, where t is the value at the given index and v is the value at the top of the stack.
        public void SetInteger(int32 index, int64 n)
        {
            LuaMethods.lua_seti(_luaState, index, n);
        }

        /// Sets the value of a local variable of a given activation record. It assigns the value at the top of the stack to the variable and returns its name. It also pops the value from the stack.
        /// @return Returns NULL (and pops nothing) when the index is greater than the number of active local variables.
        public StringView SetLocal(LuaDebug* ar, int32 n)
        {
            char8* ptr = LuaMethods.lua_setlocal(_luaState, (int)(void*)ar, n);
            return .(ptr);
        }

        /// Sets the value of a local variable of a given activation record. It assigns the value at the top of the stack to the variable and returns its name. It also pops the value from the stack.
        /// @return Returns NULL (and pops nothing) when the index is greater than the number of active local variables.
        public StringView SetLocal(ref LuaDebug ar, int32 n)
        {
            return SetLocal(&ar, n);
        }

        /// Pops a table from the stack and sets it as the new metatable for the value at the given index.
        public void SetMetaTable(int32 index)
        {
            LuaMethods.lua_setmetatable(_luaState, index);
        }

        /// Does the equivalent to t[k] = v, where t is the value at the given index, v is the value at the top of the stack, and k is the value just below the top
        public void SetTable(int32 index)
        {
            LuaMethods.lua_settable(_luaState, index);
        }

        /// Accepts any index, or 0, and sets the stack top to this index. If the new top is larger than the old one, then the new elements are filled with nil. If index is 0, then all stack elements are removed.
        public void SetTop(int32 newTop)
        {
            LuaMethods.lua_settop(_luaState, newTop);
        }

        /// Sets the value of a closure's upvalue. It assigns the value at the top of the stack to the upvalue and returns its name. It also pops the value from the stack.
        /// @return Returns NULL (and pops nothing) when the index n is greater than the number of upvalues.
        public StringView SetUpValue(int32 functionIndex, int32 n)
        {
            char8* ptr = LuaMethods.lua_setupvalue(_luaState, functionIndex, n);
            return .(ptr);
        }

        /// Sets the warning function to be used by Lua to emit warnings (see lua_WarnFunction). The ud parameter sets the value ud passed to the warning function.
        public void SetWarningFunction(LuaWarnFunction func, void* userData)
        {
            LuaMethods.lua_setwarnf(_luaState, func, userData);
        }

        /// Pops a value from the stack and sets it as the new n-th user value associated to the full userdata at the given index. Returns 0 if the userdata does not have that value.
        public void SetIndexedUserValue(int32 index, int32 nth)
        {
            LuaMethods.lua_setiuservalue(_luaState, index, nth);
        }

        /// Compatibility SetIndexedUserValue with constant 1
        public void SetUserValue(int32 index) => SetIndexedUserValue(index, 1);

        /// The status can be 0 (LUA_OK) for a normal thread, an error code if the thread finished the execution of a lua_resume with an error, or LUA_YIELD if the thread is suspended. You can only call functions in threads with status LUA_OK. You can resume threads with status LUA_OK (to start a new coroutine) or LUA_YIELD (to resume a coroutine).
        public LuaStatus Status => (LuaStatus)LuaMethods.lua_status(_luaState);

        /// Converts the zero-terminated string s to a number, pushes that number into the stack,
        public bool StringToNumber(StringView s)
        {
            return LuaMethods.lua_stringtonumber(_luaState, s.ToScopeCStr!()) != 0;
        }

        /// Converts the Lua value at the given index to a Beef boolean value
        public bool ToBoolean(int32 index)
        {
            return LuaMethods.lua_toboolean(_luaState, index) != 0;
        }

        /// Converts a value at the given index to a Beef function. That value must be a Beef function; otherwise, returns NULL
        public LuaFunction ToCFunction(int32 index)
        {
            return LuaMethods.lua_tocfunction(_luaState, index);
        }

        /// Marks the given index in the stack as a to-be-closed "variable" (see §3.3.8). Like a to-be-closed variable in Lua, the value at that index in the stack will be closed when it goes out of scope. Here, in the context of a C function, to go out of scope means that the running function returns to Lua, there is an error, or the index is removed from the stack through lua_settop or lua_pop. An index marked as to-be-closed should not be removed from the stack by any other function in the API except lua_settop or lua_pop. This function should not be called for an index that is equal to or below an already marked to-be-closed index. This function can raise an out-of-memory error. In that case, the value in the given index is immediately closed, as if it was already marked.
        public void ToClose(int32 index)
        {
            LuaMethods.lua_toclose(_luaState, index);
        }

        /// Converts the Lua value at the given index to the signed integral type lua_Integer. The Lua value must be an integer, or a number or string convertible to an integer (see §3.4.3); otherwise, lua_tointegerx returns 0.
        public int64 ToInteger(int32 index)
        {
            int32 isNum;
            return LuaMethods.lua_tointegerx(_luaState, index, out isNum);
        }

        /// Converts the Lua value at the given index to the signed integral type lua_Integer. The Lua value must be an integer, or a number or string convertible to an integer (see §3.4.3); otherwise, lua_tointegerx returns 0.
        public int64? ToIntegerX(int32 index)
        {
            int32 isInteger;
            int64 value = LuaMethods.lua_tointegerx(_luaState, index, out isInteger);
            if(isInteger != 0)
                return value;
            return null;
        }

        /// Converts the Lua value at the given as byte array
        public void ToBuffer(int32 index, out uint8[] buffer)
        {
            ToBuffer(index, true, out buffer);
        }

        /// Converts the Lua value at the given index to a byte array.
        /// @param callMetamethod Calls __tostring field if present
        public void ToBuffer(int32 index, bool callMetamethod, out uint8[] buffer)
        {
            uint len;
            char8* buff;

            if (callMetamethod)
            {
                buff = LuaMethods.luaL_tolstring(_luaState, index, out len);
                Pop(1);
            }
            else
            {
                buff = LuaMethods.lua_tolstring(_luaState, index, out len);
            }

            if(buff == null)
			{
                buffer = null;
				return;
			}

            int length = (int)len;
            if(length == 0)
			{
                buffer = new uint8[0];
				return;
			}

            buffer = new uint8[length];
            Internal.MemCpy(buffer.Ptr, buff, length);
        }

		/// Converts the Lua value at the given index to a Beef StringView (no encoding is done) ToStringView returns a StringView to a string inside the Lua state. This string always has a zero ('\0') after its last character (as in C), but can contain other zeros in its body. Because Lua has garbage collection, there is no guarantee that the pointer returned by ToStringView will be valid after the corresponding value is removed from the stack.
		public StringView ToStringView(int32 index, bool callMetamethod = true)
		{
			uint len;
			char8* buff;

			if (callMetamethod)
			{
			    buff = LuaMethods.luaL_tolstring(_luaState, index, out len);
			    Pop(1);
			}
			else
			{
			    buff = LuaMethods.lua_tolstring(_luaState, index, out len);
			}

			return StringView(buff, (.)len);
		}

        /// Converts the Lua value at the given index to a Beef string
        public void ToString(int32 index, String outString)
        {
            ToString(index, true, outString);
        }

        /// Converts the Lua value at the given index to a Beef string
        /// @param callMetamethod Calls __tostring field if present
        public void ToString(int32 index, bool callMetamethod, String outString)
        {
            uint len;
			char8* buff;

			if (callMetamethod)
			{
			    buff = LuaMethods.luaL_tolstring(_luaState, index, out len);
			    Pop(1);
			}
			else
			{
			    buff = LuaMethods.lua_tolstring(_luaState, index, out len);
			}

			if(buff == null)
			{
			    outString.Clear();
				return;
			}

			int length = (int)len;
			if(length == 0)
			{
			    outString.Clear();
				return;
			}

			Encoding.DecodeToUTF8(Span<uint8>((.)buff, length), outString);
        }

        /// Converts the Lua value at the given index to a Beef double
        public double ToNumber(int32 index)
        {
            int32 isNum;
            return LuaMethods.lua_tonumberx(_luaState, index, out isNum);
        }

        /// Converts the Lua value at the given index to a Beef double?
        public double? ToNumberX(int32 index)
        {
            int32 isNumber;
            double value = LuaMethods.lua_tonumberx(_luaState, index, out isNumber);
            if(isNumber != 0)
                return value;
            return null;
        }

        /// Converts the value at the given index to a generic C pointer (void*). The value can be a userdata, a table, a thread, or a function; otherwise, lua_topointer returns NULL. Different objects will give different pointers. There is no way to convert the pointer back to its original value. Typically this function is used only for hashing and debug information.
        public void* ToPointer(int32 index)
        {
            return LuaMethods.lua_topointer(_luaState, index);
        }


        /// Converts the value at the given index to a Lua thread or return the self if is the main thread
        public Lua ToThread(int32 index)
        {
            lua_State state = LuaMethods.lua_tothread(_luaState, index);
            if(state == _luaState)
                return this;

            return FromIntPtr(state);
        }

        /// Return an object (refence) at the index
        public T ToObject<T>(int32 index)
        {
            if(IsNil(index) || !IsLightUserData(index))
                return default(T);

            void* data = ToUserData(index);
            if(data == null)
                return default(T);

            return (.)Internal.UnsafeCastToObject(data);
        }

        /// If the value at the given index is a full userdata, returns its block address. If the value is a light userdata, returns its pointer. Otherwise, returns NULL
        public void* ToUserData(int32 index)
        {
            return LuaMethods.lua_touserdata(_luaState, index);
        }


        public LuaType Type(int32 index)
        {
            return (LuaType)LuaMethods.lua_type(_luaState, index);
        }

        /// Returns the name of the type of the value at the given index.
        /// @return Name of the type of the value at the given index
        public StringView TypeName(LuaType type)
        {
            char8* ptr = LuaMethods.lua_typename(_luaState, type);
            return .(ptr);
        }

        /// Returns a unique identifier for the upvalue numbered n from the closure at index funcindex.
        public int64 UpValueId(int32 functionIndex, int32 n)
        {
            return (int64)(int)LuaMethods.lua_upvalueid(_luaState, functionIndex, n);
        }

        /// Returns the pseudo-index that represents the i-th upvalue of the running function
		[Inline]
        public static int32 UpValueIndex(int32 i)
        {
            return (int32)LuaRegistry.Index - i;
        }

        /// Make the n1-th upvalue of the Lua closure at index funcindex1 refer to the n2-th upvalue of the Lua closure at index funcindex2
        public void UpValueJoin(int32 functionIndex1, int32 n1, int32 functionIndex2, int32 n2)
        {
            LuaMethods.lua_upvaluejoin(_luaState, functionIndex1, n1, functionIndex2, n2);
        }

        /// Return the version of Lua (e.g 504)
        public double Version()
        {
            return LuaMethods.lua_version(_luaState);
        }

        /// Exchange values between different threads of the same state. This function pops n values from the current stack, and pushes them onto the stack to.
        public void XMove(Lua to, int32 n)
        {
            LuaMethods.lua_xmove(_luaState, to._luaState, n);
        }

        /// This function is equivalent to lua_yieldk, but it has no continuation (see §4.7). Therefore, when the thread resumes, it continues the function that called the function calling lua_yield.
        public int32 Yield(int32 results)
        {
            return LuaMethods.lua_yieldk(_luaState, results, 0, 0);
        }

        /// Yields a coroutine (thread). When a C function calls lua_yieldk, the running coroutine suspends its execution, and the call to lua_resume that started this coroutine returns
        /// @param results Number of values from the stack that will be passed as results to lua_resume.
        public int32 YieldK(int32 results, lua_KContext context, LuaKFunction continuation)
        {
            return LuaMethods.lua_yieldk(_luaState, results, context, continuation);
        }

        /* Auxialiary Library Functions */

        /// Checks whether cond is true. If it is not, raises an error with a standard message
        public void ArgumentCheck(bool condition, int32 argument, StringView message)
        {
            if (condition)
                return;
            ArgumentError(argument, message);
        }

        /// Raises an error reporting a problem with argument arg of the C function that called it, using a standard message that includes extramsg as a comment:
        public int32 ArgumentError(int32 argument, StringView message)
        {
            return LuaMethods.luaL_argerror(_luaState, argument, message.ToScopeCStr!());
        }

        /// If the object at index obj has a metatable and this metatable has a field e, this function calls this field passing the object as its only argument.
        /// @return If there is no metatable or no metamethod, this function returns false (without pushing any value on the stack)
        public bool CallMetaMethod(int32 obj, StringView field)
        {
            return LuaMethods.luaL_callmeta(_luaState, obj, field.ToScopeCStr!()) != 0;
        }

        /// Checks whether the function has an argument of any type (including nil) at position arg.
        public void CheckAny(int32 argument)
        {
            LuaMethods.luaL_checkany(_luaState, argument);
        }

        /// Checks whether the function argument arg is an integer (or can be converted to an integer)
        public int64 CheckInteger(int32 argument)
        {
            return LuaMethods.luaL_checkinteger(_luaState, argument);
        }
		// TODO
		/*
        /// Checks whether the function argument arg is a string and returns this string;
        public byte[] CheckBuffer(int32 argument)
        {
            UIntPtr len;
            IntPtr buff = NativeMethods.luaL_checklstring(_luaState, argument, out len);
            if (buff == 0)
                return null;

            int32 length = (int)len;
            if(length == 0)
                return new byte[0];

            byte[] output = new byte[length];
            Marshal.Copy(buff, output, 0, length);
            return output;
        }

        /// Checks whether the function argument arg is a string and returns this string;
        public string CheckString(int32 argument)
        {
            byte[] buffer = CheckBuffer(argument);
            if(buffer == null)
                return null;
            return Encoding.GetString(buffer);
        }

        /// Checks whether the function argument arg is a number and returns this number.
        public double CheckNumber(int32 argument)
        {
            return NativeMethods.luaL_checknumber(_luaState, argument);
        }


        /// Checks whether the function argument arg is a string and searches for this string in the array lst
        public int32 CheckOption(int32 argument, string def, string[] list)
        {
            return NativeMethods.luaL_checkoption(_luaState, argument, def, list);
        }


        /// Grows the stack size to top + sz elements, raising an error if the stack cannot grow
        public void CheckStack(int32 newSize, string message)
        {
            NativeMethods.luaL_checkstack(_luaState, newSize, message);
        }

        /// Checks whether the function argument arg has type type
        public void CheckType(int32 argument, LuaType type)
        {
            NativeMethods.luaL_checktype(_luaState, argument, (int)type);
        }

        /// Checks whether the function argument arg is a userdata of the type tname
        /// @param freeGCHandle True to release the GCHandle
        public T CheckObject<T>(int32 argument, string typeName, bool freeGCHandle = true)
        {
            if(IsNil(argument) || !IsLightUserData(argument))
                return default(T);

            IntPtr data = CheckUserData(argument, typeName);
            if(data == 0)
                return default(T);

            var handle = GCHandle.FromIntPtr(data);
            if(!handle.IsAllocated)
                return default(T);

            var reference = (T)handle.Target;

            if(freeGCHandle)
                handle.Free();

            return reference;
        }

        /// Checks whether the function argument arg is a userdata of the type tname (see luaL_newmetatable) and returns the userdata address
        public IntPtr CheckUserData(int32 argument, string typeName)
        {
            return NativeMethods.luaL_checkudata(_luaState, argument, typeName);
        }
		*/
        /// Loads and runs the given file
        /// @return It returns false if there are no errors or true in case of errors.
        public bool DoFile(StringView file)
        {
            bool hasError = LoadFile(file) != LuaStatus.OK || PCall(0, -1, 0) != LuaStatus.OK;
            return hasError;
        }

        /// Loads and runs the given string
        /// @return It returns false if there are no errors or true in case of errors.
        public bool DoString(StringView file)
        {
            bool hasError = LoadString(file) != LuaStatus.OK || PCall(0, -1, 0) != LuaStatus.OK;
            return hasError;
        }

        /// Raises an error. The error message format is given by fmt plus any extra arguments
        public int32 Error(StringView value, params Object[] v)
        {
            String message = scope String()..AppendF(value, params v);
            return LuaMethods.luaL_error(_luaState, message.CStr());
        }

        /// This function produces the return values for process-related functions in the standard library
        public int32 ExecResult(int32 stat)
        {
            return LuaMethods.luaL_execresult(_luaState, stat);
        }

        /// This function produces the return values for file-related functions in the standard library
        public int32 FileResult(int32 stat, StringView fileName)
        {
            return LuaMethods.luaL_fileresult(_luaState, stat, fileName.ToScopeCStr!());
        }

        /// Pushes onto the stack the field e from the metatable of the object at index obj and returns the type of the pushed value
        public LuaType GetMetaField(int32 obj, StringView field)
        {
            return (LuaType)LuaMethods.luaL_getmetafield(_luaState, obj, field.ToScopeCStr!());
        }

        /// Pushes onto the stack the metatable associated with name tname in the registry (see luaL_newmetatable) (nil if there is no metatable associated with that name)
        /// @return Returns the type of the pushed value.
        public LuaType GetMetaTable(StringView tableName)
        {
            return GetField(LuaRegistry.Index, tableName);
        }

        /// Ensures that the value t[fname], where t is the value at index idx, is a table, and pushes that table onto the stack. Returns true if it finds a previous table there and false if it creates a new table
        public bool GetSubTable(int32 index, StringView name)
        {
            return LuaMethods.luaL_getsubtable(_luaState, index, name.ToScopeCStr!()) != 0;
        }

        /// Returns the "length" of the value at the given index as a number; it is equivalent to the '#' operator in Lua
        public int64 Length(int32 index) => LuaMethods.luaL_len(_luaState, index);
		
        /// Loads a buffer as a Lua chunk
        public LuaStatus LoadBuffer(uint8[] buffer, StringView? name, StringView? mode)
        {
            return (LuaStatus)LuaMethods.luaL_loadbufferx(_luaState, (.)buffer.Ptr, (uint)buffer.Count, name?.ToScopeCStr!() ?? null, mode?.ToScopeCStr!() ?? null);
        }

        /// Loads a buffer as a Lua chunk
        public LuaStatus LoadBuffer(uint8[] buffer, String name, String mode)
        {
            return (LuaStatus)LuaMethods.luaL_loadbufferx(_luaState, (.)buffer.Ptr, (uint)buffer.Count, name?.CStr() ?? null, mode?.CStr() ?? null);
        }

        public LuaStatus LoadBuffer(uint8[] buffer, StringView? name)
        {
            return LoadBuffer(buffer, name, null);
        }

        public LuaStatus LoadBuffer(uint8[] buffer, String name)
        {
            return LoadBuffer(buffer, name, null);
        }

        /// Loads a buffer as a Lua chunk
        public LuaStatus LoadBuffer(uint8[] buffer)
        {
            return LoadBuffer(buffer, (String)null, (String)null);

        }

        /// Loads a string as a Lua chunk
        public LuaStatus LoadString(StringView chunk, StringView? name)
        {
            uint8[] buffer = Encoding.GetBytes(chunk, .. ?);
            var status = LoadBuffer(buffer, name);
			delete buffer;
			return status;
        }

        /// Loads a string as a Lua chunk
        public LuaStatus LoadString(StringView chunk)
        {
            return LoadString(chunk, null);
        }

        /// Loads a file as a Lua chunk. This function uses lua_load to load the chunk in the file named filename
        /// @return The status of operation
        public LuaStatus LoadFile(StringView file, StringView? mode)
        {
            return (LuaStatus)LuaMethods.luaL_loadfilex(_luaState, file.ToScopeCStr!(), mode?.ToScopeCStr!() ?? null);
        }

        /// Loads a file as a Lua chunk.
        /// @return Return the status
        public LuaStatus LoadFile(StringView file)
        {
            return LoadFile(file, null);
        }

        /// Creates a new table and registers there the functions in list library.
        public void NewLib(LuaRegister [] library)
        {
            NewLibTable(library);
            SetFuncs(library, 0);
        }

        /// Creates a new table with a size optimized to store all entries in the array l (but does not actually store them)
        public void NewLibTable(LuaRegister [] library)
        {
            CreateTable(0, (.)library.Count);
        }

        /// Creates a new table to be used as a metatable for userdata
        /// @return If the registry already has the key tname, returns false.,
        public bool NewMetaTable(StringView name)
        {
            return LuaMethods.luaL_newmetatable(_luaState, name.ToScopeCStr!()) != 0;
        }

        /// Opens all standard Lua libraries into the given state.
        public void OpenLibs()
        {
            LuaMethods.luaL_openlibs(_luaState);
        }

        /// If the function argument arg is an integer (or convertible to an integer), returns this integer. If this argument is absent or is nil, returns d
        /// @param d default value
        public int64 OptInteger(int32 argument, int64 d)
        {
            return LuaMethods.luaL_optinteger(_luaState, argument, d);
        }
		// TODO
		/*
        /// If the function argument arg is a string, returns this string. If this argument is absent or is nil, returns d        ///
        public byte[] OptBuffer(int32 index, byte [] def)
        {
           if (IsNoneOrNil(index))
                return def;

           return CheckBuffer(index);
        }

        /// If the function argument arg is a string, returns this string. If this argument is absent or is nil, returns d
        public string OptString(int32 index, string def)
        {
           if (IsNoneOrNil(index))
                return def;

           return CheckString(index);
        }


        /// If the function argument arg is a number, returns this number. If this argument is absent or is nil, returns d
        public double OptNumber(int32 index, double def)
        {
            return NativeMethods.luaL_optnumber(_luaState, index, def);
        }
		*/
        /// Creates and returns a reference, in the table at index t, for the object at the top of the stack (and pops the object).
        public int32 Ref(LuaRegistry tableIndex)
        {
            return LuaMethods.luaL_ref(_luaState, tableIndex);
        }

        /// If modname is not already present in package.loaded, calls function openf with string modname as an argument and sets the call result in package.loaded[modname], as if that function has been called through require
        public void RequireF(StringView moduleName, LuaFunction openFunction, bool global)
        {
            LuaMethods.luaL_requiref(_luaState, moduleName.ToScopeCStr!(), openFunction, global ? 1: 0);
        }

        /// Registers all functions in the array l (see luaL_Reg) into the table on the top of the stack (below optional upvalues, see next).        ///
        public void SetFuncs(LuaRegister [] library, int32 numberUpValues)
        {
            LuaMethods.luaL_setfuncs(_luaState, library.Ptr, numberUpValues);
        }

        /// Sets the metatable of the object at the top of the stack as the metatable associated with name tname in the registry
        public void SetMetaTable(StringView name)
        {
            LuaMethods.luaL_setmetatable(_luaState, name.ToScopeCStr!());
        }
		// TODO
		/*
        /// Test if the value at index is a reference data
        /// @param freeGCHandle True to release the GCHandle of object
        public T TestObject<T>(int32 argument, string typeName, bool freeGCHandle = true)
        {
            if (IsNil(argument) || !IsLightUserData(argument))
                return default(T);

            IntPtr data = TestUserData(argument, typeName); 
            if (data == 0)
                return default(T);

            var handle = GCHandle.FromIntPtr(data);
            if(!handle.IsAllocated)
                return default(T);

            var reference = (T)handle.Target;
            if(freeGCHandle)
                handle.Free();

            return reference;
        }

        /// This function works like luaL_checkudata, except that, when the test fails, it returns NULL instead of raising an error.
        public IntPtr TestUserData(int32 argument, string typeName)
        {
            return NativeMethods.luaL_testudata(_luaState, argument, typeName);
        }

        /// Creates and pushes a traceback of the stack L1
        /// @param level Tells at which level to start the traceback
        public void Traceback(Lua state, int32 level = 0)
        {
            Traceback(state, null, level);
        }

        /// Creates and pushes a traceback of the stack L1
        /// @param message appended at the beginning of the traceback
        /// @param level Tells at which level to start the traceback
        public void Traceback(Lua state, string message, int32 level)
        {
            NativeMethods.luaL_traceback(_luaState, state._luaState, message, level);
        }
		*/
        /// Returns the name of the type of the value at the given index.
        public StringView TypeName(int32 index)
        {
            LuaType type = Type(index);
            return TypeName(type);
        }

        /// Releases reference ref from the table at index t (see luaL_ref). The entry is removed from the table, so that the referred object can be collected. The reference ref is also freed to be used again
        public void Unref(LuaRegistry tableIndex, int32 reference)
        {
            LuaMethods.luaL_unref(_luaState, tableIndex, reference);
        }

        /// Emits a warning with the given message. A message in a call with tocont true should be continued in another call to this function.
        public void Warning(String message, bool toContinue)
        {
            LuaMethods.lua_warning(_luaState, message.CStr(), toContinue ? 1 : 0);
        }


        /// Pushes onto the stack a string identifying the current position of the control at level lvl in the call stack
        public void Where(int32 level)
        {
            LuaMethods.luaL_where(_luaState, level);
        }
    }
}