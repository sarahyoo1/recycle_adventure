[1mdiff --git a/assets/images/Bullet.png b/assets/images/Bullet.png[m
[1mnew file mode 100644[m
[1mindex 0000000..ae83954[m
Binary files /dev/null and b/assets/images/Bullet.png differ
[1mdiff --git a/assets/images/HUD/heart.png b/assets/images/HUD/heart.png[m
[1mnew file mode 100644[m
[1mindex 0000000..00d2201[m
Binary files /dev/null and b/assets/images/HUD/heart.png differ
[1mdiff --git a/assets/images/HUD/heart_empty.png b/assets/images/HUD/heart_empty.png[m
[1mnew file mode 100644[m
[1mindex 0000000..6891891[m
Binary files /dev/null and b/assets/images/HUD/heart_empty.png differ
[1mdiff --git a/assets/tiles/Floor-01.tmx b/assets/tiles/Floor-01.tmx[m
[1mindex af23587..7d5fb1e 100644[m
[1m--- a/assets/tiles/Floor-01.tmx[m
[1m+++ b/assets/tiles/Floor-01.tmx[m
[36m@@ -1,5 +1,5 @@[m
 <?xml version="1.0" encoding="UTF-8"?>[m
[31m-<map version="1.10" tiledversion="1.10.2" orientation="orthogonal" renderorder="right-down" width="40" height="23" tilewidth="16" tileheight="16" infinite="0" nextlayerid="5" nextobjectid="31">[m
[32m+[m[32m<map version="1.10" tiledversion="1.10.2" orientation="orthogonal" renderorder="right-down" width="40" height="23" tilewidth="16" tileheight="16" infinite="0" nextlayerid="5" nextobjectid="32">[m
  <tileset firstgid="1" source="Pixel Adventure.tsx"/>[m
  <layer id="1" name="Background" width="40" height="23">[m
   <properties>[m
[36m@@ -36,30 +36,35 @@[m
   <object id="14" name="Checkpoint" type="Checkpoint" x="368" y="128" width="64" height="64"/>[m
   <object id="20" name="Slime" type="Slime" x="288" y="288" width="32" height="32">[m
    <properties>[m
[32m+[m[32m    <property name="lives" type="int" value="5"/>[m
     <property name="offsetNegative" type="float" value="5"/>[m
     <property name="offsetPositive" type="float" value="5"/>[m
    </properties>[m
   </object>[m
   <object id="22" name="Bat" type="Bat" x="384" y="208" width="32" height="32">[m
    <properties>[m
[32m+[m[32m    <property name="lives" type="int" value="5"/>[m
     <property name="offsetNegative" type="float" value="9"/>[m
     <property name="offsetPositive" type="float" value="5"/>[m
    </properties>[m
   </object>[m
   <object id="24" name="Trunk" type="Trunk" x="224" y="288" width="32" height="32">[m
    <properties>[m
[32m+[m[32m    <property name="lives" type="int" value="3"/>[m
     <property name="offsetNegative" type="float" value="2"/>[m
     <property name="offsetPositive" type="float" value="2"/>[m
    </properties>[m
   </object>[m
   <object id="25" name="Cucumber" type="Cucumber" x="448" y="272" width="48" height="48">[m
    <properties>[m
[32m+[m[32m    <property name="lives" type="int" value="10"/>[m
     <property name="offsetNegative" type="float" value="8"/>[m
     <property name="offsetPositive" type="float" value="8"/>[m
    </properties>[m
   </object>[m
   <object id="26" name="Whale" type="Whale" x="384" y="272" width="48" height="48">[m
    <properties>[m
[32m+[m[32m    <property name="lives" type="int" value="7"/>[m
     <property name="offsetNegative" type="float" value="8"/>[m
     <property name="offsetPositive" type="float" value="8"/>[m
    </properties>[m
[1mdiff --git a/assets/tiles/Floor-02.tmx b/assets/tiles/Floor-02.tmx[m
[1mindex 6117a8a..79e5fe3 100644[m
[1m--- a/assets/tiles/Floor-02.tmx[m
[1m+++ b/assets/tiles/Floor-02.tmx[m
[36m@@ -7,28 +7,28 @@[m
    <property name="BackgroundImage" value=""/>[m
   </properties>[m
   <data encoding="csv">[m
[31m-24,24,24,24,24,24,24,24,24,24,24,24,24,24,24,24,24,24,24,24,24,24,24,24,24,24,24,24,24,24,24,24,24,24,24,24,24,24,24,24,[m
[31m-24,24,92,134,134,134,134,134,134,134,134,134,134,134,134,134,134,134,134,134,134,134,134,134,134,134,134,134,134,134,134,134,134,134,134,134,134,93,24,24,[m
[31m-24,24,113,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,111,24,24,[m
[31m-24,24,113,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,111,24,24,[m
[31m-24,24,113,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,111,24,24,[m
[31m-24,24,113,0,0,0,43,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,111,24,24,[m
[31m-24,24,113,40,41,42,43,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,40,41,42,43,111,24,24,[m
[31m-24,24,113,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,111,24,24,[m
[31m-24,24,113,0,0,0,43,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,111,24,24,[m
[31m-24,24,113,40,41,42,43,0,0,0,13,14,14,14,14,14,15,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,111,24,24,[m
[31m-24,24,113,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,40,41,42,43,111,24,24,[m
[31m-24,24,113,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,111,24,24,[m
[31m-24,24,113,40,41,42,43,0,0,0,0,0,0,0,0,0,0,0,0,0,13,14,14,14,15,0,0,0,0,0,0,0,0,0,0,0,0,111,24,24,[m
[31m-24,24,113,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,40,41,42,43,111,24,24,[m
[31m-24,24,113,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,8,8,8,8,8,0,0,0,0,0,111,24,24,[m
[31m-24,24,113,40,41,42,43,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,30,30,30,30,30,0,0,0,0,0,111,24,24,[m
[31m-24,24,113,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,184,184,30,30,30,30,30,0,0,0,0,0,111,24,24,[m
[31m-24,24,113,7,7,7,7,7,7,7,7,0,0,0,0,0,0,0,0,0,0,0,0,0,184,205,206,30,30,30,30,30,0,0,0,0,0,111,24,24,[m
[31m-24,24,113,30,30,30,30,30,30,30,30,0,0,0,0,0,0,0,0,0,0,0,0,205,206,205,206,30,30,30,30,30,0,0,0,0,0,111,24,24,[m
[31m-24,24,113,30,30,30,30,30,30,30,30,0,0,0,0,0,0,0,0,0,0,0,0,205,206,205,206,30,30,30,30,30,0,0,0,0,0,111,24,24,[m
[31m-24,24,114,90,90,90,90,90,90,90,90,90,90,90,90,90,90,90,90,90,90,90,90,90,90,90,90,90,90,90,90,90,90,90,90,90,90,115,24,24,[m
[31m-24,24,112,112,112,112,112,112,112,112,112,112,112,112,112,112,112,112,112,112,112,112,112,112,112,112,112,112,112,112,112,112,112,112,112,112,112,112,112,24,[m
[32m+[m[32m0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,[m
[32m+[m[32m0,0,0,0,0,0,0,0,0,0,0,0,0,134,134,134,134,134,134,134,134,134,134,134,0,0,0,0,0,134,134,134,0,0,0,0,0,0,0,0,[m
[32m+[m[32m0,0,113,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,111,0,0,[m
[32m+[m[32m0,0,113,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,111,0,0,[m
[32m+[m[32m0,0,113,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,111,0,0,[m
[32m+[m[32m0,0,113,0,0,0,43,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,111,0,0,[m
[32m+[m[32m0,0,113,40,41,42,43,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,40,41,42,43,111,0,0,[m
[32m+[m[32m0,0,113,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,111,0,0,[m
[32m+[m[32m0,0,113,0,0,0,43,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,111,0,0,[m
[32m+[m[32m0,0,113,40,41,42,43,0,0,0,13,14,14,14,14,14,15,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,111,0,0,[m
[32m+[m[32m0,0,113,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,40,41,42,43,111,0,0,[m
[32m+[m[32m0,0,113,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,111,0,0,[m
[32m+[m[32m0,0,113,40,41,42,43,0,0,0,0,0,0,0,0,0,0,0,0,0,13,14,14,14,15,0,0,0,0,0,0,0,0,0,0,0,0,111,0,0,[m
[32m+[m[32m0,0,113,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,40,41,42,43,111,0,0,[m
[32m+[m[32m0,0,113,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,8,8,8,8,8,0,0,0,0,0,111,0,0,[m
[32m+[m[32m0,0,113,40,41,42,43,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,30,30,30,30,30,0,0,0,0,0,111,0,0,[m
[32m+[m[32m0,0,113,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,184,184,30,30,30,30,30,0,0,0,0,0,111,0,0,[m
[32m+[m[32m0,0,113,7,7,7,7,7,7,7,7,0,0,0,0,0,0,0,0,0,0,0,0,0,184,205,206,30,30,30,30,30,0,0,0,0,0,111,0,0,[m
[32m+[m[32m0,0,113,30,30,30,30,30,30,30,30,0,0,0,0,0,0,0,0,0,0,0,0,205,206,205,206,30,30,30,30,30,0,0,0,0,0,111,0,0,[m
[32m+[m[32m0,0,113,30,30,30,30,30,30,30,30,0,0,0,0,0,0,0,0,0,0,0,0,205,206,205,206,30,30,30,30,30,0,0,0,0,0,111,0,0,[m
[