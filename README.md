PocketSphinx tutorial for Estonian
=================================

This repository contains tools and models for Estonian speech recognition using PocketSphinx.
Since this is mainly targetted to Estonian developers, the rest of the document is in Estonian.

Sissejuhatus
--------------

Siin kirjeldatakse, kuidas kasutada PocketSphninxi eestikeelseks kõnetuvastuseks.


Eeldused
--------

 * Linux
 
### PocketSphinx

Kompileeri ja installeeri sphinxbase ja pocketsphinx, soovitavalt nightly snapshot: http://cmusphinx.sourceforge.net/wiki/download/
 

Grammatika-põhine tuvastus
--------------------------

### JSGF

Kõige lihtsam on kasutada kõnetuvastust grammatika-põhise keelemudeliga. Näiteks olgu meil robot, mis oskab sõita edasi ja tagasi, ning pöörata vasakule ja paremale. Me tahamegi, et kõnetuvastaja saaks aru käsklustest á la: "sõida edasi", "sõida viis meetrit tagasi", "pööra paremale" jms. Kõigepealt peame siis välja mõtlema grammatika, mis selliseid käske "aktsepteerib" (ja muid käske, näit. "pööra viis meetrit vaskule" soovitavalt mitte). PocketSphinxile tuleb grammatika ette anda JSGF formaadis. Näiteks ülalkirjeldatud käske aktsepteerib järgmine grammatika:

    #JSGF V1.0;

    grammar robot;

    public <command> = <liigu> | <keera>;
    <liigu> = (liigu | mine ) [ ( üks | kaks | kolm | neli | viis ) meetrit ] (edasi | tagasi);
    <keera> = (keera | pööra ) ( paremale | vasakule );
  
Salvestame selle faili `robot.jsgf`.

### Hääldussõnastik 

Kõnetuvastuseks on vaja ka hääldusõnastikku, milles on grammatikas kasutatud sõna kohta selle hääldus, kasutades kõnetuvastuse häälikumudelite häälikuinventari.


Hääldussõnastiku koostamiseks on kataloogis `scripts` kaks skripti. Skript `scripts/extract_jsgf_vocabulary.sh` ekstahheerib JSGF failist kõik seal kasutatavad sõnad ja `scripts/est-l2p.py` genereerib igale sõnale häälduse. Seega, selleks et genereerida hääldussõnastik failile `models/lm/robot.jsgf`, tuleks käivitada:

    ./scripts/extract_jsgf_vocabulary.sh models/lm/robot.jsgf | ./scripts/est-l2p.py > robot.dict
    
Tulemus (`robot.dict`):

    edasi e t a s i
    kaks k a k s
    keera k e e r a
    kolm k o l m
    liigu l i i k u
    meetrit m e e tt r i tt
    mine m i n e
    neli n e l i
    paremale p a r e m a l e
    pööra p oe oe r a
    tagasi t a k a s i
    vasakule v a s a kk u l e
    viis v i i s
    üks ue k s


### Käivitamine

Kõige lihtsam on kõnetuvastust testida käsurealt programmiga `pocketsphinx_continuous`. Käivitame:

    pocketsphinx_continuous -hmm models/hmm/est16k.cd_ptm_1000-mapadapt -jsgf models/lm/robot.jsgf -dict robot.dict
    
Ja ütleme näiteks mikrofoni "sõida viis meetrit edasi". Ekraanile peaks ilmuma:

    [..]
    INFO: fsg_search.c(1456): End node <sil>.212:214:220 (-485)
    INFO: fsg_search.c(1456): End node edasi.162:190:220 (-505)
    INFO: fsg_search.c(1681): lattice start node <s>.0 end node </s>.221
    INFO: ps_lattice.c(1365): Normalizer P(O) = alpha(</s>:221:221) = -184664
    INFO: ps_lattice.c(1403): Joint P(O,S) = -184677 P(S|O) = -13
    000000001: sõida viis meetrit edasi
    READY....


### Integreerimine

PocketSphinxi on väga lihtne integreerida muusse tarkvarasse, sellest hiljem.
