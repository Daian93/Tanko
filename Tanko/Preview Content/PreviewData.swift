//
//  PreviewData.swift
//  Tanko
//
//  Created by Diana Rammal Sansón on 13/2/26.
//

import SwiftUI

extension Manga {
    static let test = Manga(
        id: 1,
        title: "Monster",
        titleEnglish: "Monster",
        titleJapanese: "MONSTER",
        mainPicture: URL(
            string: "https://cdn.myanimelist.net/images/manga/3/258224l.jpg"
        ),
        synopsis:
            "Kenzou Tenma, a renowned Japanese neurosurgeon working in post-war Germany, faces a difficult choice: to operate on Johan Liebert, an orphan boy on the verge of death, or on the mayor of Düsseldorf. In the end, Tenma decides to gamble his reputation by saving Johan, effectively leaving the mayor for dead.\n\nAs a consequence of his actions, hospital director Heinemann strips Tenma of his position, and Heinemann's daughter Eva breaks off their engagement. Disgraced and shunned by his colleagues, Tenma loses all hope of a successful career—that is, until the mysterious killing of Heinemann gives him another chance.\n\nNine years later, Tenma is the head of the surgical department and close to becoming the director himself. Although all seems well for him at first, he soon becomes entangled in a chain of gruesome murders that have taken place throughout Germany. The culprit is a monster—the same one that Tenma saved on that fateful day nine years ago.\n\n[Written by MAL Rewrite]",
        background:
            "Monster won the Grand Prize at the 3rd annual Tezuka Osamu Cultural Prize in 1999, as well as the 46th Shogakukan Manga Award in the General category in 2000. The series was published in English by VIZ Media under the VIZ Signature imprint from February 21, 2006 to December 16, 2008, and again in 2-in-1 omnibuses (subtitled The Perfect Edition) from July 15, 2014 to July 19, 2016. The manga was also published in Brazilian Portuguese by Panini Comics/Planet Manga from June 2012 to April 2015, in Polish by Hanami from March 2014 to February 2017, in Spain by Planeta Cómic from June 16, 2009 to September 21, 2010, and in Argentina by LARP Editores.",
        score: 9.15,
        status: .finished,
        chapters: 162,
        volumes: 18,
        startDate: ISO8601DateFormatter().date(from: "1994-12-05T00:00:00Z"),
        endDate: ISO8601DateFormatter().date(from: "2001-12-20T00:00:00Z"),
        url: URL(string: "https://myanimelist.net/manga/1/Monster"),
        genres: [.awardWinning, .drama, .mystery],
        themes: [.adultCast, .psychological],
        demographics: [.seinen],
        authors: [
            Author(
                id: UUID(uuidString: "54BE174C-2FE9-42C8-A842-85D291A6AEDD")!,
                fullName: "Naoki Urasawa",
                role: .storyAndArt
            )
        ]
    )

    static let test2 = Manga(
        id: 11,
        title: "Naruto",
        titleEnglish: "Naruto",
        titleJapanese: "NARUTO―ナルト―",
        mainPicture: URL(
            string: "https://cdn.myanimelist.net/images/manga/3/249658l.jpg"
        ),
        synopsis:
            "Whenever Naruto Uzumaki proclaims that he will someday become the Hokage—a title bestowed upon the best ninja in the Village Hidden in the Leaves—no one takes him seriously. Since birth, Naruto has been shunned and ridiculed by his fellow villagers. But their contempt isn't because Naruto is loud-mouthed, mischievous, or because of his ineptitude in the ninja arts, but because there is a demon inside him. Prior to Naruto's birth, the powerful and deadly Nine-Tailed Fox attacked the village. In order to stop the rampage, the Fourth Hokage sacrificed his life to seal the demon inside the body of the newborn Naruto.\n\nAnd so when he is assigned to Team 7—along with his new teammates Sasuke Uchiha and Sakura Haruno, under the mentorship of veteran ninja Kakashi Hatake—Naruto is forced to work together with other people for the first time in his life. Through undergoing vigorous training and taking on challenging missions, Naruto must learn what it means to work in a team and carve his own route toward becoming a full-fledged ninja recognized by his village.\n\n[Written by MAL Rewrite]",
        background:
            "Naruto has sold over 250 million copies worldwide as of 2020, making it the 4th highest grossing manga series of all time. It was nominated for the 19th Tezuka Osamu Cultural Prize in 2014, and in the same year Masashi Kishimoto was awarded Rookie of the Year in the media fine arts category by Japan's Agency for Cultural Affairs. Numerous databooks, artbooks, novels, and fanbooks on the series have been released. Eight summary volumes featuring unaltered color pages, larger dimensions, and exclusive interviews, covering the first part of the series were released between November 7, 2008 and April 10, 2009. The series was published in English by VIZ Media under the Shonen Jump imprint from August 16, 2003 to October 6, 2015. In the last four months of 2007, the campaign titled \"Naruto Nation\" was launched, in which three volumes were published each month so that US releases would be closer to Japan's, the same practice was done in February through April of 2009 this time titled \"Generation Ninja.\" A 3-in-1 omnibus edition was also published from May 3, 2011 to October 2, 2018. A box set containing volumes 1-27 was released on August 6, 2008, another one containing volumes 28-48 on July 7, 2015, and the final box set with volumes 49-72 on January 5, 2016. It was also published in Brazilian Portuguese by Panini Comics/Planet Manga from May 2007 to June 2015, and again as Naruto Gold edition since July 2015.",
        score: 8.07,
        status: .finished,
        chapters: 700,
        volumes: 72,
        startDate: ISO8601DateFormatter().date(from: "1999-09-21T00:00:00Z"),
        endDate: ISO8601DateFormatter().date(from: "2014-11-10T00:00:00Z"),
        url: URL(string: "https://myanimelist.net/manga/11/Naruto"),
        genres: [.action, .adventure, .fantasy],
        themes: [.martialArts],
        demographics: [.shounen],
        authors: [
            Author(
                id: UUID(uuidString: "AC7020D1-D99F-4846-8E23-9C86181959AF")!,
                fullName: "Masashi Kishimoto",
                role: .storyAndArt
            )
        ]
    )

    static let tests: [Manga] = [.test, .test2]
}

extension Author {
    static let test = Author(
        id: UUID(uuidString: "54BE174C-2FE9-42C8-A842-85D291A6AEDD")!,
        fullName: "Naoki Urasawa",
        role: .storyAndArt
    )

    static let test2 = Author(
        id: UUID(uuidString: "00003F96-C82D-451F-A63C-356FB29550BC")!,
        fullName: "Shirou Toozaki",
        role: .story
    )

    static let tests: [Author] = [.test, .test2]
}

extension User {
    static let testUser = User(
        id: UUID(),
        email: "testuser1@tanko.com",
        isAdmin: true
    )
}

extension ReadingManga {
    static let onePieceWidget = ReadingManga(
        id: 1,
        title: "One Piece",
        coverURL: URL(
            string: "https://cdn.myanimelist.net/images/manga/2/253146.jpg"
        ),
        readingVolume: 50,
        totalVolumes: nil,
        isCompleteCollection: false
    )

    static let berserkWidget = ReadingManga(
        id: 3,
        title: "Berserk",
        coverURL: URL(
            string: "https://cdn.myanimelist.net/images/manga/1/157897.jpg"
        ),
        readingVolume: 41,
        totalVolumes: 41,
        isCompleteCollection: true
    )
}

extension ReadingCollection {
    static let preview = ReadingCollection(
        mangas: [.onePieceWidget, .berserkWidget],
        lastUpdated: Date()
    )
}
