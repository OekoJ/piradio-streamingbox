# Raspberry Piradio Streamingbox
Turn a Raspberry Pi into a live audio streaming-box. Using Darkice to stream the high quality audio input to some external server (e.g. icecast). Useful for an external radio studio to bring the sound to the fm transmitter or just to run an internet radio.

[Detailed explanation and workshop how to set-up (in German)](http://www.qrtxt.de/piradio-streamingbox/)


<p>
<img class="aligncenter size-full wp-image-491" src="http://www.qrtxt.de/wp-content/uploads/2017/06/streamingbox1.jpg" alt="" width="280" height="186" srcset="http://www.qrtxt.de/wp-content/uploads/2017/06/streamingbox1.jpg 700w, http://www.qrtxt.de/wp-content/uploads/2017/06/streamingbox1-300x200.jpg 300w, http://www.qrtxt.de/wp-content/uploads/2017/06/streamingbox1-1x1.jpg 1w" sizes="(max-width: 700px) 100vw, 700px" />
<img class="aligncenter size-full wp-image-492" src="http://www.qrtxt.de/wp-content/uploads/2017/06/streamingbox2.jpg" alt="" width="280" height="186" srcset="http://www.qrtxt.de/wp-content/uploads/2017/06/streamingbox2.jpg 700w, http://www.qrtxt.de/wp-content/uploads/2017/06/streamingbox2-300x200.jpg 300w, http://www.qrtxt.de/wp-content/uploads/2017/06/streamingbox2-1x1.jpg 1w" sizes="(max-width: 700px) 100vw, 700px" />
<img class="aligncenter size-full wp-image-493" src="http://www.qrtxt.de/wp-content/uploads/2017/06/streamingbox3.jpg" alt="" width="280" height="186" srcset="http://www.qrtxt.de/wp-content/uploads/2017/06/streamingbox3.jpg 700w, http://www.qrtxt.de/wp-content/uploads/2017/06/streamingbox3-300x200.jpg 300w, http://www.qrtxt.de/wp-content/uploads/2017/06/streamingbox3-1x1.jpg 1w" sizes="(max-width: 700px) 100vw, 700px" /></p>
<ul>
<li><a target="_blank" href="http://www.qrtxt.de/piradio-streamingbox/#idee">Die Idee der Piradio Streamingbox</a></li>
<li><a target="_blank" href="http://www.qrtxt.de/piradio-streamingbox/#installation">Installation des Betriebssystems</a></li>
<li><a target="_blank" href="http://www.qrtxt.de/piradio-streamingbox/#systemeinstellungen">Systemeinstellungen für das Betriebssystem</a></li>
<li><a target="_blank" href="http://www.qrtxt.de/piradio-streamingbox/#streamingsoftware">Installation der Streaming-Software</a></li>
<li><a target="_blank" href="http://www.qrtxt.de/piradio-streamingbox/#wlan">WLAN konfigurieren</a></li>
<li><a target="_blank" href="http://www.qrtxt.de/piradio-streamingbox/#autostart">Autostart einrichten</a></li>
<li><a target="_blank" href="http://www.qrtxt.de/piradio-streamingbox/#shutdown">Shutdown-Knopf nachrüsten</a></li>
<li><a target="_blank" href="http://www.qrtxt.de/piradio-streamingbox/#LED">Feedback mit Bereitschafts-LED</a></li>
<li><a target="_blank" href="http://www.qrtxt.de/piradio-streamingbox/#USB">Interaktionen mit einem USB-Stick</a></li>
<li><a target="_blank" href="http://www.qrtxt.de/piradio-streamingbox/#hilfsprogramme">Nützliche Hilfsprogramme</a></li>
<li><a target="_blank" href="http://www.qrtxt.de/piradio-streamingbox/#verbesserungen">Was sonst noch verbessert werden könnte</a></li>
<li><a target="_blank" href="http://www.qrtxt.de/piradio-streamingbox/#download">Download</a></li>
</ul>
<h2 id="idee">Die Idee der Piradio Streamingbox</h2>
<p>Die Piradio Streamingbox soll ein Audiosignal in einer Qualität, die für Radiosendungen ausreichend ist, von einem Ort zum anderen übertragen. Sie dient also zur Live-Übertragung von Radiosendungen, kann aber natürlich auch als Live-Stream für Veranstaltungen oder für das Übertragen von Vogelgezwitscher aus dem Baumhaus (mit Internetanschluss) genutzt werden. Gleich zur Warnung vorweg: die gute Tonqualität muss man mit einer vergleichweise langen Verzögerungszeit bezahlen. Vom Hineinsprechen bis zur Ausgabe auf dem entfernten Computer können bis zu 10 Sekunden vergehen. Wenn es auf eine Latenzzeit arme Übertragung eines Audiosignals ankommt und weniger auf die Qualität, dann ist eine Telefonverbindung möglicherweise die bessere Wahl.</p>
<p>Zu ISDN-Zeiten gab es für die Tonübertragung ein technisches Gerät namens &#8222;Music Taxi&#8220;, für das während der Übertragung zwei ISDN-Leitungen blockiert waren und das in der Anschaffung und den laufenden Telefonkosten unglaublich teuer war. Im Zeiten des schnellen Internets sollte die gleiche Aufgabe viel billiger und einfacher realisierbar sein. Die Kiste soll einen Live-Audio-Stream erzeugen, ohne viele Bedienelemente auskommen, geräuschlos, sicher vor Fehlbedienung und vor allem auch billig sein. Weil der Radiosender für den ich diese Streamingbox brauche <a href="http://www.piradio.de" target="_blank" rel="noopener noreferrer">Piradio</a> heißt, liegt es nahe, als Hardware-Plattform einen Raspberry Pi zu wählen. Und so kam die Idee zu einer <em>Raspberry Piradio Streamingbox</em> oder kurz <em>Piradio Streamingbox</em>. Ein ähnliches Projekt für den Raspberry Pi wird auf der Website von <a href="http://soundtent.org/soundcamp_resources.html" target="_blank" rel="noopener noreferrer">Soundtent.org</a> beschrieben. Ich habe die von Soundtent geschriebenen Skripte auseinander genommen, weiterentwickelt und die Box noch komfortabler gestartet. Insofern kann die Piradio Streamingbox als Fortsetzung der Soundtent Box verstanden werden.</p>
