#include <iostream>
#include <sstream>
#include <stdlib.h>
//#include <cctype>

using namespace std;

int main() {
 // char a_char[10];
//  cin>>a_char;
//  cout<<"As a float: "<<atof(a_char) << endl;
//  cout << a_char << isdigit(atoi(a_char)) << endl;
	//stringstream k;
//	char k[10];
//	cin >> k;
	//float kd;
	//kd=atof(k);
	//cout << kd << endl;
	//cout << isdigit(kd) << endl;
	std::stringstream ss;
  	ss.str ("a5456");
	std::string s = ss.str();
	std::cout << s.c_str() << '\n';
	if (isdigit(s[0])){
		cout << s[0] << "isdigit" << endl;
		cout << atof(s.c_str()) << endl;
	} else { 
		cout << s[0] << "isnotdigit" << endl;
		cout << atof(s.c_str()) << endl;
	}
  	ss.str ("0");
	std::string p = ss.str();
	std::cout << p.c_str() << '\n';
	if (isdigit(p[0])){
		cout << p[0] << "isdigit" << endl;
		cout << atof(p.c_str()) << endl;
	} else { 
		cout << p[0] << "isnotdigit" << endl;
		cout << atof(p.c_str()) << endl;
	}
	return 0;
}

