#include <ctime>
#include <string>
#include <sstream>

using namespace std;

class Time{
private:
	int minute, second;
public:
	Time(){
		this->minute=0;
		this->second=0;}

	string getTime(){
		stringstream ss;
		ss<<minute <<":"<<second;

		return ss.str();
	}

	void increment(){
		if(second>= 60){
			minute++;
			second = 0;
		}else 
			second++;
	}

	int getMin(){return minute;}
	int getSec(){return second;}
};



