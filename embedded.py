import pyfiglet
import mysql.connector

def authors():
    pass

def volunteers():
    pass

def organizers():
    pass

def tutors():
    pass

def attendees():
    pass

def workshop_organizers():
    pass

def stats():
    choice=0
    while choice!=5:
        print(" 1) Top Rankings of authors based on number of papers \n 2) Top Rankings of institutions based on number of papers in MainTrack\n 3) Papers which won Awards \n 4) Summary statistics (Total authors, papers) \n 5) Main Menu \n")
        choice=int(input("Select Query:"))
        if choice==1:
            query1a="select AuthorID, count(*) as MainTrackPapers from MainTrackAuthors group by AuthorID order by MainTrackPapers desc;"
            cursor.execute(query1a)
            print("\n[+] Main Track paper publised by Authors [+] \n")
            j=1
            for (a,b) in cursor.fetchall():
                print("{}. AuthorID: {},Total Papers: {}".format(j,a,b))
                j+=1

            query1b="select AuthorID, count(*) as WorkshopPapers from WkshpPaperAuthors group by AuthorID order by WorkshopPapers desc;"
            cursor.execute(query1b)
            j=1
            print("\n[+] Workshop papers publised by Authors [+] \n")
            for (a,b) in cursor.fetchall():
                print("{}. AuthorID: {},Total Papers: {}".format(j,a,b))
                j+=1

            query1c="select AuthorID,count(AuthorID) as TotalPapers from ((select AuthorID from WkshpPaperAuthors) union all (select AuthorID from MainTrackAuthors) ) as t group by AuthorID order by TotalPapers desc; "
            cursor.execute(query1c)
            j=1
            print("\n[+] Workshop and Main Track paper publised by Authors [+] \n")
            for (a,b) in cursor.fetchall():
                print("{}. AuthorID: {},Total Papers: {}".format(j,a,b))
                j+=1
            print()
        if choice==2:
            query1a="select Affiliation as Institution, count(*) as MainTrackPapers from (select distinct Affiliation, PaperID from MainTrackAuthors, Authors where MainTrackAuthors.AuthorID = Authors.AuthorID) as t group by Institution order by MainTrackPapers desc;"
            cursor.execute(query1a)
            print("\n[+] Main Track paper publised by Institution [+] \n")
            j=1
            for (a,b) in cursor.fetchall():
                print("{}. Institution: {},  Total Papers: {}".format(j,a,b))
                j+=1

            query1b="select Affiliation as Institution, count(*) as WorkshopPapers from (select distinct Affiliation, WPaperID from WkshpPaperAuthors, Authors where WkshpPaperAuthors.AuthorID = Authors.AuthorID) as t group by Institution order by WorkshopPapers desc;"
            cursor.execute(query1b)
            j=1
            print("\n[+] Workshop papers publised by Institution [+] \n")
            for (a,b) in cursor.fetchall():
                print("{}. Institution: {},  Total Papers: {}".format(j,a,b))
                j+=1

            query1c="select Affiliation as Institution, count(*) as PapersPublished from ((select distinct Affiliation, PaperID from MainTrackAuthors, Authors where MainTrackAuthors.AuthorID = Authors.AuthorID) union all (select distinct Affiliation, WPaperID from WkshpPaperAuthors, Authors where WkshpPaperAuthors.AuthorID = Authors.AuthorID)) as t group by Institution order by PapersPublished desc;"
            cursor.execute(query1c)
            j=1
            print("\n[+] Workshop and Main Track paper publised by Institution [+] \n")
            for (a,b) in cursor.fetchall():
                print("{}. Institution: {},  Total Papers: {}".format(j,a,b))
                j+=1
            print()
        if choice==3:
            query1a="select title from maintrackpapers where PaperID in (select PaperID from awards where PaperID is not null); "
            cursor.execute(query1a)
            print("\n[+] Main Track paper [+] \n")
            j=1
            for (a) in cursor.fetchall():
                print("{}. Title: {}".format(j,a))
                j+=1

            query1b="select title from workshoppapers where WPaperID in (select WPaperID from awards where WPaperID is not null);"
            cursor.execute(query1b)
            j=1
            print("\n[+] Workshop papers [+] \n")
            for (a) in cursor.fetchall():
                print("{}. Title: {}".format(j,a))
                j+=1
            print()
        if choice==4:
            query1a="select * from (select count(*) as TotalAuthors from Authors) as t1, (select count(*) as TotalWorkshops from Workshops) as t2, (select count(*) as MainTrackPaperCount from MainTrackPapers) as t3, (select count(*) as WorkshopPaperCount from WorkshopPapers)  as SummaryStatistics;"
            cursor.execute(query1a)
            for (a,b,c,d) in cursor.fetchall():
                print("Total Authors:{}, Total Workshops:{}, Total Main Track Papers:{}, Total Workshop Papers:{}".format(a,b,c,d))
            print()
            pass


def mainpage():
    choice=0
    while choice!=8:
        print("Who are you? \n 1) Author \n 2) Volunteer\n 3) Organizers \n 4) Tutors \n 5) Attendees \n 6) Workshop Organizers \n 7) Statistics and Ranking \n 8) Exit\n")
        choice=int(input("Select option: "))
        if choice==1:
            authors()
        elif choice==2:
            volunteers()
        elif choice==3:
            organizers()
        elif choice==4:
            tutors()
        elif choice==5:
            attendees()
        elif choice==6:
            workshop_organizers()
        if choice==7:
            stats()

if __name__=="__main__":
    print("\n\nWelcome to the Conference Manamment System")
    print("==========================================")
    result = pyfiglet.figlet_format("SPECTRUM DB",font="slant")
    print(result)
    try:
        print("Trying to connect...")
        connect = mysql.connector.connect(user='root', password='root123',host='127.0.0.1', database='spectrum')
        if connect.is_connected:
            cursor = connect.cursor()
            print("Connected to the spectrum database")
            mainpage()

    except mysql.connector.Error as e:
        print("Error Connecting to database : \n" + str(e))
    finally:
        if(connect.is_connected):
            cursor.close()
            connect.close()
            print("Disconnected to the database.")