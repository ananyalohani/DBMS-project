import pyfiglet
import mysql.connector

def stats():
    choice=0
    while choice!=5:
        print(" 1) Top Rankings of authors based on total number of papers \n 2) Top Rankings of institutions based on number of papers in MainTrack\n 3) Number of people registered for each of the tutorial. \n 4) Summary statistics (Total authors, papers) \n 5) Exit \n")
        choice=int(input("Select Query:"))
        if choice==1:
            query1a="""select Authors.AuthorID, AuthorName, IFNULL(MainTrackCount,0) as MainTrackCount, IFNULL(WorkshopPaperCount, 0) as WorkshopPaperCount, (IFNULL(MainTrackCount,0) + IFNULL(WorkshopPaperCount, 0)) as TotalPaperCount 
                        from
                        (
                        Authors
                        LEFT JOIN
                        (
                            select AuthorID, count(*) as MainTrackCount
                            from MainTrackAuthors 
                            group by AuthorID
                        ) as T2
                        ON
                        Authors.AuthorID = T2.AuthorID
                        LEFT JOIN
                        (
                            select AuthorID, count(*) as WorkshopPaperCount
                            from WkshpPaperAuthors
                            group by AuthorID
                        ) as T3
                        ON
                        T2.AuthorID = T3.AuthorID
                        )
                        ORDER BY TotalPaperCount desc;
                                    """
            cursor.execute(query1a)
            print("\n[+] Result [+] \n")
            j=1
            print("  AuthorID"+"AuthorName".center(20,' ')+" MainTrackCount "+" WorkshopPaperCount "+ " Total")
            for (a,b,c,d,e) in cursor.fetchall():
                print("{}. {} {} {} {} {}".format(str(j).rjust(2),a,b.center(20,' '),str(c).rjust(8),str(d).rjust(17),str(e).rjust(12)))
                j+=1
            print()
            print()
        if choice==2:
            query1a="""select T3.Affiliation as Institution, MainTrackCount, IFNULL(WorkshopPaperCount, 0) as WorkshopPaperCount, (MainTrackCount + IFNULL(WorkshopPaperCount, 0)) as TotalPaperCount
                    from
                    (
                    select T1.Affiliation, IFNULL(MainTrackCount, 0) as MainTrackCount
                    from
                    (
                    Select Distinct Affiliation
                    from Authors
                    ) as T1
                    LEFT JOIN
                    (
                    Select Affiliation, Count(*) as MainTrackCount
                    from
                    (
                        Select Distinct Affiliation, PaperID
                        from
                        (
                        Select Authors.AuthorID, Affiliation, PaperID
                        from Authors
                        LEFT JOIN
                        MainTrackAuthors
                        ON Authors.AuthorID = MainTrackAuthors.AuthorID
                        ) as Ta
                    ) as Tb
                    GROUP BY Affiliation
                    ) as T2
                    ON
                    T1.Affiliation = T2.Affiliation
                    ) as T3
                    LEFT JOIN
                    (
                    Select Affiliation, Count(*) as WorkshopPaperCount
                    from
                    (
                    Select Distinct Affiliation, WPaperID
                    from
                    (
                        Select Authors.AuthorID, Affiliation, WPaperID
                        from Authors
                        LEFT JOIN
                        WkshpPaperAuthors
                        ON Authors.AuthorID = WkshpPaperAuthors.AuthorID
                    ) as Tc
                    ) as Td
                    GROUP BY Affiliation
                    ) as T4
                    ON T3.Affiliation = T4.Affiliation
                    ORDER BY TotalPaperCount desc;

"""
            cursor.execute(query1a)
            print("\n[+] Result [+] \n")
            j=1
            print("Institution".center(54,' ')+" MainTrackCount "+" WorkshopPaperCount "+ " Total".ljust(5))
            for (b,c,d,e) in cursor.fetchall():
                print("{}. {} {} {} {}".format(str(j).rjust(2),b.center(54,' '),str(c).rjust(8),str(d).rjust(17),str(e).rjust(9)))
                j+=1
            print()
            print()
        if choice==3:
            query1a="""Select T3.TutorialID, Topic, (IFNULL(NumberOfAttendees,0) + IFNULL(NumberOfAuthors,0)) as TotalAttendees
                        FROM
                        (Select T1.TutorialID,T1.Topic, NumberOfAttendees from ((Select TutorialID, Topic from Tutorials) as T1
                        LEFT JOIN
                        (SELECT TutorialID, COUNT(*) as NumberOfAttendees
                        FROM AttendeeAttendsTutorial
                        GROUP BY TutorialID) as T2
                        ON
                        T1.TutorialID = T2.TutorialID)) as T3
                        LEFT JOIN
                        (SELECT TutorialID, COUNT(*) as NumberOfAuthors
                        FROM AuthorAttendsTutorial
                        GROUP BY TutorialID) as T4
                        ON
                        T3.TutorialID = T4.TutorialID;

                                """
            cursor.execute(query1a)
            print("\n[+] Result [+] \n")
            j=1
            print("TutorialID "+"Topic".center(38,' ')+" TotalAttendees".ljust(5))
            for (a,b,c) in cursor.fetchall():
                print("{}. {} {} {}".format(j,a,b.center(38,' '),str(c).ljust(5)))
                j+=1

            print()
            print()
        if choice==4:
            query1a="""select *
                        from
                        (
                        select count(*) as TotalAuthors
                        from Authors
                        ) as T1,
                        (
                        select count(*) as TotalWorkshops
                        from Workshops
                        ) as T2,
                        (
                        select count(*) as MainTrackPaperCount
                        from MainTrackPapers
                        ) as T3,
                        (
                        select count(*) as WorkshopPaperCount
                        from WorkshopPapers
                        ) as T4;
                    """
            cursor.execute(query1a)
            print("\n[+] Result [+] \n")
            for (a,b,c,d) in cursor.fetchall():
                print("Total Authors:{}, Total Workshops:{}, Total Main Track Papers:{}, Total Workshop Papers:{}".format(a,b,c,d))
            print()
            print()
        

if __name__=="__main__":
    print("\n\nWelcome to the Conference Manamment System")
    print("==========================================")
    result = pyfiglet.figlet_format("SPECTRUM DB",font="slant")
    print(result)
    try:
        print("Trying to connect...")
        connect = mysql.connector.connect(user='root', password='root123',host='127.0.0.1', database='spectrum1')
        if connect.is_connected:
            cursor = connect.cursor()
            print("Connected to the spectrum database")
            stats()

    except mysql.connector.Error as e:
        print("Error Connecting to database : \n" + str(e))
    finally:
        if(connect.is_connected):
            cursor.close()
            connect.close()
            print("Disconnected to the database.")