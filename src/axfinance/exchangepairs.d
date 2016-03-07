module axfinance.exchangepairs;

import std.conv, std.stdio, std.system, std.math;
// TODO 4 добавить получение массивов цен по лямбда-функциям

class ExchangePairs
{
	public:
		auto getPivotFromNumber(ubyte dn)
		{
			ubyte[] itAr = [5, 1];
			foreach(i, cmp; itAr)
				if (dn == cmp) return i;
			dn++;
			foreach(i, cmp; itAr)
				if (dn == cmp) return i;
			dn -= 2;
			foreach(i, cmp; itAr)
				if (dn == cmp) return i;
			while (dn)
			{
				dn--;
				foreach(i, cmp; itAr)
					if (dn == cmp) return i;
			}
			return 0;
		}
    	ulong[] getBuyPrices(ubyte mul = 1)
    	{
    		auto res = new ulong[Nst];
    		st = getPercent(14);
    		ulong prev = price - step * mul;
    		st = (price - getPercent(1)) / (Nst+3);
    		auto order = 10^^to!ulong(log10(prev)); 	// порядок цены
    		auto divAr = 10;
    		writeln(" prev ",  prev);
    		ulong firstNum = prev/order;
    		ubyte[] itAr = [5, 1];
    		auto numPivot = getPivotFromNumber(to!ubyte(firstNum));
    		foreach (i, ref a; res)
    		{
	    		if (i == 0)
	    		{
	    			a = firstNum * order;
	    		}
	    		else
	    		{
	    			auto prevPivot = itAr[numPivot] * order;					// Некая опорная точка для построения скелета цен примеры 1 2 5 10 20 50 100
	    			if ( numPivot == itAr.length - 1) order /= 10;
	    			a = prevPivot;
	    			numPivot = (numPivot + 1) % itAr.length;			// TODO 3 при изменении шага начинает глючить подсчёт order
	    		}
	    		a += getPercentДробь(a, 233, 100);
	    	}
    		return res;
    	}
    	ulong[] getSellPrices(ubyte mul = 1)
    	{
    		auto res = new ulong[Nst];
    		st = getPercent(54);
    		ulong prev = price + step * mul;
    		foreach (ref a; res)
    		{
    			a = prev + step * mul;
    			prev = a;
    		}
    		return res;
    	}
    	bool setPriceCorrection(byte pe = 2, byte sh = 0)
    	{
    		priceSh = sh;
    		priceExp = pe;
    		Nst = 9;
    		return true;
    	}
    	bool setPrice(ulong p1, ulong p2 = 0)
    	{
    		price = priceToUlong(p1, p2);
    		return true;
    	}
    	bool setTopPriceLimit(ulong p1, ulong p2 = 0)
    	{
    		topPrLim = priceToUlong(p1, p2);
    		return true;
    	}
    	bool setLowPriceLimit(ulong p1, ulong p2 = 0)
    	{
    		lowPrLim = priceToUlong(p1, p2);
    		return true;
    	}
    	/**
    		Перевод из удобочитаемой цены в ulong
    	*/
    	ulong priceToUlong(ulong p1, ulong p2 = 0)
    	{
    		return (p1 * 10^^priceExp + p2) * 10^^priceSh;
    	}
    	ulong dividePos()
    	{
    		return 10^^(priceExp+priceSh);
    	}
    	ulong step()
    	{
    		return st;
    	}
    private:
    	pure ulong getPercent(uint per)
    	{
    		return (price * per)/100;
    	}
    	pure ulong getPercent(ulong sr, uint per)
    	{
    		return (sr * per)/100;
    	}
    	pure ulong getPercentДробь(ulong sr, uint perT, uint perL)
    	{
    		return sr * perT /(perL* 100);
    	}
    	ulong price;				///< Текущая цена
    	ulong topPrLim;				///< Ограничение биржи на верхнюю границу цены
    	ulong lowPrLim;				///< Ограничение биржи на нижнюю границу цены
    	ubyte priceExp = 2;			///< Количество у валюты после запятой, которое оценивается в расчётах
    	ubyte priceSh = 0;			///< Насколько десятков нужно сдвинуть цену влево для расчётов
    	ulong st;
    	uint Nst;					///< Количество шагов в одном направлении
}
