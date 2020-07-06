//
//  main.m
//  card_importer_gemp
//
//  Created by Eric Lanz on 12/24/19.
//  Copyright © 2019 Eric Lanz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AppKit/AppKit.h>

@interface Filter : NSObject

@property (nonatomic, strong) NSString *filter;
@property (nonatomic, strong) NSMutableArray<NSString *> *items;

@end

@implementation Filter
@end


@interface Squadron : NSObject

@property (nonatomic, strong) NSString *filter;
@property (nonatomic, assign) int howMany;

@end

@implementation Squadron
@end

@interface CountedIcon : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, assign) int howMany;

@end

@implementation CountedIcon
@end

NSString* patch(NSString *final, NSString *patch) {
  return [NSString stringWithFormat:@"%@\n%@", final, patch];
}

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        NSMutableArray *filePaths = [[NSMutableArray alloc] init];

        // Enumerators are recursive
        NSDirectoryEnumerator *enumerator = [[NSFileManager defaultManager] enumeratorAtPath:@"/Users/elanz/Documents/gemp-swccg-master/gemp-swccg-cards/src/main/java/com/gempukku/swccgo/cards"];

        NSString *filePath;

        while ((filePath = [enumerator nextObject]) != nil){
            if([[filePath pathExtension] isEqualToString:@"java"] && [filePath.lastPathComponent hasPrefix:@"Card"] && ![filePath.lastPathComponent hasPrefix:@"CardMatches"] && ![filePath.lastPathComponent hasPrefix:@"CardsInHand"] && ![filePath.lastPathComponent hasPrefix:@"CardPlayed"] && ![filePath.lastPathComponent hasPrefix:@"CardTitle"]){
                [filePaths addObject:[@"/Users/elanz/Documents/gemp-swccg-master/gemp-swccg-cards/src/main/java/com/gempukku/swccgo/cards" stringByAppendingPathComponent:filePath]];
            }
        }
        
        for (NSString *filePath in filePaths) {
            NSString *set=@"", *type=@"", *subtype=@"", *title=@"", *blueprintid=@"", *side=@"", *gametext=@"", *lightgametext=@"", *darkgametext=@"", *lore=@"", *playZone=@"", *matchingstarship=@"", *species=@"", *category=@"", *matchingSystem=@"";
            NSString *destiny=@"", *altdestiny=@"", *deploy=@"", *power=@"", *ability=@"", *forfeit=@"", *unique=@"", *armor=@"", *politics=@"", *maneuver=@"", *hyperspeed=@"", *landspeed=@"", *ferocity=@"", *defense=@"", *parsec=@"";
            bool isFront = false, deployUsingBothForcePiles = false, mayDbeployAsUndercoverSpy = false, deploysAsUndercoverSpy = false, alternateImageSuffix = false, virtualSuffix = false, immuneToOpponentsObjective = false, doesNotCountTowardsDeckLimit = false, characterPersonaOnlyWhileOnTable = false, mayNotBePlacedInReserveDeck = false, interiorSiteVehicle = false, alwaysStolen = false, frontOfDoubleSidedCard = false;
            int pilotcapacity = 0, astromechcapacity = 0, passengercapacity = 0, drivercapacity = 0, pilotorpassengercapacity = 0, vehicleCapacity = 0, tieCapacity = 0, starfighterCapacity = 0;
            Squadron *replacementForSquadron;
            replacementForSquadron.filter = @"";
            Squadron *capitalShipCapacity;
            capitalShipCapacity.filter = @"";
            Filter *matchingCharacterFilter;
            matchingCharacterFilter.filter = @"";
            Filter *matchingVehicleFilter;
            matchingVehicleFilter.filter = @"";
            NSMutableArray *icons, *keywords, *countedicons, *immunetocardtitle, *specialrulesineffect, *personas, *modeltypes, *matchingpilots, *mayNotBePartOfSystem;
            icons = [NSMutableArray array];
            keywords = [NSMutableArray array];
            countedicons = [NSMutableArray array];
            immunetocardtitle = [NSMutableArray array];
            specialrulesineffect = [NSMutableArray array];
            personas = [NSMutableArray array];
            modeltypes = [NSMutableArray array];
            matchingpilots = [NSMutableArray array];
            mayNotBePartOfSystem = [NSMutableArray array];
            
            NSString *fileAsString = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
            for (NSString *line in [fileAsString componentsSeparatedByString:@"\n"]) {
                //NSLog(@"line = %@", line);
                bool processed = false;
                if ([line hasPrefix:@" * Set:"]) {
                    set = [line componentsSeparatedByString:@" * Set:"][1];
                    set = [set stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                }
                if ([line hasPrefix:@" * Type:"]) {
                    type = [line componentsSeparatedByString:@" * Type:"][1];
                    type = [type stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                }
                if (type == nil && [line containsString:@"AbstractUsedOrStartingInterrupt"]) {
                    type = @"Interrupt";
                }
                if ([type isEqualToString:@"Effect"] && [line containsString:@"AbstractDefensiveShield"]) {
                    type = @"Defensive Shield";
                }
                if ([type isEqualToString:@"Character          ."]) {
                    type = @"Character";
                }
                if ([line hasPrefix:@" * Subtype:"]) {
                    subtype = [line componentsSeparatedByString:@" * Subtype:"][1];
                    subtype = [subtype stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                }
                if ([line hasPrefix:@" * Title:"]) {
                    title = [line componentsSeparatedByString:@" * Title:"][1];
                    title = [title stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                }
                if ([line hasPrefix:@"public class Card"]) {
                    blueprintid = [line componentsSeparatedByString:@"public class Card"][1];
                    blueprintid = [blueprintid componentsSeparatedByString:@" extends"][0];
                }
                if ([blueprintid isEqualToString:@"14_004"]) {
                    NSLog(@"debug me");
                }
                
                if ([blueprintid containsString:@"208_046"]) {
                    NSLog(@"debug me");
                }
                
                if ([type isEqualToString:@"Objective"]) {
                    //NSLog(@"line = %@", line);
                    if ([line hasPrefix:@"        super("]) {
                        NSString *temp = [line componentsSeparatedByString:@"        super("][1];
                        temp = [temp componentsSeparatedByString:@");"][0];
                        NSArray<NSString *> *components = [temp componentsSeparatedByString:@", "];
                        if ([components[0] isEqualToString:@"Side.LIGHT"]) {
                            side = @"light";
                        } else if ([components[0] isEqualToString:@"Side.DARK"]) {
                            side = @"dark";
                        } else {
                            NSLog(@"unknown side");
                        }
                        destiny = components[1];
                    }
                    if ([line hasPrefix:@"        setFrontOfDoubleSidedCard(true);"]) {
                        isFront = true;
                        title = [title componentsSeparatedByString:@" / "][0];
                        processed = true;
                    }
                    if ([line hasPrefix:@"        setFrontOfDoubleSidedCard(false);"]) {
                        isFront = false;
                        title = [title componentsSeparatedByString:@" / "][1];
                        processed = true;
                    }
                } else if ([type isEqualToString:@"Character"] && [subtype isEqualToString:@"Droid"]) {
                    if ([line hasPrefix:@"        super("]) {
                        NSString *temp = [line componentsSeparatedByString:@"        super("][1];
                        temp = [temp componentsSeparatedByString:@");"][0];
                        NSArray<NSString *> *components = [temp componentsSeparatedByString:@", "];
                        if ([components[0] isEqualToString:@"Side.LIGHT"]) {
                            side = @"light";
                        } else if ([components[0] isEqualToString:@"Side.DARK"]) {
                            side = @"dark";
                        } else {
                            NSLog(@"unknown side");
                        }
                        destiny = components[1];
                        deploy = components[2];
                        power = components[3];
                        forfeit = components[4];
                        if (components.count > 6) {
                            if ([blueprintid isEqualToString:@"14_004"] || [blueprintid isEqualToString:@"14_003"]) {
                                unique = components[7];
                            } else {
                                unique = components[6];
                            }
                        }
                    }
                 } else if ([type isEqualToString:@"Character"]) {
                     if ([line hasPrefix:@"        super("]) {
                         NSString *temp = [line componentsSeparatedByString:@"        super("][1];
                         temp = [temp componentsSeparatedByString:@");"][0];
                         NSArray<NSString *> *components = [temp componentsSeparatedByString:@", "];
                         if ([components[0] isEqualToString:@"Side.LIGHT"]) {
                             side = @"light";
                         } else if ([components[0] isEqualToString:@"Side.DARK"]) {
                             side = @"dark";
                         } else {
                             NSLog(@"unknown side");
                         }
                         destiny = components[1];
                         deploy = components[2];
                         power = components[3];
                         ability = components[4];
                         forfeit = components[5];
                         if (components.count > 7) {
                             if ([blueprintid isEqualToString:@"203_023"] || [blueprintid isEqualToString:@"13_059"] || [blueprintid isEqualToString:@"203_004"]
                                  || [blueprintid isEqualToString:@"110_010"] || [blueprintid isEqualToString:@"208_010"] || [blueprintid isEqualToString:@"205_012"]
                                  || [blueprintid isEqualToString:@"7_175"] || [blueprintid isEqualToString:@"208_030"] || [blueprintid isEqualToString:@"200_085"]
                                  || [blueprintid isEqualToString:@"200_002"] || [blueprintid isEqualToString:@"13_009"] || [blueprintid isEqualToString:@"10_003"]
                                  || [blueprintid isEqualToString:@"203_026"] || [blueprintid isEqualToString:@"12_101"] || [blueprintid isEqualToString:@"12_102"]
                                  || [blueprintid isEqualToString:@"7_175"] || [blueprintid isEqualToString:@"13_027"] || [blueprintid isEqualToString:@"13_029"]
                                  || [blueprintid isEqualToString:@"9_024"] || [blueprintid isEqualToString:@"200_021"] || [blueprintid isEqualToString:@"205_014"]
                                  || [blueprintid isEqualToString:@"208_208"] || [blueprintid isEqualToString:@"14_018"] || [blueprintid isEqualToString:@"14_019"]
                                  || [blueprintid isEqualToString:@"14_081"] || [blueprintid isEqualToString:@"14_082"] || [blueprintid isEqualToString:@"13_033"]
                                  || [blueprintid isEqualToString:@"11_006"] || [blueprintid isEqualToString:@"11_007"] || [blueprintid isEqualToString:@"200_145"]
                                  || [blueprintid isEqualToString:@"200_023"] || [blueprintid isEqualToString:@"14_023"] || [blueprintid isEqualToString:@"14_024"]
                                  || [blueprintid isEqualToString:@"12_022"] || [blueprintid isEqualToString:@"12_023"] || [blueprintid isEqualToString:@"13_039"]
                                  || [blueprintid isEqualToString:@"208_010"] || [blueprintid isEqualToString:@"14_029"] || [blueprintid isEqualToString:@"7_175"]
                                  || [blueprintid isEqualToString:@"14_086"] || [blueprintid isEqualToString:@"14_087"] || [blueprintid isEqualToString:@"9_031"]
                                  || [blueprintid isEqualToString:@"202_004"] || [blueprintid isEqualToString:@"13_048"] || [blueprintid isEqualToString:@"12_035"]
                                  || [blueprintid isEqualToString:@"12_036"] || [blueprintid isEqualToString:@"208_008"]) {
                                 unique = components[8];
                             } else {
                                 unique = components[7];
                             }
                         }
                     }
                 }else if ([type isEqualToString:@"Location"]) {
                    if ([line hasPrefix:@"        super("]) {
                        NSString *temp = [line componentsSeparatedByString:@"        super("][1];
                        temp = [temp componentsSeparatedByString:@");"][0];
                        NSArray<NSString *> *components = [temp componentsSeparatedByString:@", "];
                        if ([components[0] isEqualToString:@"Side.LIGHT"]) {
                            side = @"light";
                        } else if ([components[0] isEqualToString:@"Side.DARK"]) {
                            side = @"dark";
                        } else {
                            NSLog(@"unknown side");
                        }
                        if ([subtype isEqualToString:@"System"]) {
                            parsec = components[2];
                        } else if ([subtype isEqualToString:@"Site"]) {
                            NSLog(@"debug me");
                        }
                    }
                } else if ([type isEqualToString:@"Interrupt"] || [type isEqualToString:@"Starting Interrupt"]) {
                    if ([line hasPrefix:@"        super("]) {
                        NSString *temp = [line componentsSeparatedByString:@"        super("][1];
                        temp = [temp componentsSeparatedByString:@");"][0];
                        NSArray<NSString *> *components = [temp componentsSeparatedByString:@", "];
                        if ([components[0] isEqualToString:@"Side.LIGHT"]) {
                            side = @"light";
                        } else if ([components[0] isEqualToString:@"Side.DARK"]) {
                            side = @"dark";
                        } else {
                            NSLog(@"unknown side");
                        }
                        destiny = components[1];
                        if (components.count > 3 && [blueprintid isEqualToString:@"5_144"] == false && [blueprintid isEqualToString:@"3_130"] == false
                             && [blueprintid isEqualToString:@"201_013"] == false && [blueprintid isEqualToString:@"1_085"] == false
                             && [blueprintid isEqualToString:@"1_280"] == false) {
                            if ([blueprintid isEqualToString:@"5_033"] || [blueprintid isEqualToString:@"6_060"] || [blueprintid isEqualToString:@"11_032"]
                                || [blueprintid isEqualToString:@"1_085"] || [blueprintid isEqualToString:@"201_013"]|| [blueprintid isEqualToString:@"14_110"]
                                 || [blueprintid isEqualToString:@"5_051"] || [blueprintid isEqualToString:@"200_053"] || [blueprintid isEqualToString:@"14_104"]
                                 || [blueprintid isEqualToString:@"12_155"] || [blueprintid isEqualToString:@"14_043"] || [blueprintid isEqualToString:@"3_130"]
                                 || [blueprintid isEqualToString:@"9_140"] || [blueprintid isEqualToString:@"14_105"] || [blueprintid isEqualToString:@"3_130"]
                                 || [blueprintid isEqualToString:@"4_073"]) {
                                unique = components[4];
                            } else {
                                unique = components[3];
                            }
                        }
                    }
                } else if ([type isEqualToString:@"Vehicle"] && ([subtype isEqualToString:@"Creature"] || [subtype isEqualToString:@"Combat"] || [subtype isEqualToString:@"Transport"])) {
                   if ([line hasPrefix:@"        super("]) {
                       NSString *temp = [line componentsSeparatedByString:@"        super("][1];
                       temp = [temp componentsSeparatedByString:@");"][0];
                       NSArray<NSString *> *components = [temp componentsSeparatedByString:@", "];
                       if ([components[0] isEqualToString:@"Side.LIGHT"]) {
                           side = @"light";
                       } else if ([components[0] isEqualToString:@"Side.DARK"]) {
                           side = @"dark";
                       } else {
                           NSLog(@"unknown side");
                       }
                       destiny = components[1];
                       deploy = components[2];
                       power = components[3];
                       armor = components[4];
                       maneuver = components[5];
                       landspeed = components[6];
                       forfeit = components[7];
                       if (components.count > 9) {
                           unique = components[9];
                       }
                    }
                 } else if ([type isEqualToString:@"Vehicle"] && [subtype isEqualToString:@"Shuttle"]) {
                    if ([line hasPrefix:@"        super("]) {
                        NSString *temp = [line componentsSeparatedByString:@"        super("][1];
                        temp = [temp componentsSeparatedByString:@");"][0];
                        NSArray<NSString *> *components = [temp componentsSeparatedByString:@", "];
                        if ([components[0] isEqualToString:@"Side.LIGHT"]) {
                            side = @"light";
                        } else if ([components[0] isEqualToString:@"Side.DARK"]) {
                            side = @"dark";
                        } else {
                            NSLog(@"unknown side");
                        }
                        destiny = components[1];
                        deploy = components[2];
                        power = components[3];
                        maneuver = components[5];
                        landspeed = components[6];
                        forfeit = components[7];
                        if (components.count > 9) {
                            unique = components[9];
                        }
                     }
                 } else if ([type isEqualToString:@"Starship"]) {
                    if ([line hasPrefix:@"        super("]) {
                        NSString *temp = [line componentsSeparatedByString:@"        super("][1];
                        temp = [temp componentsSeparatedByString:@");"][0];
                        NSArray<NSString *> *components = [temp componentsSeparatedByString:@", "];
                        if ([components[0] isEqualToString:@"Side.LIGHT"]) {
                            side = @"light";
                        } else if ([components[0] isEqualToString:@"Side.DARK"]) {
                            side = @"dark";
                        } else {
                            NSLog(@"unknown side");
                        }
                        destiny = components[1];
                        deploy = components[2];
                        power = components[3];
                        armor = components[4];
                        maneuver = components[5];
                        hyperspeed = components[6];
                        forfeit = components[7];
                        if (components.count > 9) {
                            if ([blueprintid isEqualToString:@"13_021"] || [blueprintid isEqualToString:@"205_007"]) {
                                unique = components[11];
                            } else if ([blueprintid isEqualToString:@"201_040"] || [blueprintid isEqualToString:@"204_035"]) {
                                unique = components[10];
                            }else {
                                unique = components[9];
                            }
                        }
                    }
                } else if ([type isEqualToString:@"Effect"]) {
                    if ([line hasPrefix:@"        super("]) {
                        NSString *temp = [line componentsSeparatedByString:@"        super("][1];
                        temp = [temp componentsSeparatedByString:@");"][0];
                        NSArray<NSString *> *components = [temp componentsSeparatedByString:@", "];
                        if ([components[0] isEqualToString:@"Side.LIGHT"]) {
                            side = @"light";
                        } else if ([components[0] isEqualToString:@"Side.DARK"]) {
                            side = @"dark";
                        } else {
                            NSLog(@"unknown side");
                        }
                        destiny = components[1];
                        playZone = components[2];
                        if (components.count > 4) {
                            if ([blueprintid isEqualToString:@"5_110"] || [blueprintid isEqualToString:@"200_102"] || [blueprintid isEqualToString:@"4_126"]) {
                                unique = components[6];
                            } else if ([blueprintid isEqualToString:@"10_007"]
                                 || [blueprintid isEqualToString:@"11_018"] || [blueprintid isEqualToString:@"13_028"]
                                || [blueprintid isEqualToString:@"12_143"] || [blueprintid isEqualToString:@"11_078"]) {
                                unique = components[5];
                            } else {
                                unique = components[4];
                            }
                        }
                    }
                } else if ([type isEqualToString:@"Weapon"]) {
                    if ([line hasPrefix:@"        super("]) {
                        NSString *temp = [line componentsSeparatedByString:@"        super("][1];
                        temp = [temp componentsSeparatedByString:@");"][0];
                        NSArray<NSString *> *components = [temp componentsSeparatedByString:@", "];
                        if ([components[0] isEqualToString:@"Side.LIGHT"]) {
                           side = @"light";
                        } else if ([components[0] isEqualToString:@"Side.DARK"]) {
                           side = @"dark";
                        } else {
                           NSLog(@"unknown side");
                        }
                        destiny = components[1];
                        if ([subtype isEqualToString:@"Artillery"]) {
                            deploy = components[2];
                            forfeit = components[3];
                            if (components.count > 5) {
                                unique = components[5];
                            }
                        } else if ([subtype isEqualToString:@"Automated"]) {
                            playZone = components[2];
                            if (components.count > 4) {
                                unique = components[4];
                            }
                        } else {
                            if (components.count > 3) {
                                unique = components[3];
                            }
                        }
                    }
                } else if ([type isEqualToString:@"Device"]) {
                    if ([line hasPrefix:@"        super("]) {
                        NSString *temp = [line componentsSeparatedByString:@"        super("][1];
                        temp = [temp componentsSeparatedByString:@");"][0];
                        NSArray<NSString *> *components = [temp componentsSeparatedByString:@", "];
                        if ([components[0] isEqualToString:@"Side.LIGHT"]) {
                          side = @"light";
                        } else if ([components[0] isEqualToString:@"Side.DARK"]) {
                          side = @"dark";
                        } else {
                          NSLog(@"unknown side");
                        }
                        destiny = components[1];
                        playZone = components[2];
                        if (components.count > 4) {
                            unique = components[4];
                        }
                    }
                } else if ([type isEqualToString:@"Epic Event"]) {
                    if ([line hasPrefix:@"        super("]) {
                        NSString *temp = [line componentsSeparatedByString:@"        super("][1];
                        temp = [temp componentsSeparatedByString:@");"][0];
                        NSArray<NSString *> *components = [temp componentsSeparatedByString:@", "];
                        if ([components[0] isEqualToString:@"Side.LIGHT"]) {
                          side = @"light";
                        } else if ([components[0] isEqualToString:@"Side.DARK"]) {
                          side = @"dark";
                        } else {
                          NSLog(@"unknown side");
                        }
                        playZone = components[1];
                        if (components.count > 3) {
                            unique = components[3];
                        }
                    }
                } else if ([type isEqualToString:@"Creature"]) {
                    if ([line hasPrefix:@"        super("]) {
                        NSString *temp = [line componentsSeparatedByString:@"        super("][1];
                        temp = [temp componentsSeparatedByString:@");"][0];
                        NSArray<NSString *> *components = [temp componentsSeparatedByString:@", "];
                        if ([components[0] isEqualToString:@"Side.LIGHT"]) {
                          side = @"light";
                        } else if ([components[0] isEqualToString:@"Side.DARK"]) {
                          side = @"dark";
                        } else {
                          NSLog(@"unknown side");
                        }
                        destiny = components[1];
                        deploy = components[2];
                        ferocity = components[3];
                        defense = components[4];
                        forfeit = components[5];
                        if (components.count > 7) {
                            unique = components[7];
                        }
                    }
                } else if ([type isEqualToString:@"Defensive Shield"]) {
                    if ([line hasPrefix:@"        super("]) {
                        NSString *temp = [line componentsSeparatedByString:@"        super("][1];
                        temp = [temp componentsSeparatedByString:@");"][0];
                        NSArray<NSString *> *components = [temp componentsSeparatedByString:@", "];
                        if ([components[0] isEqualToString:@"Side.LIGHT"]) {
                          side = @"light";
                        } else if ([components[0] isEqualToString:@"Side.DARK"]) {
                          side = @"dark";
                        } else {
                          NSLog(@"unknown side");
                        }
                        if ([blueprintid isEqualToString:@"13_096"]) {
                            NSLog(@"debug me");
                        }
                        if (components.count == 3 && [blueprintid isEqualToString:@"13_096"] == false && [blueprintid isEqualToString:@"13_098"] == false) {
                            playZone = components[1];
                        }
                    }
                } else if ([type isEqualToString:@"Admiral's Order"]) {
                    if ([line hasPrefix:@"        super("]) {
                        NSString *temp = [line componentsSeparatedByString:@"        super("][1];
                        temp = [temp componentsSeparatedByString:@");"][0];
                        NSArray<NSString *> *components = [temp componentsSeparatedByString:@", "];
                        if ([components[0] isEqualToString:@"Side.LIGHT"]) {
                          side = @"light";
                        } else if ([components[0] isEqualToString:@"Side.DARK"]) {
                          side = @"dark";
                        } else {
                          NSLog(@"unknown side");
                        }
                    }
                } else if ([type isEqualToString:@"Jedi Test"]) {
                    if ([line hasPrefix:@"        super("]) {
                        NSString *temp = [line componentsSeparatedByString:@"        super("][1];
                        temp = [temp componentsSeparatedByString:@");"][0];
                        NSArray<NSString *> *components = [temp componentsSeparatedByString:@", "];
                        if ([components[0] isEqualToString:@"Side.LIGHT"]) {
                          side = @"light";
                        } else if ([components[0] isEqualToString:@"Side.DARK"]) {
                          side = @"dark";
                        } else {
                          NSLog(@"unknown side");
                        }
                        destiny = components[1];
                        if (components.count == 4) {
                            playZone = components[2];
                        }
                    }
                } else if ([type isEqualToString:@"Podracer"]) {
                    if ([line hasPrefix:@"        super("]) {
                        NSString *temp = [line componentsSeparatedByString:@"        super("][1];
                        temp = [temp componentsSeparatedByString:@");"][0];
                        NSArray<NSString *> *components = [temp componentsSeparatedByString:@", "];
                        if ([components[0] isEqualToString:@"Side.LIGHT"]) {
                          side = @"light";
                        } else if ([components[0] isEqualToString:@"Side.DARK"]) {
                          side = @"dark";
                        } else {
                          NSLog(@"unknown side");
                        }
                        destiny = components[1];
                    }
                }
                if ([line hasPrefix:@"        setMatchingVehicleFilter("]) {
                    NSString *temp = [line componentsSeparatedByString:@"        setMatchingVehicleFilter("][1];
                    temp = [temp componentsSeparatedByString:@"));"][0];
                    NSArray<NSString *> *components = [temp componentsSeparatedByString:@", "];
                    matchingVehicleFilter = [Filter new];
                    matchingVehicleFilter.items = [NSMutableArray<NSString *> array];
                    if (components.count > 1) {
                        matchingVehicleFilter.filter = [components[0] componentsSeparatedByString:@"("][0];
                        [matchingVehicleFilter.items addObject:[components[0] componentsSeparatedByString:@"("][1]];
                        for (int i = 1; i < components.count; i++) {
                            [matchingVehicleFilter.items addObject:components[i]];
                        }
                    } else {
                        matchingVehicleFilter.filter = @"Filters.equal";
                        [matchingVehicleFilter.items addObject:[temp componentsSeparatedByString:@"));"][0]];
                    }
                    processed = true;
                }
                if ([line hasPrefix:@"        setMatchingCharacterFilter("]) {
                    NSString *temp = [line componentsSeparatedByString:@"        setMatchingCharacterFilter("][1];
                    temp = [temp componentsSeparatedByString:@"));"][0];
                    NSArray<NSString *> *components = [temp componentsSeparatedByString:@", "];
                    matchingCharacterFilter = [Filter new];
                    matchingCharacterFilter.items = [NSMutableArray<NSString *> array];
                    if (components.count > 1) {
                        matchingCharacterFilter.filter = [components[0] componentsSeparatedByString:@"("][0];
                        [matchingCharacterFilter.items addObject:[components[0] componentsSeparatedByString:@"("][1]];
                        for (int i = 1; i < components.count; i++) {
                            [matchingCharacterFilter.items addObject:components[i]];
                        }
                    } else {
                        matchingCharacterFilter.filter = @"Filters.equal";
                        [matchingCharacterFilter.items addObject:[temp componentsSeparatedByString:@"));"][0]];
                    }
                    processed = true;
                }
                if ([line hasPrefix:@"        setCapitalStarshipCapacity("]) {
                    NSString *temp = [line componentsSeparatedByString:@"        setCapitalStarshipCapacity("][1];
                    temp = [temp componentsSeparatedByString:@");"][0];
                    NSArray<NSString *> *components = [temp componentsSeparatedByString:@", "];
                    capitalShipCapacity = [Squadron new];
                    capitalShipCapacity.filter = components[1];
                    capitalShipCapacity.howMany = components[0].intValue;
                    processed = true;
                }
                if ([line hasPrefix:@"        setReplacementForSquadron("]) {
                    NSString *temp = [line componentsSeparatedByString:@"        setReplacementForSquadron("][1];
                    temp = [temp componentsSeparatedByString:@");"][0];
                    NSArray<NSString *> *components = [temp componentsSeparatedByString:@", "];
                    replacementForSquadron = [Squadron new];
                    replacementForSquadron.filter = components[1];
                    replacementForSquadron.howMany = components[0].intValue;
                    processed = true;
                }
                if ([line hasPrefix:@"        setMatchingSystem("]) {
                    NSString *temp = [line componentsSeparatedByString:@"        setMatchingSystem("][1];
                    temp = [temp componentsSeparatedByString:@");"][0];
                    matchingSystem = temp;
                    processed = true;
                }
                if ([line hasPrefix:@"        setCardCategory("]) {
                    NSString *temp = [line componentsSeparatedByString:@"        setCardCategory("][1];
                    temp = [temp componentsSeparatedByString:@");"][0];
                    category = temp;
                    processed = true;
                }
                if ([line hasPrefix:@"        setMatchingStarshipFilter("]) {
                    NSString *temp = [line componentsSeparatedByString:@"        setMatchingStarshipFilter("][1];
                    temp = [temp componentsSeparatedByString:@");"][0];
                    matchingstarship = temp;
                    processed = true;
                }
                if ([line hasPrefix:@"        setMayDeployAsUndercoverSpy("]) {
                    NSString *temp = [line componentsSeparatedByString:@"        setMayDeployAsUndercoverSpy("][1];
                    temp = [temp componentsSeparatedByString:@");"][0];
                    mayDbeployAsUndercoverSpy = temp.boolValue;
                    processed = true;
                }
                if ([line hasPrefix:@"        setDeploysAsUndercoverSpy("]) {
                    NSString *temp = [line componentsSeparatedByString:@"        setDeploysAsUndercoverSpy("][1];
                    temp = [temp componentsSeparatedByString:@");"][0];
                    deploysAsUndercoverSpy = temp.boolValue;
                    processed = true;
                }
                if ([line hasPrefix:@"        setVirtualSuffix("]) {
                    NSString *temp = [line componentsSeparatedByString:@"        setVirtualSuffix("][1];
                    temp = [temp componentsSeparatedByString:@");"][0];
                    virtualSuffix = temp.boolValue;
                    processed = true;
                }
                if ([line hasPrefix:@"        setDoesNotCountTowardDeckLimit("]) {
                    NSString *temp = [line componentsSeparatedByString:@"        setDoesNotCountTowardDeckLimit("][1];
                    temp = [temp componentsSeparatedByString:@");"][0];
                    doesNotCountTowardsDeckLimit = temp.boolValue;
                    processed = true;
                }
                if ([line hasPrefix:@"        setAlternateImageSuffix("]) {
                    NSString *temp = [line componentsSeparatedByString:@"        setAlternateImageSuffix("][1];
                    temp = [temp componentsSeparatedByString:@");"][0];
                    alternateImageSuffix = temp.boolValue;
                    processed = true;
                }
                if ([line hasPrefix:@"        setDeployUsingBothForcePiles("]) {
                    NSString *temp = [line componentsSeparatedByString:@"        setDeployUsingBothForcePiles("][1];
                    temp = [temp componentsSeparatedByString:@");"][0];
                    deployUsingBothForcePiles = temp.boolValue;
                    processed = true;
                }
                if ([line hasPrefix:@"        setImmuneToOpponentsObjective("]) {
                    NSString *temp = [line componentsSeparatedByString:@"        setImmuneToOpponentsObjective("][1];
                    temp = [temp componentsSeparatedByString:@");"][0];
                    immuneToOpponentsObjective = temp.boolValue;
                    processed = true;
                }
                if ([line hasPrefix:@"        setCharacterPersonaOnlyWhileOnTable("]) {
                    NSString *temp = [line componentsSeparatedByString:@"        setCharacterPersonaOnlyWhileOnTable("][1];
                    temp = [temp componentsSeparatedByString:@");"][0];
                    characterPersonaOnlyWhileOnTable = temp.boolValue;
                    processed = true;
                }
                if ([line hasPrefix:@"        setMayNotBePlacedInReserveDeck("]) {
                    NSString *temp = [line componentsSeparatedByString:@"        setMayNotBePlacedInReserveDeck("][1];
                    temp = [temp componentsSeparatedByString:@");"][0];
                    mayNotBePlacedInReserveDeck = temp.boolValue;
                    processed = true;
                }
                if ([line hasPrefix:@"        setInteriorSiteVehicle("]) {
                    NSString *temp = [line componentsSeparatedByString:@"        setInteriorSiteVehicle("][1];
                    temp = [temp componentsSeparatedByString:@");"][0];
                    interiorSiteVehicle = temp.boolValue;
                    processed = true;
                }
                if ([line hasPrefix:@"        setAlwaysStolen("]) {
                    NSString *temp = [line componentsSeparatedByString:@"        setAlwaysStolen("][1];
                    temp = [temp componentsSeparatedByString:@");"][0];
                    alwaysStolen = temp.boolValue;
                    processed = true;
                }
                if ([line hasPrefix:@"        setFrontOfDoubleSidedCard("] && [type isEqualToString:@"Objective"] == false) {
                    NSString *temp = [line componentsSeparatedByString:@"        setFrontOfDoubleSidedCard("][1];
                    temp = [temp componentsSeparatedByString:@");"][0];
                    frontOfDoubleSidedCard = temp.boolValue;
                    processed = true;
                }
                if ([line hasPrefix:@"        setSpecies("]) {
                    NSString *temp = [line componentsSeparatedByString:@"        setSpecies("][1];
                    temp = [temp componentsSeparatedByString:@");"][0];
                    species = temp;
                    processed = true;
                }
                if ([line hasPrefix:@"        addMatchingPilotFilter("]) {
                    NSString *temp = [line componentsSeparatedByString:@"        addMatchingPilotFilter("][1];
                    temp = [temp componentsSeparatedByString:@");"][0];
                    [matchingpilots addObject:temp];
                    processed = true;
                }
                if ([line hasPrefix:@"        setMatchingPilotFilter("]) {
                    NSString *temp = [line componentsSeparatedByString:@"        setMatchingPilotFilter("][1];
                    temp = [temp componentsSeparatedByString:@");"][0];
                    [matchingpilots addObject:temp];
                    processed = true;
                }
                if ([line hasPrefix:@"        addModelType("]) {
                    NSString *temp = [line componentsSeparatedByString:@"        addModelType("][1];
                    temp = [temp componentsSeparatedByString:@");"][0];
                    [modeltypes addObject:temp];
                    processed = true;
                }
                if ([line hasPrefix:@"        addModelTypes("]) {
                    NSString *temp = [line componentsSeparatedByString:@"        addModelTypes("][1];
                    temp = [temp componentsSeparatedByString:@");"][0];
                    NSArray<NSString *> *components = [temp componentsSeparatedByString:@", "];
                    for (NSString *component in components) {
                        [modeltypes addObject:component];
                    }
                    processed = true;
                }
                if ([line hasPrefix:@"        addPersona("]) {
                    NSString *temp = [line componentsSeparatedByString:@"        addPersona("][1];
                    temp = [temp componentsSeparatedByString:@");"][0];
                    [personas addObject:temp];
                    processed = true;
                }
                if ([line hasPrefix:@"        addPersonas("]) {
                    NSString *temp = [line componentsSeparatedByString:@"        addPersonas("][1];
                    temp = [temp componentsSeparatedByString:@");"][0];
                    NSArray<NSString *> *components = [temp componentsSeparatedByString:@", "];
                    for (NSString *component in components) {
                        [personas addObject:component];
                    }
                    processed = true;
                }
                if ([line hasPrefix:@"        addMayNotBePartOfSystem("]) {
                    NSString *temp = [line componentsSeparatedByString:@"        addMayNotBePartOfSystem("][1];
                    temp = [temp componentsSeparatedByString:@");"][0];
                    NSArray<NSString *> *components = [temp componentsSeparatedByString:@", "];
                    for (NSString *component in components) {
                        [mayNotBePartOfSystem addObject:component];
                    }
                    processed = true;
                }
                if ([line hasPrefix:@"        addSpecialRulesInEffectHere("]) {
                    NSString *temp = [line componentsSeparatedByString:@"        addSpecialRulesInEffectHere("][1];
                    temp = [temp componentsSeparatedByString:@");"][0];
                    [specialrulesineffect addObject:temp];
                    processed = true;
                }
                if ([line hasPrefix:@"        addImmuneToCardTitle("]) {
                    NSString *temp = [line componentsSeparatedByString:@"        addImmuneToCardTitle("][1];
                    temp = [temp componentsSeparatedByString:@");"][0];
                    [immunetocardtitle addObject:temp];
                    processed = true;
                }
                if ([line hasPrefix:@"        setPolitics("]) {
                    NSString *temp = [line componentsSeparatedByString:@"        setPolitics("][1];
                    temp = [temp componentsSeparatedByString:@");"][0];
                    politics = temp;
                    processed = true;
                }
                if ([line hasPrefix:@"        setArmor("]) {
                    NSString *temp = [line componentsSeparatedByString:@"        setArmor("][1];
                    temp = [temp componentsSeparatedByString:@");"][0];
                    armor = temp;
                    processed = true;
                }
                if ([line hasPrefix:@"        setManeuver("]) {
                    NSString *temp = [line componentsSeparatedByString:@"        setManeuver("][1];
                    temp = [temp componentsSeparatedByString:@");"][0];
                    maneuver = temp;
                    processed = true;
                }
                if ([line hasPrefix:@"        setTIECapacity("]) {
                    NSString *temp = [line componentsSeparatedByString:@"        setTIECapacity("][1];
                    temp = [temp componentsSeparatedByString:@");"][0];
                    tieCapacity = temp.intValue;
                    processed = true;
                }
                if ([line hasPrefix:@"        setStarfighterCapacity("]) {
                    NSString *temp = [line componentsSeparatedByString:@"        setStarfighterCapacity("][1];
                    temp = [temp componentsSeparatedByString:@");"][0];
                    starfighterCapacity = temp.intValue;
                    processed = true;
                }
                if ([line hasPrefix:@"        setVehicleCapacity("]) {
                    NSString *temp = [line componentsSeparatedByString:@"        setVehicleCapacity("][1];
                    temp = [temp componentsSeparatedByString:@");"][0];
                    vehicleCapacity = temp.intValue;
                    processed = true;
                }
                if ([line hasPrefix:@"        setDriverCapacity("]) {
                    NSString *temp = [line componentsSeparatedByString:@"        setDriverCapacity("][1];
                    temp = [temp componentsSeparatedByString:@");"][0];
                    drivercapacity = temp.intValue;
                    processed = true;
                }
                if ([line hasPrefix:@"        setAstromechCapacity("]) {
                    NSString *temp = [line componentsSeparatedByString:@"        setAstromechCapacity("][1];
                    temp = [temp componentsSeparatedByString:@");"][0];
                    astromechcapacity = temp.intValue;
                    processed = true;
                }
                if ([line hasPrefix:@"        setPilotOrPassengerCapacity("]) {
                    NSString *temp = [line componentsSeparatedByString:@"        setPilotOrPassengerCapacity("][1];
                    temp = [temp componentsSeparatedByString:@");"][0];
                    pilotorpassengercapacity = temp.intValue;
                    processed = true;
                }
                if ([line hasPrefix:@"        setPassengerCapacity("]) {
                    NSString *temp = [line componentsSeparatedByString:@"        setPassengerCapacity("][1];
                    temp = [temp componentsSeparatedByString:@");"][0];
                    passengercapacity = temp.intValue;
                    processed = true;
                }
                if ([line hasPrefix:@"        setAlternateDestiny("]) {
                    NSString *temp = [line componentsSeparatedByString:@"        setAlternateDestiny("][1];
                    temp = [temp componentsSeparatedByString:@");"][0];
                    altdestiny = temp;
                    processed = true;
                }
                if ([line hasPrefix:@"        setPilotCapacity("]) {
                    NSString *temp = [line componentsSeparatedByString:@"        setPilotCapacity("][1];
                    temp = [temp componentsSeparatedByString:@");"][0];
                    pilotcapacity = temp.intValue;
                    processed = true;
                }
                if ([line hasPrefix:@"        setGameText("]) {
                    gametext = [line componentsSeparatedByString:@"        setGameText(\""][1];
                    gametext = [gametext componentsSeparatedByString:@"\");"][0];
                    processed = true;
                }
                if ([line hasPrefix:@"        setLore("]) {
                    lore = [line componentsSeparatedByString:@"        setLore(\""][1];
                    lore = [lore componentsSeparatedByString:@"\");"][0];
                    processed = true;
                }
                if ([line hasPrefix:@"        setLocationLightSideGameText("]) {
                    lightgametext = [line componentsSeparatedByString:@"        setLocationLightSideGameText(\""][1];
                    lightgametext = [lightgametext componentsSeparatedByString:@"\");"][0];
                    processed = true;
                }
                if ([line hasPrefix:@"        setLocationDarkSideGameText("]) {
                    darkgametext = [line componentsSeparatedByString:@"        setLocationDarkSideGameText(\""][1];
                    darkgametext = [darkgametext componentsSeparatedByString:@"\");"][0];
                    processed = true;
                }
                if ([line hasPrefix:@"        addIcon("]) {
                    NSString *temp = [line componentsSeparatedByString:@"        addIcon("][1];
                    temp = [temp componentsSeparatedByString:@");"][0];
                    NSArray<NSString *> *components = [temp componentsSeparatedByString:@", "];
                    CountedIcon *icon = [CountedIcon new];
                    icon.name = components[0];
                    if (components.count == 2) {
                        icon.howMany = components[1].intValue;
                    }
                    else
                    {
                        icon.howMany = 0;
                    }
                    [countedicons addObject:icon];
                    processed = true;
                }
                if ([line hasPrefix:@"        addIcons("]) {
                    NSString *temp = [line componentsSeparatedByString:@"        addIcons("][1];
                    temp = [temp componentsSeparatedByString:@");"][0];
                    NSArray<NSString *> *components = [temp componentsSeparatedByString:@", "];
                    for (NSString *component in components) {
                        [icons addObject:component];
                    }
                    processed = true;
                }
                if ([line hasPrefix:@"        addKeyword("]) {
                    NSString *temp = [line componentsSeparatedByString:@"        addKeyword("][1];
                    temp = [temp componentsSeparatedByString:@");"][0];
                    [keywords addObject:temp];
                    processed = true;
                }
                if ([line hasPrefix:@"        addKeywords("]) {
                    NSString *temp = [line componentsSeparatedByString:@"        addKeywords("][1];
                    temp = [temp componentsSeparatedByString:@");"][0];
                    NSArray<NSString *> *components = [temp componentsSeparatedByString:@", "];
                    for (NSString *component in components) {
                        [keywords addObject:component];
                    }
                    processed = true;
                }
                if (processed == false && ([line hasPrefix:@"        add"] || [line hasPrefix:@"        set"]) && (![line hasPrefix:@"        addComboCardTitles"] && ![line hasPrefix:@"        addComboCard"] && ![line hasPrefix:@"        setComboCard"])) {
                    NSLog(@"debug me : %@", line);
                }
            }
            
            if ([type isEqualToString:@"(null)"] || type == nil) {
             //   NSLog(@"debug me");
            }
            
            if (side == nil && [title isEqualToString:@"Hyperoute Navigation Chart"] == false) {
                NSLog(@"debug me");
            }
            
            // patches
            if ([type isEqualToString:@"Objective"]) {
                if (isFront == 0 && [title componentsSeparatedByString:@" / "].count > 1) {
                    title = [title componentsSeparatedByString:@" / "][1];
                }
            }
            

            
            //NSLog(@"set = %@, type = %@, subtype = %@, title = %@, blueprint = %@, destiny = %@, deploy = %@, power = %@, ability = %@, forfeit = %@, unqiue = %@, side = %@, gametext = %@, dg = %@, lg = %@, lore = %@, isFront = %d, icons = %@, keywords = %@, playzone = %@", set, type, subtype, title, blueprintid, destiny, deploy, power, ability, forfeit, unique, side, gametext, darkgametext, lightgametext, lore, isFront, icons, keywords, playZone);
            //for (CountedIcon *icon in countedicons) {
            //    NSLog(@"icon = %@, %d", icon.name, icon.howMany);
            //}
            NSString *artName = blueprintid;
            
            NSString *assetFolder = [NSString stringWithFormat:@"cards/%@/%@", side, [set stringByReplacingOccurrencesOfString:@" " withString:@""]];
            if ([[NSFileManager defaultManager] fileExistsAtPath:assetFolder] == NO) {
              NSError *error;
              [[NSFileManager defaultManager] createDirectoryAtPath:assetFolder withIntermediateDirectories:YES attributes:nil error:&error];
              if (error) NSLog(@"error");
            }
            NSString *assetPath = [NSString stringWithFormat:@"cards/%@/%@/cardasset_%@.asset", side, [set stringByReplacingOccurrencesOfString:@" " withString:@""], artName];
            if ([[NSFileManager defaultManager] createFileAtPath:assetPath contents:nil attributes:nil]) {
                NSString *finalStr = @"%YAML 1.1";
                NSString *newStr = @"%TAG !u! tag:unity3d.com,2011:";
                finalStr = patch(finalStr, newStr);
                newStr = @"--- !u!114 &11400000";
                finalStr = patch(finalStr, newStr);
                newStr = @"MonoBehaviour:";
                finalStr = patch(finalStr, newStr);
                
                newStr = @"  m_ObjectHideFlags: 0";
                finalStr = patch(finalStr, newStr);
                newStr = @"  m_CorrespondingSourceObject: {fileID: 0}";
                finalStr = patch(finalStr, newStr);
                newStr = @"  m_PrefabInstance: {fileID: 0}";
                finalStr = patch(finalStr, newStr);
                newStr = @"  m_PrefabAsset: {fileID: 0}";
                finalStr = patch(finalStr, newStr);
                newStr = @"  m_GameObject: {fileID: 0}";
                finalStr = patch(finalStr, newStr);
                newStr = @"  m_Enabled: 1";
                finalStr = patch(finalStr, newStr);
                newStr = @"  m_EditorHideFlags: 0";
                finalStr = patch(finalStr, newStr);
                newStr = @"  m_Script: {fileID: 11500000, guid: 1103e9063c502bb4aa86ca7059f6b817, type: 3}";
                finalStr = patch(finalStr, newStr);
                
                newStr = [NSString stringWithFormat:@"  m_Name: card_%@", artName];
                finalStr = patch(finalStr, newStr);
                newStr = @"  m_EditorClassIdentifier:";
                finalStr = patch(finalStr, newStr);
                newStr = @"  cardType: {fileID: 0}";
                finalStr = patch(finalStr, newStr);
                newStr = [NSString stringWithFormat:@"  side: %d", [side isEqualToString:@"dark"]?2:1];
                finalStr = patch(finalStr, newStr);
                int typeId = 0;
                if ([type isEqualToString:@"Admiral's Order"]) {
                  typeId = 1;
                } else if ([type isEqualToString:@"Character"]) {
                  typeId = 2;
                } else if ([type isEqualToString:@"Creature"]) {
                  typeId = 3;
                } else if ([type isEqualToString:@"Defensive Shield"]) {
                  typeId = 4;
                } else if ([type isEqualToString:@"Interrupt"]) {
                  typeId = 5;
                } else if ([type isEqualToString:@"Effect"]) {
                  typeId = 6;
                } else if ([type isEqualToString:@"Epic Event"]) {
                  typeId = 7;
                  } else if ([type isEqualToString:@"Jedi Test"]) {
                    typeId = 8;
                    } else if ([type isEqualToString:@"Objective"]) {
                      typeId = 9;
                      } else if ([type isEqualToString:@"Podracer"]) {
                        typeId = 10;
                        } else if ([type isEqualToString:@"Starship"]) {
                          typeId = 11;
                          } else if ([type isEqualToString:@"Vehicle"]) {
                            typeId = 12;
                            } else if ([type isEqualToString:@"Location"]) {
                              typeId = 13;
                              } else if ([type isEqualToString:@"Device"]) {
                                typeId = 14;
                                } else if ([type isEqualToString:@"Weapon"]) {
                                  typeId = 16;
                }
                newStr = [NSString stringWithFormat:@"  type: %d", typeId];
                finalStr = patch(finalStr, newStr);
                newStr = [NSString stringWithFormat:@"  destiny: %@", destiny];
                finalStr = patch(finalStr, newStr);
                newStr = [NSString stringWithFormat:@"  ability: %@", ability];
                finalStr = patch(finalStr, newStr);
                newStr = [NSString stringWithFormat:@"  deploy: %@", deploy];
                finalStr = patch(finalStr, newStr);
                newStr = [NSString stringWithFormat:@"  forfeit: %@", forfeit];
                finalStr = patch(finalStr, newStr);
                newStr = [NSString stringWithFormat:@"  power: %@", power];
                finalStr = patch(finalStr, newStr);
                newStr = [NSString stringWithFormat:@"  altdestiny: %@", altdestiny];
                finalStr = patch(finalStr, newStr);
                newStr = [NSString stringWithFormat:@"  armor: %@", armor];
                finalStr = patch(finalStr, newStr);
                newStr = [NSString stringWithFormat:@"  politics: %@", power];
                finalStr = patch(finalStr, newStr);
                newStr = [NSString stringWithFormat:@"  maneuver: %@", maneuver];
                finalStr = patch(finalStr, newStr);
                newStr = [NSString stringWithFormat:@"  hyperspeed: %@", hyperspeed];
                finalStr = patch(finalStr, newStr);
                newStr = [NSString stringWithFormat:@"  landspeed: %@", landspeed];
                finalStr = patch(finalStr, newStr);
                newStr = [NSString stringWithFormat:@"  ferocity: %@", ferocity];
                finalStr = patch(finalStr, newStr);
                newStr = [NSString stringWithFormat:@"  defense: %@", defense];
                finalStr = patch(finalStr, newStr);
                newStr = [NSString stringWithFormat:@"  parsec: %@", parsec];
                finalStr = patch(finalStr, newStr);
                newStr = [NSString stringWithFormat:@"  title: \"%@\"", title];
                finalStr = patch(finalStr, newStr);
                  newStr = [NSString stringWithFormat:@"  unique: %@", unique];
                finalStr = patch(finalStr, newStr);
                  newStr = [NSString stringWithFormat:@"  setName: %@", set];
                  finalStr = patch(finalStr, newStr);
                newStr = [NSString stringWithFormat:@"  cardId: %@", blueprintid];
                finalStr = patch(finalStr, newStr);
                if ([lore containsString:@"\""]) {
                    NSLog(@"debug me ");
                }
                newStr = [NSString stringWithFormat:@"  flavor: \"%@\"", lore];
                finalStr = patch(finalStr, newStr);
                if ([gametext containsString:@"\""]) {
                    NSLog(@"debug me ");
                }
                newStr = [NSString stringWithFormat:@"  rules: \"%@\"", gametext];
                finalStr = patch(finalStr, newStr);
                newStr = [NSString stringWithFormat:@"  subType: %@", subtype];
                finalStr = patch(finalStr, newStr);
                if ([darkgametext containsString:@"\""]) {
                    NSLog(@"debug me ");
                }
                newStr = [NSString stringWithFormat:@"  darkRules: \"%@\"", darkgametext];
                finalStr = patch(finalStr, newStr);
                if ([lightgametext containsString:@"\""]) {
                    NSLog(@"debug me ");
                }
                newStr = [NSString stringWithFormat:@"  lightRules: \"%@\"", lightgametext];
                finalStr = patch(finalStr, newStr);
                newStr = [NSString stringWithFormat:@"  playZone: %@", playZone];
                finalStr = patch(finalStr, newStr);
                newStr = [NSString stringWithFormat:@"  matchingstarship: %@", matchingstarship];
                finalStr = patch(finalStr, newStr);
                newStr = [NSString stringWithFormat:@"  species: %@", species];
                finalStr = patch(finalStr, newStr);
                newStr = [NSString stringWithFormat:@"  category: %@", category];
                finalStr = patch(finalStr, newStr);
                newStr = [NSString stringWithFormat:@"  matchingSystem: %@", matchingSystem];
                finalStr = patch(finalStr, newStr);
                newStr = [NSString stringWithFormat:@"  isFront: %d", isFront];
                finalStr = patch(finalStr, newStr);
                newStr = [NSString stringWithFormat:@"  deployUsingBothForcePiles: %d", deployUsingBothForcePiles];
                finalStr = patch(finalStr, newStr);
                newStr = [NSString stringWithFormat:@"  mayDbeployAsUndercoverSpy: %d", mayDbeployAsUndercoverSpy];
                finalStr = patch(finalStr, newStr);
                newStr = [NSString stringWithFormat:@"  deploysAsUndercoverSpy: %d", deploysAsUndercoverSpy];
                finalStr = patch(finalStr, newStr);
                newStr = [NSString stringWithFormat:@"  alternateImageSuffix: %d", alternateImageSuffix];
                finalStr = patch(finalStr, newStr);
                newStr = [NSString stringWithFormat:@"  blueprintId: %@", blueprintid];
                finalStr = patch(finalStr, newStr);
                newStr = [NSString stringWithFormat:@"  virtualSuffix: %d", virtualSuffix];
                finalStr = patch(finalStr, newStr);
                newStr = [NSString stringWithFormat:@"  immuneToOpponentsObjective: %d", immuneToOpponentsObjective];
                finalStr = patch(finalStr, newStr);
                newStr = [NSString stringWithFormat:@"  doesNotCountTowardsDeckLimit: %d", doesNotCountTowardsDeckLimit];
                finalStr = patch(finalStr, newStr);
                newStr = [NSString stringWithFormat:@"  characterPersonaOnlyWhileOnTable: %d", characterPersonaOnlyWhileOnTable];
                finalStr = patch(finalStr, newStr);
                newStr = [NSString stringWithFormat:@"  mayNotBePlacedInReserveDeck: %d", mayNotBePlacedInReserveDeck];
                finalStr = patch(finalStr, newStr);
                newStr = [NSString stringWithFormat:@"  interiorSiteVehicle: %d", interiorSiteVehicle];
                finalStr = patch(finalStr, newStr);
                newStr = [NSString stringWithFormat:@"  alwaysStolen: %d", alwaysStolen];
                finalStr = patch(finalStr, newStr);
                newStr = [NSString stringWithFormat:@"  frontOfDoubleSidedCard: %d", frontOfDoubleSidedCard];
                finalStr = patch(finalStr, newStr);
                newStr = [NSString stringWithFormat:@"  pilotcapacity: %d", pilotcapacity];
                finalStr = patch(finalStr, newStr);
                newStr = [NSString stringWithFormat:@"  astromechcapacity: %d", astromechcapacity];
                finalStr = patch(finalStr, newStr);
                newStr = [NSString stringWithFormat:@"  passengercapacity: %d", passengercapacity];
                finalStr = patch(finalStr, newStr);
                newStr = [NSString stringWithFormat:@"  drivercapacity: %d", drivercapacity];
                finalStr = patch(finalStr, newStr);
                newStr = [NSString stringWithFormat:@"  pilotorpassengercapacity: %d", pilotorpassengercapacity];
                finalStr = patch(finalStr, newStr);
                newStr = [NSString stringWithFormat:@"  vehicleCapacity: %d", vehicleCapacity];
                finalStr = patch(finalStr, newStr);
                newStr = [NSString stringWithFormat:@"  tieCapacity: %d", tieCapacity];
                finalStr = patch(finalStr, newStr);
                newStr = [NSString stringWithFormat:@"  starfighterCapacity: %d", starfighterCapacity];
                finalStr = patch(finalStr, newStr);
                if (false && replacementForSquadron != nil) {
                    if (replacementForSquadron.filter == nil) { replacementForSquadron.filter = @""; }
                    newStr = [NSString stringWithFormat:@"  replacementForSquadron: { filter: %@, howMany: %d }", replacementForSquadron.filter, replacementForSquadron.howMany];
                    finalStr = patch(finalStr, newStr);
                }
                if (false && capitalShipCapacity != nil) {
                    if (capitalShipCapacity.filter == nil) { capitalShipCapacity.filter = @""; }
                    newStr = [NSString stringWithFormat:@"  capitalShipCapacity: { filter: %@, howMany: %d }", capitalShipCapacity.filter, capitalShipCapacity.howMany];
                    finalStr = patch(finalStr, newStr);
                }
                if (false && matchingCharacterFilter != nil) {
                    if (matchingCharacterFilter.filter == nil) { matchingCharacterFilter.filter = @""; }
                    newStr = [NSString stringWithFormat:@"  matchingCharacterFilter: { filter: %@, items: ", matchingCharacterFilter.filter];
                    for (NSString *item in matchingCharacterFilter.items) {
                        if (item == matchingCharacterFilter.items[matchingCharacterFilter.items.count-1]) {
                            newStr = [NSString stringWithFormat:@"%@%@ ", newStr, item];
                        }
                        else
                        {
                            newStr = [NSString stringWithFormat:@"%@%@,", newStr, item];
                        }
                    }
                    newStr = [NSString stringWithFormat:@"%@ }", newStr];
                    finalStr = patch(finalStr, newStr);
                }
                if (false && matchingVehicleFilter != nil) {
                    if (matchingVehicleFilter.filter == nil) { matchingVehicleFilter.filter = @""; }
                    newStr = [NSString stringWithFormat:@"  matchingVehicleFilter: { filter: %@, items: ", matchingVehicleFilter.filter];
                    for (NSString *item in matchingVehicleFilter.items) {
                        if (item == matchingVehicleFilter.items[matchingVehicleFilter.items.count-1]) {
                            newStr = [NSString stringWithFormat:@"%@%@ ", newStr, item];
                        }
                        else
                        {
                            newStr = [NSString stringWithFormat:@"%@%@,", newStr, item];
                        }
                    }
                    newStr = [NSString stringWithFormat:@"%@ }", newStr];
                    finalStr = patch(finalStr, newStr);
                }
                newStr = [NSString stringWithFormat:@"  icons: ["];
                for (NSString *item in icons) {
                    if (item == icons[icons.count-1]) {
                        newStr = [NSString stringWithFormat:@"%@%@]", newStr, item];
                    }
                    else
                    {
                        newStr = [NSString stringWithFormat:@"%@%@, ", newStr, item];
                    }
                }
                if (icons.count == 0) {
                    newStr = [NSString stringWithFormat:@"%@]", newStr];
                }
                finalStr = patch(finalStr, newStr);
                newStr = [NSString stringWithFormat:@"  keywords: ["];
                for (NSString *item in keywords) {
                    if (item == keywords[keywords.count-1]) {
                        newStr = [NSString stringWithFormat:@"%@%@]", newStr, item];
                    }
                    else
                    {
                        newStr = [NSString stringWithFormat:@"%@%@, ", newStr, item];
                    }
                }
                if (keywords.count == 0) {
                    newStr = [NSString stringWithFormat:@"%@]", newStr];
                }
                finalStr = patch(finalStr, newStr);
                newStr = [NSString stringWithFormat:@"  countedicons: ["];
                for (CountedIcon *item in countedicons) {
                    if (item == countedicons[countedicons.count-1]) {
                        newStr = [NSString stringWithFormat:@"%@%@|%d]", newStr, item.name, item.howMany];
                    }
                    else
                    {
                        newStr = [NSString stringWithFormat:@"%@%@|%d, ", newStr, item.name, item.howMany];
                    }
                }
                if (countedicons.count == 0) {
                    newStr = [NSString stringWithFormat:@"%@]", newStr];
                }
                finalStr = patch(finalStr, newStr);
                newStr = [NSString stringWithFormat:@"  immunetocardtitle: ["];
                for (NSString *item in immunetocardtitle) {
                    if (item == immunetocardtitle[immunetocardtitle.count-1]) {
                        newStr = [NSString stringWithFormat:@"%@%@]", newStr, item];
                    }
                    else
                    {
                        newStr = [NSString stringWithFormat:@"%@%@, ", newStr, item];
                    }
                }
                if (immunetocardtitle.count == 0) {
                    newStr = [NSString stringWithFormat:@"%@]", newStr];
                }
                finalStr = patch(finalStr, newStr);
                newStr = [NSString stringWithFormat:@"  personas: ["];
                for (NSString *item in personas) {
                    if (item == personas[personas.count-1]) {
                        newStr = [NSString stringWithFormat:@"%@%@]", newStr, item];
                    }
                    else
                    {
                        newStr = [NSString stringWithFormat:@"%@%@, ", newStr, item];
                    }
                }
                if (personas.count == 0) {
                    newStr = [NSString stringWithFormat:@"%@]", newStr];
                }
                finalStr = patch(finalStr, newStr);
                newStr = [NSString stringWithFormat:@"  modeltypes: ["];
                for (NSString *item in modeltypes) {
                    if (item == modeltypes[modeltypes.count-1]) {
                        newStr = [NSString stringWithFormat:@"%@%@]", newStr, item];
                    }
                    else
                    {
                        newStr = [NSString stringWithFormat:@"%@%@, ", newStr, item];
                    }
                }
                if (modeltypes.count == 0) {
                    newStr = [NSString stringWithFormat:@"%@]", newStr];
                }
                finalStr = patch(finalStr, newStr);
                newStr = [NSString stringWithFormat:@"  matchingpilots: ["];
                for (NSString *item in matchingpilots) {
                    if (item == matchingpilots[matchingpilots.count-1]) {
                        newStr = [NSString stringWithFormat:@"%@%@]", newStr, item];
                    }
                    else
                    {
                        newStr = [NSString stringWithFormat:@"%@%@, ", newStr, item];
                    }
                }
                if (matchingpilots.count == 0) {
                    newStr = [NSString stringWithFormat:@"%@]", newStr];
                }
                finalStr = patch(finalStr, newStr);
                newStr = [NSString stringWithFormat:@"  mayNotBePartOfSystem: ["];
                for (NSString *item in mayNotBePartOfSystem) {
                    if (item == mayNotBePartOfSystem[mayNotBePartOfSystem.count-1]) {
                        newStr = [NSString stringWithFormat:@"%@%@]", newStr, item];
                    }
                    else
                    {
                        newStr = [NSString stringWithFormat:@"%@%@, ", newStr, item];
                    }
                }
                if (mayNotBePartOfSystem.count == 0) {
                    newStr = [NSString stringWithFormat:@"%@]", newStr];
                }
                finalStr = patch(finalStr, newStr);
                
                [finalStr writeToFile:assetPath atomically:YES encoding:NSUTF8StringEncoding error:nil];
                
                if (false) {//}[type isEqualToString:@"Weapon"]) {
                    set = [set stringByReplacingOccurrencesOfString:@"'" withString:@""];
                    NSLog(@"found one: %@, %@, %@", title, set, side);
                    NSString *imgPath = [NSString stringWithFormat:@"./orig_art/"];
                    NSString *fixedSide = @"Dark";
                    if ([side isEqualToString:@"light"]) {
                        fixedSide = @"Light";
                    }
                    if ([set isEqualToString:@"Premium (Premiere Introductory Two Player Game)"]) {
                        imgPath = [NSString stringWithFormat:@"%@Premium/Premiere Intro 2 Player/", imgPath];
                    } else if ([set isEqualToString:@"Premium (Official Tournament Sealed Deck)"]) {
                        imgPath = [NSString stringWithFormat:@"%@Premium/Official Tournament Sealed Deck/", imgPath];
                    } else if ([set isEqualToString:@"Premium (Enhanced Premiere)"]) {
                        imgPath = [NSString stringWithFormat:@"%@Premium/Enhanced Premiere/", imgPath];
                    } else if ([set isEqualToString:@"Premium (Empire Strikes Back Introductory Two Player Game)"]) {
                        imgPath = [NSString stringWithFormat:@"%@Premium/ESB Intro 2 Player/", imgPath];
                    } else if ([set isEqualToString:@"Premium (Jedi Pack)"]) {
                        imgPath = [NSString stringWithFormat:@"%@Premium/Jedi Pack/", imgPath];
                    } else if ([set isEqualToString:@"Premium (Enhanced Cloud City)"]) {
                        imgPath = [NSString stringWithFormat:@"%@Premium/Enhanced Cloud City/", imgPath];
                    } else if ([set isEqualToString:@"Premium (Enhanced Jabbas Palace)"]) {
                        imgPath = [NSString stringWithFormat:@"%@Premium/Enhanced Jabbas Palace/", imgPath];
                    } else if ([set isEqualToString:@"Virtual Demonstration Deck"]) {
                        imgPath = [NSString stringWithFormat:@"%@Premium/Virtual Demonstration Deck/", imgPath];
                    } else if ([set isEqualToString:@"Second Anthology"]) {
                        imgPath = [NSString stringWithFormat:@"%@Premium/Second Anthology/", imgPath];
                    } else if ([set isEqualToString:@"First Anthology"]) {
                        imgPath = [NSString stringWithFormat:@"%@Premium/First Anthology/", imgPath];
                    } else if ([set isEqualToString:@"Premium (Rebel Leader Pack)"]) {
                        imgPath = [NSString stringWithFormat:@"%@Premium/Rebel Leader Pack/", imgPath];
                    } else if ([set isEqualToString:@"Premium (Third Anthology)"]) {
                        imgPath = [NSString stringWithFormat:@"%@Premium/Third Anthology/", imgPath];
                    } else if ([set isEqualToString:@"Premium (Jabbas Palace Sealed Deck)"]) {
                        imgPath = [NSString stringWithFormat:@"%@Premium/Jabbas Palace Sealed Deck/", imgPath];
                    } else if ([set isEqualToString:@"Set 1"]) {
                        imgPath = [NSString stringWithFormat:@"%@Set 1/Set 1/%@/", imgPath, fixedSide];
                    } else if ([set isEqualToString:@"Set 2"]) {
                        imgPath = [NSString stringWithFormat:@"%@Set 2/Set 2/%@/", imgPath, fixedSide];
                    } else if ([set isEqualToString:@"Set 3"]) {
                        imgPath = [NSString stringWithFormat:@"%@Set 3/Set 3/%@/", imgPath, fixedSide];
                    } else if ([set isEqualToString:@"Set 4"]) {
                        imgPath = [NSString stringWithFormat:@"%@Set 4/Set 4/%@/", imgPath, fixedSide];
                    } else if ([set isEqualToString:@"Set 6"]) {
                         imgPath = [NSString stringWithFormat:@"%@Set 6/%@/", imgPath, fixedSide];
                    } else if ([set isEqualToString:@"Set 5"]) {
                         imgPath = [NSString stringWithFormat:@"%@Set 5/%@/", imgPath, fixedSide];
                    } else if ([set isEqualToString:@"Set 8"]) {
                         imgPath = [NSString stringWithFormat:@"%@Set 8/Set 8/%@/", imgPath, fixedSide];
                    } else if ([set isEqualToString:@"Set 7"]) {
                         imgPath = [NSString stringWithFormat:@"%@Set 7/Set 7/%@/", imgPath, fixedSide];
                    } else if ([set isEqualToString:@"Set 0"]) {
                         imgPath = [NSString stringWithFormat:@"%@Set 0/Set 0/%@/", imgPath, fixedSide];
                    } else {
                        imgPath = [NSString stringWithFormat:@"%@%@ %@/", imgPath, set, fixedSide];
                    }
                    NSString *fixedTitle = [title stringByReplacingOccurrencesOfString:@"'" withString:@""];
                    fixedTitle = [fixedTitle stringByReplacingOccurrencesOfString:@"." withString:@""];
                    fixedTitle = [fixedTitle stringByReplacingOccurrencesOfString:@"," withString:@""];
                    NSString *finalPath = [NSString stringWithFormat:@"%@%@.tif", imgPath, fixedTitle];
                    NSImage *image = [[NSImage alloc] initWithContentsOfFile:finalPath];
                    if (image == nil) {
                        fixedTitle = [fixedTitle componentsSeparatedByString:@" ("][0];
                        finalPath = [NSString stringWithFormat:@"%@%@.tif", imgPath, fixedTitle];
                        image = [[NSImage alloc] initWithContentsOfFile:finalPath];
                        if (image == nil) {
                            fixedTitle = [fixedTitle stringByReplacingOccurrencesOfString:@"-" withString:@""];
                            fixedTitle = [fixedTitle stringByReplacingOccurrencesOfString:@"?" withString:@""];
                            fixedTitle = [fixedTitle stringByReplacingOccurrencesOfString:@"!" withString:@""];
                            fixedTitle = [fixedTitle stringByReplacingOccurrencesOfString:@":" withString:@""];
                            finalPath = [NSString stringWithFormat:@"%@%@.tif", imgPath, fixedTitle];
                            image = [[NSImage alloc] initWithContentsOfFile:finalPath];
                            if (image == nil) {
                                if ([blueprintid isEqualToString:@"106_002"]) {
                                    fixedTitle = @"Corulag Light";
                                    finalPath = [NSString stringWithFormat:@"%@%@.tif", imgPath, fixedTitle];
                                    image = [[NSImage alloc] initWithContentsOfFile:finalPath];
                                }
                                if ([blueprintid isEqualToString:@"106_012"]) {
                                    fixedTitle = @"Corulag Dark";
                                    finalPath = [NSString stringWithFormat:@"%@%@.tif", imgPath, fixedTitle];
                                    image = [[NSImage alloc] initWithContentsOfFile:finalPath];
                                }
                                if ([title isEqualToString:@"Skiff"] && [blueprintid isEqualToString:@"112_006"])
                                {
                                    fixedTitle = @"Racing Skiff Light";
                                    finalPath = [NSString stringWithFormat:@"%@%@.tif", imgPath, fixedTitle];
                                    image = [[NSImage alloc] initWithContentsOfFile:finalPath];
                                }
                                if ([title isEqualToString:@"Skiff"] && [blueprintid isEqualToString:@"112_018"])
                                {
                                    fixedTitle = @"Racing Skiff Dark";
                                    finalPath = [NSString stringWithFormat:@"%@%@.tif", imgPath, fixedTitle];
                                    image = [[NSImage alloc] initWithContentsOfFile:finalPath];
                                }
                                if ([blueprintid isEqualToString:@"112_008"])
                                {
                                    fixedTitle = @"Stun Blaster Light";
                                    finalPath = [NSString stringWithFormat:@"%@%@.tif", imgPath, fixedTitle];
                                    image = [[NSImage alloc] initWithContentsOfFile:finalPath];
                                }
                                if ([blueprintid isEqualToString:@"112_019"])
                                {
                                    fixedTitle = @"Stun Blaster Dark";
                                    finalPath = [NSString stringWithFormat:@"%@%@.tif", imgPath, fixedTitle];
                                    image = [[NSImage alloc] initWithContentsOfFile:finalPath];
                                }
                                if (image == nil) {
                                    NSLog(@"debug me");
                                }
                            }
                        }
                    }
                    // edit the image
                    // new path
                    NSString *assetFolderImg = [NSString stringWithFormat:@"images/%@/%@", side, [set stringByReplacingOccurrencesOfString:@" " withString:@""]];
                    if ([[NSFileManager defaultManager] fileExistsAtPath:assetFolderImg] == NO) {
                      NSError *error;
                      [[NSFileManager defaultManager] createDirectoryAtPath:assetFolderImg withIntermediateDirectories:YES attributes:nil error:&error];
                      if (error) NSLog(@"error");
                    }
                    NSString *assetPathImg = [NSString stringWithFormat:@"images/%@/%@/cardimg_%@.png", side, [set stringByReplacingOccurrencesOfString:@" " withString:@""], blueprintid];
                    if ([[NSFileManager defaultManager] createFileAtPath:assetPathImg contents:nil attributes:nil]) {
                        // write it out
                        

//                        if ([type isEqualToString:@"Objective"]) {
//                            NSBitmapImageRep *rep = [NSBitmapImageRep imageRepWithData:image.TIFFRepresentation];
//                            NSData *data = [rep representationUsingType:NSBitmapImageFileTypePNG properties:@{}];
//                            [data writeToFile:assetPathImg atomically:YES];
//                        } else {
                            NSTask *task = [[NSTask alloc] init];
                            [task setLaunchPath:@"/bin/bash"];
                            NSString *statement;
                            if ([blueprintid isEqualToString:@"4_081"] || [blueprintid isEqualToString:@"4_081"] || [blueprintid isEqualToString:@"4_082"] || [blueprintid isEqualToString:@"4_155"] || [blueprintid isEqualToString:@"4_156"] || [blueprintid isEqualToString:@"5_077"] || [blueprintid isEqualToString:@"5_085"] || [blueprintid isEqualToString:@"5_165"] || [blueprintid isEqualToString:@"5_174"] || [blueprintid isEqualToString:@"9_143"] || [blueprintid isEqualToString:@"9_144"] || [blueprintid isEqualToString:@"9_146"]) {
                                statement = [NSString stringWithFormat:@"convert '%@' '%@'", finalPath, assetPathImg];
                            }
                            else
                            {
//                                if ([lore isEqualToString:@"(null)"] || [lore isEqualToString:@""] || lore == nil) {
//                                    statement = [NSString stringWithFormat:@"convert '%@' -crop 1202x820+149+291 '%@'", finalPath, assetPathImg];
//                                } else {
                                    statement = [NSString stringWithFormat:@"convert '%@' -crop 1223x851+136+548 '%@'", finalPath, assetPathImg];
//                                }
                            }
                            NSArray *args = [NSArray arrayWithObjects:@"-l",
                                             @"-c",
                                             statement, //Assuming git is the launch path you want to run
                                             nil];
                            [task setArguments: args];
                            [task launch];
                            //NSTask *t = [NSTask launchedTaskWithLaunchPath:statement arguments:@[finalPath, @"-crop 1223x851+140+559", assetPathImg]];
//                        }
                    }
                }
            }
        }
    }
    return 0;
}

