#include <bits/stdc++.h>

using namespace std;


string DecToHex(int n)
{
	string res = "";
	if (n == 0)
		return "0";
	while (n > 0)
	{
		int r = n % 16;
		if (r < 10)
			res += r + '0';
		else
			res += 'a' + (r - 10);

		n /= 16;
	}
	reverse(res.begin(), res.end());
	return res;
}


string get(string s)
{
	string ans = "";
	string t = "";
	int p;
	for (int i = 0; i < s.size(); i++)
	{
		if (s[i] == '\'')
		{
			p = i + 1;
			break;
		}
		t += s[i];
	}

	int cnt = stoi(t);

	if (s[p] == 'h')
	{
		if (s[p + 1] == '0' && s[p + 2] == '0')
			ans += "000000";
		if (s[p + 1] == '2' && s[p + 2] == '3')
			ans += "100011";
		if (s[p + 1] == '0' && s[p + 2] == '9')
			ans += "001001";
		if (s[p + 1] == '0' && s[p + 2] == '4')
			ans += "000100";
		if (s[p + 2] == 'B')
			ans += "101011";
	}

	if (s[p] == 'd')
	{
		string n = "";
		for (int i = p + 1; i < s.size(); i++)
			n += s[i];

		int m = stoi(n);
		vector<int> res;

		for (int i = cnt - 1; i >= 0; i--)
			if ((1 << i) & m)
				ans += "1";
			else
				ans += "0";
	}

	if (s[p] == 'b')
	{
		string n = "";
		for (int i = p + 1; i < s.size(); i++)
			ans += s[i];
	}

	return ans;
}

int main()
{
	//cout << get("32'b00000000000000000000000000000000") << endl;
	//cout << get("5'd4") << endl;
	//cout << get("6'h00") << endl;
	//cout << get("6'b100000") << endl;
	//cout << get("16'd2004") << endl;
	//cout << endl << endl;
	string s;
	int cnt = 0;
	while (getline(cin, s))
	{
		string t = "";
		bool read = 0;
		
		for (int i = 0; i < s.size(); i++)
		{
			if (s[i] == '{')
			{
				read = 1;
				continue;
			}
			if (s[i] == '}')
				read = 0;
			if (read)
				t += s[i];
		}
		t = t + ",";
		//cout << t << endl;

		s = t;
		t = "";
		//cout << s<< endl;

		for (int i = 0; i < s.size(); i++)
			if (s[i] != ' ')
				t += s[i];

		s = t;


		string cur = "";
		read = 0;
		int type = 0;
		vector<string> v;
		for (int i = 0; i < s.size(); i++)
		{
			if (s[i] == ',')
			{
				v.push_back(cur);
				cur = "";
			}

			if (s[i] != ',')
				cur += s[i];
		}

		string answer = "";
		string res = "";
		for (int i = 0; i < v.size(); i++)
		{
			res += v[i] + " ";
			answer += get(v[i]);
		}
		//cout << "Answer is " << answer << endl;
		//cout << res << " " << answer << endl << endl;
		cur = "";
		vector <string> bytee;
		for (int i = 0 ; i < 32 ; i++)
		{
			if (i % 8 == 0)
			{
				if (cur != "")
					bytee.push_back(cur);
				cur = "";
			}
			cur += answer[i];
		}
		bytee.push_back(cur);
		
		for (int b = 3; b >= 0 ; b--)
			cout << "@" << DecToHex(cnt++) << endl << bytee[b] << endl;
		
		//cout << answer << " " << bytee[0] << " " << bytee[1] << " " << bytee[2] << " "<< bytee[3] << endl;
		
	}
}