module axfinance.api.currencies;

import std.array, std.stdio, std.system, std.bigint, std.conv, std.regex, std.string, std.exception;
import Rational.rational;

alias rationalBI = Rational.rational.Rational!(BigInt);

/*
	TODO 5 при работе с криптовалютами, знаменатель должен всегда быть 10^8., но если это приведёт к десятичным дробям просто обдумать этот момент
*/

class Currencies(T)
{
	public:
		this()
		{
			static if (Rational.rational.isRational!(T))
				{
					zInt = rational(to!BigInt(0), to!BigInt(1));
				}
		}
		this(T bi)
		{
			static if (Rational.rational.isRational!(T))
				{
//					zInt = Rational.rational.toRational!BigInt(bi);
				}
		}
		this(ulong pf = 8)
		{
			precision(pf);
			selfPrecision(pf);
		}
		this(ulong pf1 = 8, ulong pf2 = 8)
		{
			precision(pf1);
			selfPrecision(pf2);
		}
		this(ulong pf, T bi)
		{
			precision(pf);
			zInteger(bi);
		}
		this(double dd, ulong pr = 8) // pr = numDigits(dd) Is it possible? Error: undefined identifier dd
		{
//			if (is(T == BigInt)) zInt = cast(ulong)(dd*10^^numDigits(dd));
//			else zInt = to!T(dd);
			precision(numDigits(dd));
		}
		void opAssign(double dd)
		{
			static if (Rational.rational.isIntegerLike!(T)) zInt = cast(T)(dd*10^^numDigits(dd));//TODO 1  если поставить isIntegral!T будет ли учтён BigInt? 			
			else	static if (Rational.rational.isRational!(T)) zInt = toRational!BigInt(cast(real)dd);
					else zInt = to!T(dd);
/*			switch (typeid(T))
			{
				case BigInt:
					
					break;
				case BigInt:
					
					break;
				case BigInt:
					
					break;
				default:
					zInt = to!T(dd);
					break;
				
			}*/
		}
		void opAssign(string dd)
		{
			static if (Rational.rational.isIntegerLike!(T)) {}
			else	static if (Rational.rational.isRational!(T))
				{
					// TODO 5 Если строка это вещественное число, то:
					zInt = Rational.rational.toRational!BigInt(to!double(dd));
				}
			else static if (is(T == double))		// isLikeFloat is(typeof(
			{
				zInt = to!T(dd);
			}
			else
			{
				auto pt = match(strip(dd), regex(r"\d+\.\d+"));
				auto ct = count(pt);
				if (ct)
				{
					auto p = split(pt.captures[0], ".");
					if (p.length > 1)
					{
						zInt = to!T(p[0]) * 10^^p[1].length + to!T(p[1]); 
						//cast(ulong)(dd*10^^numDigits(dd));
					}
				}
			}
		}
		Currencies opOpAssign(string op)(Currencies rhs)
		{
			if (op == "+")
			{
				static if (Rational.rational.isIntegerLike!(T) || Rational.rational.isRational!(T) || is(T == double))
				{
					auto res = value + rhs.value;
					//enforce(rhs.value >= 0 ? res >= value : res <= value);
					zInteger(res);
				}
				else
				{
				}
				return this;
			}	
		}
		Currencies opBinary(string op)(Currencies rhs) if (op == "+" || op == "-" || op == "*" || op == "/")
		{
			mixin("auto resInt = zInt "~ op~" rhs.zInt;");
			auto res = new Currencies!T(8, resInt);
			return res;
		}
		Currencies opBinary(string op)(T rhs) if (op == "+" || op == "-" || op == "*" || op == "/")
		{
			return opBinary!op(Currencies(rhs));
		}
		Currencies opBinaryRight(string op)(T lhs) if (op == "+" || op == "*")
		{
			return Currencies(lhs).opBinary!op(this);
		}
		override bool opEquals(Object o)
		{
			if (auto a = cast(Currencies) o)
				return value == a.value;
			return false;
		}
/*		bool opEquals(string tf)
		{
			//if (is(T == rationalBI)) zInt = toRational!BigInt(cast(real)dd);
			return value == to!T(tf);
		}*/
		bool integer(T pb)
		{
			zInt = pb;
			return true;
		}
		@property T value()
		{
			//string res = to!string(zInt);
			//insertInPlace(res, res.length - zExp,".");
			return zInt;
		}

