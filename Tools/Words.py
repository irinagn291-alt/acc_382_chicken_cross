from pathlib import Path
import json, plistlib
p=Path(__file__).resolve().parents[1]
rows=r'''Chicken Cross|Chicken Cross|Chicken Cross|Chicken Cross|Chicken Cross
play|Play|Spielen|Jogar|Jouer
flock|Flock|Schar|Bando|Poules
daily|Daily|Täglich|Diário|Du jour
records|Records|Rekorde|Recordes|Records
settings|Settings|Einstellungen|Ajustes|Réglages
offlineArcade|OFFLINE ARCADE|OFFLINE-ARKADE|ARCADE OFFLINE|ARCADE HORS LIGNE
steps|Steps|Schritte|Passos|Pas
best|Best|Rekord|Melhor|Recorde
coins|Coins|Münzen|Moedas|Pièces
meadow|Sunny meadow|Sonnenwiese|Prado ensolarado|Prairie ensoleillée
orchard|Green orchard|Grüner Obstgarten|Pomar verde|Verger verdoyant
harvest|Harvest fields|Erntefelder|Campos de colheita|Champs de récolte
frost|Frosty morning|Frostiger Morgen|Manhã gelada|Matin givré
pause|Pause run|Lauf pausieren|Pausar corrida|Mettre en pause
gameField|Crossing field|Spielfeld|Campo de travessia|Terrain de traversée
forward|Hop forward|Vorwärts hüpfen|Pular para frente|Avancer
left|Hop left|Nach links hüpfen|Pular à esquerda|Aller à gauche
right|Hop right|Nach rechts hüpfen|Pular à direita|Aller à droite
back|Hop back|Zurück hüpfen|Pular para trás|Reculer
readyTitle|Ready, steady,\ncross.|Auf die Plätze,\nhüpf los.|Preparar, apontar,\natravessar.|À vos marques,\ntraversez !
readyHelp|A little hen. A wide world.\nHow far will you hop?|Ein kleines Huhn. Eine weite Welt.\nWie weit hüpfst du?|Uma galinha. Um mundo imenso.\nAté onde você vai pular?|Une petite poule. Un grand monde.\nJusqu’où irez-vous ?
paused|A little breather|Eine kleine Pause|Uma pausa rápida|Une petite pause
pauseHelp|Your hen can wait right here.|Dein Huhn wartet hier auf dich.|Sua galinha espera aqui.|Votre poule vous attend ici.
runOver|A brave little run|Ein mutiger kleiner Lauf|Uma corrida corajosa|Une belle petite aventure
stepsCount|Steps: %d|Schritte: %d|Passos: %d|Pas : %d
coinsCount|Coins: %d|Münzen: %d|Moedas: %d|Pièces : %d
resume|Keep hopping|Weiterhüpfen|Continuar pulando|Continuer
endRun|Finish this run|Lauf beenden|Encerrar corrida|Terminer la partie
startRun|Let’s cross|Los geht’s|Vamos atravessar|C’est parti
again|Hop again|Noch einmal|Pular de novo|Rejouer
tryDaily|Try today’s route|Heutige Route spielen|Jogar rota de hoje|Essayer le parcours du jour
gestureHelp|Tap the field to hop · Swipe to steer|Tippen zum Hüpfen · Wischen zum Lenken|Toque para pular · Deslize para virar|Touchez pour avancer · Glissez pour diriger
yourFlock|Your little flock|Deine kleine Schar|Seu pequeno bando|Votre petit poulailler
littlePersonalities|LITTLE PERSONALITIES|KLEINE PERSÖNLICHKEITEN|PEQUENAS PERSONALIDADES|PETITS CARACTÈRES
ownedCount|Collected: %d / 6|Gesammelt: %d / 6|Coleção: %d / 6|Collection : %d / 6
flockHelp|Find coins on the path. Collect a new look. Every hen hops the same.|Finde Münzen auf dem Weg und sammle neue Farben. Jedes Huhn hüpft gleich.|Encontre moedas pelo caminho e colecione novos visuais. Todas pulam do mesmo jeito.|Ramassez des pièces et collectionnez les couleurs. Toutes les poules avancent de la même façon.
ivory|Little Ivory|Elfi|Pequena Marfim|Petite Ivoire
sunny|Sunny|Sonnchen|Ensolarada|Soleil
rose|Rosie|Röschen|Rosinha|Rosette
mint|Minty|Minze|Hortelã|Menthe
midnight|Midnight|Mitternacht|Meia-noite|Minuit
ember|Ember|Glut|Brasa|Braise
selected|Selected|Ausgewählt|Selecionada|Choisie
choose|Choose|Auswählen|Escolher|Choisir
collect|Collect|Sammeln|Colecionar|Obtenir
needCoins|Keep exploring to find more coins.|Erkunde weiter und finde mehr Münzen.|Continue explorando para encontrar moedas.|Continuez à explorer pour trouver des pièces.
dailyAdventure|Daily adventure|Tagesabenteuer|Aventura diária|Aventure du jour
freshEveryMorning|FRESH EVERY MORNING|JEDEN MORGEN NEU|NOVIDADE A CADA MANHÃ|DU NOUVEAU CHAQUE MATIN
todayLocation|TODAY’S LOCATION|HEUTIGER ORT|LOCAL DE HOJE|LIEU DU JOUR
dailyHelp|One route for the whole day. Learn the rhythm and beat your own distance.|Eine Route für den ganzen Tag. Lerne den Rhythmus und verbessere deine Strecke.|Uma rota para o dia inteiro. Aprenda o ritmo e supere sua distância.|Un parcours pour toute la journée. Trouvez le rythme et dépassez votre distance.
startDaily|Start daily route|Tagesroute starten|Iniciar rota diária|Jouer le parcours du jour
missionDistance|Go far on the daily route|Weit auf der Tagesroute kommen|Avançar na rota diária|Avancer sur le parcours du jour
missionCoins|Gather coins today|Heute Münzen sammeln|Juntar moedas hoje|Ramasser des pièces aujourd’hui
missionRuns|Finish three runs today|Heute drei Läufe beenden|Concluir três corridas hoje|Terminer trois parties aujourd’hui
locations|Seasonal places|Orte der Jahreszeiten|Lugares das estações|Lieux de saison
seasonsHelp|Every place is always open. Pick a landscape for your next free run.|Alle Orte sind immer offen. Wähle eine Landschaft für deinen nächsten freien Lauf.|Todos os lugares estão abertos. Escolha uma paisagem para a próxima corrida livre.|Tous les lieux sont ouverts. Choisissez un paysage pour votre prochaine partie libre.
explore|Explore this place|Diesen Ort erkunden|Explorar este lugar|Explorer ce lieu
yourRecords|Your records|Deine Rekorde|Seus recordes|Vos records
everyHopCounts|EVERY HOP COUNTS|JEDER HÜPFER ZÄHLT|CADA PULO CONTA|CHAQUE PAS COMPTE
allTime|All time|Insgesamt|Geral|Depuis le début
today|Today|Heute|Hoje|Aujourd’hui
gameCenter|Game Center|Game Center|Game Center|Game Center
gcHelp|Compare distances with Game Center. Optional sign-in; your local records are always available.|Vergleiche Strecken im Game Center. Die Anmeldung ist freiwillig; lokale Rekorde sind immer verfügbar.|Compare distâncias no Game Center. A conexão é opcional; seus recordes locais estão sempre disponíveis.|Comparez vos distances dans Game Center. La connexion est facultative ; vos records locaux restent disponibles.
openGameCenter|Open Game Center|Game Center öffnen|Abrir Game Center|Ouvrir Game Center
gcConnecting|Connecting to Game Center…|Verbindung zum Game Center…|Conectando ao Game Center…|Connexion à Game Center…
gcReady|Game Center connected.|Game Center ist verbunden.|Game Center conectado.|Game Center est connecté.
gcUnavailable|Game Center is unavailable. Your distance stays saved here and can sync after reconnecting.|Game Center ist nicht verfügbar. Deine Strecke bleibt hier gespeichert und kann später übertragen werden.|Game Center indisponível. Sua distância está salva aqui e pode ser sincronizada ao reconectar.|Game Center est indisponible. Votre distance reste enregistrée ici et pourra être synchronisée à la reconnexion.
weekRecords|This week’s best runs|Beste Läufe dieser Woche|Melhores corridas da semana|Meilleures parties de la semaine
noRecords|Your first adventure belongs here.\nFinish a run to see your record.|Dein erstes Abenteuer gehört hierher.\nBeende einen Lauf, um deinen Rekord zu sehen.|Sua primeira aventura começa aqui.\nConclua uma corrida para ver seu recorde.|Votre première aventure vous attend.\nTerminez une partie pour voir votre record.
noRecordsShort|Finish a run to begin.|Beende deinen ersten Lauf.|Conclua a primeira corrida.|Terminez une première partie.
dailyRun|Daily route|Tagesroute|Rota diária|Parcours du jour
freeRun|Free run|Freier Lauf|Corrida livre|Partie libre
grownUps|For grown-ups|Für Erwachsene|Para adultos|Pour les adultes
gateHelp|Ask a grown-up to answer before opening system services.|Bitte einen Erwachsenen um die Antwort, um Systemdienste zu öffnen.|Peça a um adulto para responder antes de abrir os serviços do sistema.|Demandez à un adulte de répondre pour ouvrir les services du système.
answer|Answer|Antwort|Resposta|Réponse
tryAgain|Give it another try.|Versuche es noch einmal.|Tente mais uma vez.|Essayez encore.
continue|Continue|Weiter|Continuar|Continuer
cancel|Cancel|Abbrechen|Cancelar|Annuler
howTo|How to cross|So spielst du|Como atravessar|Comment traverser
rulesText|Tap the field or the up arrow to hop forward. Swipe or use arrows to move sideways or back. Trees block your path. You can move back up to five rows.|Tippe aufs Feld oder den Pfeil nach oben, um vorwärts zu hüpfen. Wische oder nutze Pfeile, um seitlich oder zurück zu gehen. Bäume versperren den Weg. Du kannst bis zu fünf Reihen zurück.|Toque no campo ou na seta para cima para avançar. Deslize ou use as setas para ir aos lados ou para trás. Árvores bloqueiam o caminho. É possível recuar até cinco fileiras.|Touchez le terrain ou la flèche du haut pour avancer. Glissez ou utilisez les flèches pour aller sur les côtés ou reculer. Les arbres bloquent le passage. Vous pouvez reculer de cinq rangées.
riverHelp|Cross water on moving logs. Stay aboard and hop to the next log before it drifts away.|Überquere Flüsse auf treibenden Stämmen. Bleibe darauf und hüpfe weiter, bevor du abtreibst.|Atravesse a água nos troncos em movimento. Fique neles e pule para o próximo antes de sair do campo.|Traversez l’eau sur les troncs flottants. Restez dessus et sautez au suivant avant qu’il ne s’éloigne.
railHelp|Avoid cars. A red railway light means a train is approaching. Wait on the grass until the tracks are clear.|Weiche Autos aus. Rotes Licht an den Gleisen kündigt einen Zug an. Warte im Gras, bis die Gleise frei sind.|Desvie dos carros. A luz vermelha indica que um trem se aproxima. Espere na grama até os trilhos ficarem livres.|Évitez les voitures. Le feu rouge annonce un train. Attendez sur l’herbe que la voie soit libre.
comfort|Make it yours|Deine Einstellungen|Do seu jeito|À votre goût
haptics|Gentle haptics|Sanfte Vibrationen|Vibração suave|Vibrations légères
location|Free-run landscape|Landschaft im freien Lauf|Paisagem da corrida livre|Paysage de partie libre
seasonal|Follow the season|Der Jahreszeit folgen|Seguir a estação|Suivre la saison
reminders|Daily reminders|Tägliche Erinnerungen|Lembretes diários|Rappels quotidiens
remindersHelp|A local reminder at 09:00 for the new place and at 18:00 for daily tasks. No server is involved. You can turn these off anytime.|Lokale Erinnerungen um 09:00 zum neuen Ort und um 18:00 zu den Tagesaufgaben. Ohne Server. Jederzeit ausschaltbar.|Lembretes locais às 09:00 para o novo lugar e às 18:00 para as tarefas diárias. Sem servidor. Desative quando quiser.|Un rappel local à 09:00 pour le nouveau lieu et à 18:00 pour les défis du jour. Aucun serveur. Désactivez-les à tout moment.
notificationsDenied|Reminders are disabled in system settings. All game features still work.|Erinnerungen sind in den Systemeinstellungen deaktiviert. Das Spiel funktioniert weiterhin vollständig.|Os lembretes estão desativados nos ajustes do sistema. Todo o jogo continua funcionando.|Les rappels sont désactivés dans les réglages système. Toutes les fonctions du jeu restent disponibles.
systemSettings|Open system settings|Systemeinstellungen öffnen|Abrir ajustes do sistema|Ouvrir les réglages système
dailyReminders|Remind me each day|Täglich erinnern|Lembrar todos os dias|Me rappeler chaque jour
privacy|Your privacy|Deine Privatsphäre|Sua privacidade|Votre confidentialité
privacyText|Your routes, coins, hens and records stay on this device. Widgets read the same local save. No ads, tracking, purchases or developer servers.|Routen, Münzen, Hühner und Rekorde bleiben auf diesem Gerät. Widgets lesen denselben lokalen Spielstand. Keine Werbung, kein Tracking, keine Käufe und keine eigenen Server.|Rotas, moedas, galinhas e recordes ficam neste dispositivo. Os widgets leem os mesmos dados locais. Sem anúncios, rastreamento, compras ou servidores próprios.|Vos parcours, pièces, poules et records restent sur cet appareil. Les widgets lisent cette sauvegarde locale. Sans publicité, suivi, achats ni serveurs propres.
gcPrivacy|If you connect Game Center, Apple receives your scores and handles your Game Center profile. Disconnect below to stop future score sharing.|Wenn du Game Center verbindest, erhält Apple deine Ergebnisse und verwaltet dein Game-Center-Profil. Trenne die Verbindung, um keine weiteren Ergebnisse zu teilen.|Ao conectar o Game Center, a Apple recebe suas pontuações e cuida do seu perfil. Desconecte abaixo para parar de compartilhar novas pontuações.|Si vous connectez Game Center, Apple reçoit vos scores et gère votre profil. Déconnectez-vous ci-dessous pour arrêter l’envoi de nouveaux scores.
disconnect|Stop sharing scores|Ergebnisse nicht mehr teilen|Parar de compartilhar pontuações|Arrêter le partage des scores
erase|Erase local progress|Lokalen Fortschritt löschen|Apagar progresso local|Effacer la progression locale
eraseQuestion|Erase coins, hens and local records? Game Center records are kept by Apple.|Münzen, Hühner und lokale Rekorde löschen? Game-Center-Rekorde bleiben bei Apple.|Apagar moedas, galinhas e recordes locais? Os recordes do Game Center ficam com a Apple.|Effacer pièces, poules et records locaux ? Les records Game Center restent chez Apple.
freeForever|Free to play. No ads. Made for little adventures.|Kostenlos spielen. Ohne Werbung. Für kleine Abenteuer.|Grátis para jogar. Sem anúncios. Feito para pequenas aventuras.|Gratuit. Sans publicité. Pour de petites aventures.
done|Done|Fertig|Concluir|Terminé
traffic|A car crossed your path. Try a different rhythm.|Ein Auto hat deinen Weg gekreuzt. Versuche einen anderen Rhythmus.|Um carro cruzou seu caminho. Tente outro ritmo.|Une voiture a croisé votre chemin. Essayez un autre rythme.
train|The train was quicker. Watch the red signal next time.|Der Zug war schneller. Achte nächstes Mal auf das rote Licht.|O trem foi mais rápido. Observe o sinal vermelho na próxima.|Le train était plus rapide. Surveillez le feu rouge la prochaine fois.
water|That log drifted away. Let’s find a new path.|Der Stamm ist abgetrieben. Finde einen neuen Weg.|O tronco se afastou. Vamos achar outro caminho.|Ce tronc s’est éloigné. Trouvons un autre chemin.
finished|Your adventure is saved. Ready when you are.|Dein Abenteuer ist gespeichert. Weiter, wenn du bereit bist.|Sua aventura está salva. Pronto quando você quiser.|Votre aventure est enregistrée. Reprenez quand vous voulez.
dayEnded|A new daily route is ready. Your last route is saved.|Eine neue Tagesroute ist bereit. Deine letzte Route ist gespeichert.|Uma nova rota diária chegou. A anterior está salva.|Un nouveau parcours du jour est prêt. Le précédent est enregistré.
notifyPlace|A new daily place is ready. A little adventure awaits.|Ein neuer Tagesort ist bereit. Ein kleines Abenteuer wartet.|O novo lugar do dia chegou. Uma aventura espera por você.|Un nouveau lieu du jour est prêt. L’aventure vous attend.
notifyTasks|Today’s tasks are ready. Hop a little further.|Deine Tagesaufgaben warten. Hüpfe ein Stück weiter.|As tarefas de hoje estão prontas. Pule um pouco mais longe.|Les défis du jour sont prêts. Avancez un peu plus loin.
notificationError|Couldn’t enable reminders. You can try again later.|Erinnerungen konnten nicht aktiviert werden. Versuche es später erneut.|Não foi possível ativar os lembretes. Tente mais tarde.|Impossible d’activer les rappels. Réessayez plus tard.
todayBest|Today’s best run|Bester Lauf heute|Melhor corrida de hoje|Meilleure partie du jour
endsIn|Ends in|Endet in|Termina em|Fin dans
laneField|Grass field|Wiese|Campo de grama|Prairie
laneRoad|Road with moving cars|Straße mit fahrenden Autos|Rua com carros em movimento|Route avec voitures
laneRiver|River, stay on a log|Fluss, bleibe auf einem Stamm|Rio, fique em um tronco|Rivière, restez sur un tronc
laneRail|Railway, watch the signal|Gleise, achte auf das Signal|Ferrovia, observe o sinal|Voie ferrée, surveillez le feu
widgetDescription|Your daily route, little flock and local records. Always available offline.|Deine Tagesroute, kleine Schar und lokalen Rekorde. Immer offline verfügbar.|Sua rota diária, seu bando e recordes locais. Sempre disponíveis offline.|Votre parcours du jour, vos poules et vos records locaux. Toujours hors ligne.
'''
langs=['en','de','pt-BR','fr']
d={}
for line in rows.strip().splitlines():
    values=line.split('|')
    if len(values)!=5: raise ValueError(line)
    key,*text=values
    d[key]={'extractionState':'manual','localizations':{l:{'stringUnit':{'state':'translated','value':v.replace('\\n','\n')}} for l,v in zip(langs,text)}}
(p/'Resources/Localizable.xcstrings').write_text(json.dumps({'sourceLanguage':'en','strings':d,'version':'1.0'},ensure_ascii=False,indent=2))
(p/'Resources/InfoPlist.xcstrings').write_text(json.dumps({'sourceLanguage':'en','strings':{'CFBundleDisplayName':d['Chicken Cross']},'version':'1.0'},ensure_ascii=False,indent=2))
privacy={'NSPrivacyTracking':False,'NSPrivacyTrackingDomains':[],'NSPrivacyCollectedDataTypes':[],'NSPrivacyAccessedAPITypes':[{'NSPrivacyAccessedAPIType':'NSPrivacyAccessedAPICategoryUserDefaults','NSPrivacyAccessedAPITypeReasons':['CA92.1','1C8F.1']}]}
(p/'Resources/PrivacyInfo.xcprivacy').write_bytes(plistlib.dumps(privacy))
print(len(d),'keys in',len(langs),'languages')
