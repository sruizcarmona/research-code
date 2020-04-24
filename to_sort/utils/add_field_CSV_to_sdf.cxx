// reading a text file
#include <iostream>
#include<sstream>
#include <fstream>
#include <string>
using namespace std;

int main () {
	string line,cline;
	int last=0,nline=0,numlines=0;

//FILES IN OUT DEFINITION
	string myfileSDFname=" ",myfileCODESname=" ",outputFilename=" ", sdfield=" ";
	//ifstream myfileSDF ("mol.sdf");
	ifstream myfileSDF;
	cout << "Hello!\nI will help you to modify a sdf file for inserting to Screening Assistant!\nPlease, answer the following questions:" << endl;
	cout << "\nEnter the name of the SDF FILE to import to SA:" << endl;
	cin >> myfileSDFname;
	//myfileSDFname="asinex.sdf";
        myfileSDF.open(myfileSDFname.c_str());
	//FIELD WITH ID INFORMATION IN SDF FILE
	cout << endl << "Enter the name of the SDF file FIELD with the vendor ID:" << endl;
	cin >> sdfield;
	//sdfield = "id_compound";
	//ifstream myfileCODES ("codes.txt");
	ifstream myfileCODES;
	cout << endl << endl << "Enter the name of the CSV FILE with the codes table:" << endl;
        cin >> myfileCODESname;
	//myfileCODESname="asinex.txt";
        myfileCODES.open(myfileCODESname.c_str());
	ofstream ofile;
	cout << endl << "Enter the name of the sdf file with the output:" << endl;
	cin >> outputFilename;
	//outputFilename="a.sdf";
	ofile.open(outputFilename.c_str());

	for(int i=0; !myfileCODES.eof(); i++){
                string kk;
                getline(myfileCODES,kk);
                stringstream is(kk);
                numlines++;
        }
        numlines--;
        myfileCODES.clear();
        myfileCODES.seekg(0);

        string ** data_array;
        data_array=new string*[numlines];
        for (int i=0;i<numlines;i++)
        data_array[i]=new string[200];	
// STORE ALL MATCHES BETWEEN VENDOR CODE AND MYX CODE IN DATA_ARRAY
	//ifstream inFile ("asinex.csv");
	while(getline(myfileCODES,line)){
		istringstream linestream(line);
		string item;
		int itemnum=0;
		while (getline (linestream, item, ';'))
	        {
			    data_array[nline][itemnum]=item;
//		            cout << "Item #" << itemnum << ": " << item << endl;
		            itemnum++;
	        }
		nline++;
        }
//	cout << data_array[0][0] << endl;

//LOOP FOR EVERY SDF ENTRY AND CHECK CORRECT MYX CODE

	if (myfileSDF.is_open())
	{
		while ( myfileSDF.good() )
		{
//			cout << last << endl;
			getline (myfileSDF,line);
			//string m("compound");
			string m(sdfield);
			size_t found;
			found=line.find(m);
			//cout << found << endl;
			if (found != -1){
		//		cout << "in" << endl;
		//		cout << line << endl;
				last=1;
				ofile << line << endl;
				continue;
			}
			if (last == 1) {
				for (int i=0;i<nline;i++){
//cout << line << endl;
//cout << data_array[i][0] << endl;
					if (line == data_array[i][0]){
						ofile << line << endl << endl;
						ofile << ">  <MYX_CODE>" << endl;
						ofile << data_array[i][1]<< endl;
						//cout << data_array[i][1] << endl;
						last=0;
						continue;
					}
				}
				continue;
				//cout << line << endl; 
			}
			last=0;
			ofile << line << endl;
		}
		myfileSDF.close();
	}
	
	else cout << "Unable to open file"; 
	ofile.close();
	
	cout << endl << endl << "DONE!! Thank you!" << endl << "May the force be with you..." << endl;
	return 0;
}
