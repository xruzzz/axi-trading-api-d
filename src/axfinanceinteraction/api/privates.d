module axfinanceinteraction.api.privates;

import std.stdio, std.system;

interface PrivateInformations
{
	public:
		string getInfo();
		string availableFunds();
		string lockedFunds();
}