	private:
		bool zInteger(T d)
		{
			zInt = d;
			return true;
		}
		bool precision(ulong pe)
		{
			zExp = pe;
			return true;
		}
		bool selfPrecision(ulong pe)
		{
			sePr = pe;
			return true;
		}
		long numDigits(double num)
		{
			long i=0;
			double n=num;
			while(true)
			{
				if(n - (cast(long)n) == 0)
				{
					return i;
				}
				i++;
				n *= 10;
			}
		}
		T zInt;
		ulong zExp;
		ulong sePr;
		bool sign;
}

unittest
{
	immutable LIM_FIAT = 2, LIM_EXCH = 6, LIM_CRYP = 8;
	alias CurD = Currencies!double;
	alias CurR = Currencies!(Rational.rational.Rational!(BigInt));
	auto cd = [	"BTC":["N-01":new CurD, "N-02":new CurD, "SUM1":new CurD, "SUM2": new CurD],
				"CNY":["N-01":new CurD, "N-02":new CurD, "N-03":new CurD, "SUM1":new CurD, "SUM2":new CurD],
				"EUR":["N-01":new CurD, "N-02":new CurD, "N-03":new CurD, "N-04":new CurD, "DIV1":new CurD, "SUM1":new CurD]
				];
	auto cr = ["BTC":["N-01":new CurR, "N-02":new CurR, "SUM1":new CurR, "SUM2":new CurR, "SUM3":new CurR]];
//	 EUR, LTC, RUB;
	cd["BTC"]["N-01"] = 1.00000002;
	cd["BTC"]["N-02"] = "13455580.45665435";
	cd["BTC"]["SUM1"] = cd["BTC"]["N-01"] + cd["BTC"]["N-02"];
//	cd["BTC"]["SUM2"] = cd["BTC"]["N-01"] + 5.2;
	writefln( " %f", cd["BTC"]["SUM1"].value);
	assert(cd["BTC"]["SUM1"].value == 13455581.45665437);
	cd["CNY"]["N-01"] = 1.02;
	cd["CNY"]["N-02"] = "0.01";
	cd["CNY"]["N-03"] = "0.00000001";
	cd["CNY"]["SUM1"] = cd["CNY"]["N-01"] + cd["CNY"]["N-02"];
	assert(cd["CNY"]["SUM1"].value == 1.03);
	cd["CNY"]["N-01"] += cd["CNY"]["N-02"];
	assert(cd["CNY"]["N-01"].value == 1.03);
/*	c["CNY"]["SUM2"] = c["CNY"]["N-01"] + c["CNY"]["N-03"];
	assert(c["CNY"]["SUM2"] == "1.02000001");
	c["EUR"]["N-01"] = 1.02;
	c["EUR"]["N-02"] = "4/33";
	c["EUR"]["DIV1"] = c["EUR"]["N-01"] / c["EUR"]["N-03"];
	assert(c["EUR"]["DIV1"] == "1683/200");
	assert(c["EUR"]["DIV1"] == "8.415");
	auto res = new Currencies(LIM_CRYP);

    // We would expect the result to be 1 after looping 1000
    // times:
    while (res < 1) {
        res += 0.001;
    }

    assert(res == 1);
    assert(res == "1");*/
	cr["BTC"]["N-01"] = 1.00000002;
	cr["BTC"]["N-02"] = "13455580.45665435";
	cr["BTC"]["SUM1"] = cr["BTC"]["N-01"] + cr["BTC"]["N-02"];
//	cr["BTC"]["SUM2"] = cr["BTC"]["N-01"] + toRational!BigInt(5);
//	cr["BTC"]["SUM3"] = cr["BTC"]["N-01"] + toRational!BigInt(5.2);
//	assert(cr["BTC"]["SUM2"].value == toRational!BigInt(5.00000002));
//	c["BTC-R"]["N-01"] = 1.00000002;
	
	cr["BTC"]["N-01"] += cr["BTC"]["N-02"];
//	assert(cd["BTC"]["N-01"].value == 1.03);

}