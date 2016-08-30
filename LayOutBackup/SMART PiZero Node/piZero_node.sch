<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE eagle SYSTEM "eagle.dtd">
<eagle version="7.6.0">
<drawing>
<settings>
<setting alwaysvectorfont="no"/>
<setting verticaltext="up"/>
</settings>
<grid distance="0.1" unitdist="inch" unit="inch" style="lines" multiple="1" display="no" altdistance="0.01" altunitdist="inch" altunit="inch"/>
<layers>
<layer number="1" name="Top" color="4" fill="1" visible="no" active="no"/>
<layer number="16" name="Bottom" color="1" fill="1" visible="no" active="no"/>
<layer number="17" name="Pads" color="2" fill="1" visible="no" active="no"/>
<layer number="18" name="Vias" color="2" fill="1" visible="no" active="no"/>
<layer number="19" name="Unrouted" color="6" fill="1" visible="no" active="no"/>
<layer number="20" name="Dimension" color="15" fill="1" visible="no" active="no"/>
<layer number="21" name="tPlace" color="7" fill="1" visible="no" active="no"/>
<layer number="22" name="bPlace" color="7" fill="1" visible="no" active="no"/>
<layer number="23" name="tOrigins" color="15" fill="1" visible="no" active="no"/>
<layer number="24" name="bOrigins" color="15" fill="1" visible="no" active="no"/>
<layer number="25" name="tNames" color="7" fill="1" visible="no" active="no"/>
<layer number="26" name="bNames" color="7" fill="1" visible="no" active="no"/>
<layer number="27" name="tValues" color="7" fill="1" visible="no" active="no"/>
<layer number="28" name="bValues" color="7" fill="1" visible="no" active="no"/>
<layer number="29" name="tStop" color="7" fill="3" visible="no" active="no"/>
<layer number="30" name="bStop" color="7" fill="6" visible="no" active="no"/>
<layer number="31" name="tCream" color="7" fill="4" visible="no" active="no"/>
<layer number="32" name="bCream" color="7" fill="5" visible="no" active="no"/>
<layer number="33" name="tFinish" color="6" fill="3" visible="no" active="no"/>
<layer number="34" name="bFinish" color="6" fill="6" visible="no" active="no"/>
<layer number="35" name="tGlue" color="7" fill="4" visible="no" active="no"/>
<layer number="36" name="bGlue" color="7" fill="5" visible="no" active="no"/>
<layer number="37" name="tTest" color="7" fill="1" visible="no" active="no"/>
<layer number="38" name="bTest" color="7" fill="1" visible="no" active="no"/>
<layer number="39" name="tKeepout" color="4" fill="11" visible="no" active="no"/>
<layer number="40" name="bKeepout" color="1" fill="11" visible="no" active="no"/>
<layer number="41" name="tRestrict" color="4" fill="10" visible="no" active="no"/>
<layer number="42" name="bRestrict" color="1" fill="10" visible="no" active="no"/>
<layer number="43" name="vRestrict" color="2" fill="10" visible="no" active="no"/>
<layer number="44" name="Drills" color="7" fill="1" visible="no" active="no"/>
<layer number="45" name="Holes" color="7" fill="1" visible="no" active="no"/>
<layer number="46" name="Milling" color="3" fill="1" visible="no" active="no"/>
<layer number="47" name="Measures" color="7" fill="1" visible="no" active="no"/>
<layer number="48" name="Document" color="7" fill="1" visible="no" active="no"/>
<layer number="49" name="Reference" color="7" fill="1" visible="no" active="no"/>
<layer number="50" name="dxf" color="7" fill="1" visible="no" active="no"/>
<layer number="51" name="tDocu" color="7" fill="1" visible="no" active="no"/>
<layer number="52" name="bDocu" color="7" fill="1" visible="no" active="no"/>
<layer number="53" name="tGND_GNDA" color="7" fill="1" visible="no" active="no"/>
<layer number="54" name="bGND_GNDA" color="7" fill="1" visible="no" active="no"/>
<layer number="56" name="wert" color="7" fill="1" visible="no" active="no"/>
<layer number="57" name="tCAD" color="7" fill="1" visible="no" active="no"/>
<layer number="59" name="tCarbon" color="7" fill="1" visible="no" active="no"/>
<layer number="60" name="bCarbon" color="7" fill="1" visible="no" active="no"/>
<layer number="90" name="Modules" color="5" fill="1" visible="yes" active="yes"/>
<layer number="91" name="Nets" color="2" fill="1" visible="yes" active="yes"/>
<layer number="92" name="Busses" color="1" fill="1" visible="yes" active="yes"/>
<layer number="93" name="Pins" color="2" fill="1" visible="no" active="yes"/>
<layer number="94" name="Symbols" color="4" fill="1" visible="yes" active="yes"/>
<layer number="95" name="Names" color="7" fill="1" visible="yes" active="yes"/>
<layer number="96" name="Values" color="7" fill="1" visible="yes" active="yes"/>
<layer number="97" name="Info" color="7" fill="1" visible="yes" active="yes"/>
<layer number="98" name="Guide" color="6" fill="1" visible="yes" active="yes"/>
<layer number="99" name="SpiceOrder" color="5" fill="1" visible="yes" active="yes"/>
<layer number="100" name="NonViaHole" color="7" fill="1" visible="yes" active="yes"/>
<layer number="101" name="PlacementGuide" color="7" fill="1" visible="yes" active="yes"/>
<layer number="102" name="TopSilkscreen" color="7" fill="1" visible="yes" active="yes"/>
<layer number="103" name="not_populated" color="7" fill="1" visible="yes" active="yes"/>
<layer number="104" name="BottomSilkscreen" color="7" fill="1" visible="yes" active="yes"/>
<layer number="105" name="tPlate" color="7" fill="1" visible="yes" active="yes"/>
<layer number="106" name="bPlate" color="7" fill="1" visible="yes" active="yes"/>
<layer number="107" name="Crop" color="7" fill="1" visible="yes" active="yes"/>
<layer number="108" name="tplace-old" color="10" fill="1" visible="yes" active="yes"/>
<layer number="109" name="ref-old" color="11" fill="1" visible="yes" active="yes"/>
<layer number="110" name="fp0" color="7" fill="1" visible="yes" active="yes"/>
<layer number="111" name="LPC17xx" color="7" fill="1" visible="yes" active="yes"/>
<layer number="112" name="tSilk" color="7" fill="1" visible="yes" active="yes"/>
<layer number="113" name="IDFDebug" color="4" fill="1" visible="yes" active="yes"/>
<layer number="114" name="Badge_Outline" color="7" fill="1" visible="yes" active="yes"/>
<layer number="115" name="ReferenceISLANDS" color="7" fill="1" visible="yes" active="yes"/>
<layer number="116" name="Patch_BOT" color="7" fill="1" visible="yes" active="yes"/>
<layer number="118" name="Rect_Pads" color="7" fill="1" visible="yes" active="yes"/>
<layer number="121" name="_tsilk" color="7" fill="1" visible="yes" active="yes"/>
<layer number="122" name="_bsilk" color="7" fill="1" visible="yes" active="yes"/>
<layer number="123" name="tTestmark" color="7" fill="1" visible="yes" active="yes"/>
<layer number="124" name="bTestmark" color="7" fill="1" visible="yes" active="yes"/>
<layer number="125" name="_tNames" color="7" fill="1" visible="yes" active="yes"/>
<layer number="126" name="_bNames" color="7" fill="1" visible="yes" active="yes"/>
<layer number="127" name="_tValues" color="7" fill="1" visible="yes" active="yes"/>
<layer number="128" name="_bValues" color="7" fill="1" visible="yes" active="yes"/>
<layer number="129" name="Mask" color="7" fill="1" visible="yes" active="yes"/>
<layer number="131" name="tAdjust" color="7" fill="1" visible="yes" active="yes"/>
<layer number="132" name="bAdjust" color="7" fill="1" visible="yes" active="yes"/>
<layer number="144" name="Drill_legend" color="7" fill="1" visible="yes" active="yes"/>
<layer number="150" name="Notes" color="7" fill="1" visible="yes" active="yes"/>
<layer number="151" name="HeatSink" color="7" fill="1" visible="yes" active="yes"/>
<layer number="152" name="_bDocu" color="7" fill="1" visible="yes" active="yes"/>
<layer number="153" name="FabDoc1" color="7" fill="1" visible="yes" active="yes"/>
<layer number="154" name="FabDoc2" color="7" fill="1" visible="yes" active="yes"/>
<layer number="155" name="FabDoc3" color="7" fill="1" visible="yes" active="yes"/>
<layer number="199" name="Contour" color="7" fill="1" visible="yes" active="yes"/>
<layer number="200" name="200bmp" color="7" fill="1" visible="yes" active="yes"/>
<layer number="201" name="201bmp" color="7" fill="1" visible="yes" active="yes"/>
<layer number="202" name="202bmp" color="7" fill="1" visible="yes" active="yes"/>
<layer number="203" name="203bmp" color="7" fill="1" visible="yes" active="yes"/>
<layer number="204" name="204bmp" color="7" fill="1" visible="yes" active="yes"/>
<layer number="205" name="205bmp" color="7" fill="1" visible="yes" active="yes"/>
<layer number="206" name="206bmp" color="7" fill="1" visible="yes" active="yes"/>
<layer number="207" name="207bmp" color="7" fill="1" visible="yes" active="yes"/>
<layer number="208" name="208bmp" color="7" fill="1" visible="yes" active="yes"/>
<layer number="209" name="209bmp" color="7" fill="1" visible="yes" active="yes"/>
<layer number="210" name="210bmp" color="7" fill="1" visible="yes" active="yes"/>
<layer number="211" name="211bmp" color="7" fill="1" visible="yes" active="yes"/>
<layer number="212" name="212bmp" color="7" fill="1" visible="yes" active="yes"/>
<layer number="213" name="213bmp" color="7" fill="1" visible="yes" active="yes"/>
<layer number="214" name="214bmp" color="7" fill="1" visible="yes" active="yes"/>
<layer number="215" name="215bmp" color="7" fill="1" visible="yes" active="yes"/>
<layer number="216" name="216bmp" color="7" fill="1" visible="yes" active="yes"/>
<layer number="217" name="217bmp" color="7" fill="1" visible="yes" active="yes"/>
<layer number="218" name="218bmp" color="7" fill="1" visible="yes" active="yes"/>
<layer number="219" name="219bmp" color="7" fill="1" visible="yes" active="yes"/>
<layer number="220" name="220bmp" color="7" fill="1" visible="yes" active="yes"/>
<layer number="221" name="221bmp" color="7" fill="1" visible="yes" active="yes"/>
<layer number="222" name="222bmp" color="7" fill="1" visible="yes" active="yes"/>
<layer number="223" name="223bmp" color="7" fill="1" visible="yes" active="yes"/>
<layer number="224" name="224bmp" color="7" fill="1" visible="yes" active="yes"/>
<layer number="225" name="225bmp" color="7" fill="1" visible="yes" active="yes"/>
<layer number="226" name="226bmp" color="7" fill="1" visible="yes" active="yes"/>
<layer number="227" name="227bmp" color="7" fill="1" visible="yes" active="yes"/>
<layer number="228" name="228bmp" color="7" fill="1" visible="yes" active="yes"/>
<layer number="229" name="229bmp" color="7" fill="1" visible="yes" active="yes"/>
<layer number="230" name="230bmp" color="7" fill="1" visible="yes" active="yes"/>
<layer number="231" name="231bmp" color="7" fill="1" visible="yes" active="yes"/>
<layer number="248" name="Housing" color="7" fill="1" visible="yes" active="yes"/>
<layer number="249" name="Edge" color="7" fill="1" visible="yes" active="yes"/>
<layer number="250" name="Descript" color="7" fill="1" visible="yes" active="yes"/>
<layer number="251" name="SMDround" color="7" fill="1" visible="yes" active="yes"/>
<layer number="254" name="cooling" color="7" fill="1" visible="yes" active="yes"/>
<layer number="255" name="routoute" color="7" fill="1" visible="yes" active="yes"/>
</layers>
<schematic xreflabel="%F%N/%S.%C%R" xrefpart="/%S.%C%R">
<libraries>
<library name="pizero">
<packages>
<package name="PIZERO_THOUGH_HOLE">
<wire x1="0" y1="3" x2="3" y2="0" width="0" layer="20" curve="90"/>
<wire x1="3" y1="0" x2="62" y2="0" width="0" layer="20"/>
<wire x1="62" y1="0" x2="65" y2="3" width="0" layer="20" curve="90"/>
<wire x1="65" y1="3" x2="65" y2="27" width="0" layer="20"/>
<wire x1="65" y1="27" x2="62" y2="30" width="0" layer="20" curve="90"/>
<wire x1="62" y1="30" x2="3" y2="30" width="0" layer="20"/>
<wire x1="3" y1="30" x2="0" y2="27" width="0" layer="20" curve="90"/>
<hole x="3.5" y="3.5" drill="2.8"/>
<hole x="3.5" y="26.5" drill="2.8"/>
<hole x="61.5" y="26.5" drill="2.8"/>
<hole x="61.5" y="3.5" drill="2.8"/>
<circle x="3.5" y="26.5" radius="1.55" width="3.1" layer="41"/>
<circle x="61.5" y="26.5" radius="1.55" width="3.1" layer="41"/>
<circle x="61.5" y="3.5" radius="1.55" width="3.1" layer="41"/>
<circle x="3.5" y="3.5" radius="1.55" width="3.1" layer="41"/>
<circle x="3.5" y="3.5" radius="1.55" width="3.1" layer="42"/>
<circle x="3.5" y="26.5" radius="1.55" width="3.1" layer="42"/>
<circle x="61.5" y="3.5" radius="1.55" width="3.1" layer="42"/>
<circle x="61.5" y="26.5" radius="1.55" width="3.1" layer="42"/>
<wire x1="0" y1="27" x2="0" y2="3" width="0" layer="20"/>
<wire x1="7.705" y1="28.96" x2="8.975" y2="28.96" width="0.1524" layer="21"/>
<wire x1="8.975" y1="28.96" x2="9.61" y2="28.325" width="0.1524" layer="21"/>
<wire x1="9.61" y1="28.325" x2="10.245" y2="28.96" width="0.1524" layer="21"/>
<wire x1="10.245" y1="28.96" x2="11.515" y2="28.96" width="0.1524" layer="21"/>
<wire x1="11.515" y1="28.96" x2="12.15" y2="28.325" width="0.1524" layer="21"/>
<wire x1="7.705" y1="28.96" x2="7.07" y2="28.325" width="0.1524" layer="21"/>
<wire x1="12.15" y1="28.325" x2="12.785" y2="28.96" width="0.1524" layer="21"/>
<wire x1="12.785" y1="28.96" x2="14.055" y2="28.96" width="0.1524" layer="21"/>
<wire x1="14.055" y1="28.96" x2="14.69" y2="28.325" width="0.1524" layer="21"/>
<wire x1="15.325" y1="28.96" x2="16.595" y2="28.96" width="0.1524" layer="21"/>
<wire x1="16.595" y1="28.96" x2="17.23" y2="28.325" width="0.1524" layer="21"/>
<wire x1="17.23" y1="28.325" x2="17.865" y2="28.96" width="0.1524" layer="21"/>
<wire x1="17.865" y1="28.96" x2="19.135" y2="28.96" width="0.1524" layer="21"/>
<wire x1="19.135" y1="28.96" x2="19.77" y2="28.325" width="0.1524" layer="21"/>
<wire x1="15.325" y1="28.96" x2="14.69" y2="28.325" width="0.1524" layer="21"/>
<wire x1="19.77" y1="28.325" x2="20.405" y2="28.96" width="0.1524" layer="21"/>
<wire x1="20.405" y1="28.96" x2="21.675" y2="28.96" width="0.1524" layer="21"/>
<wire x1="21.675" y1="28.96" x2="22.31" y2="28.325" width="0.1524" layer="21"/>
<wire x1="9.61" y1="24.515" x2="8.975" y2="23.88" width="0.1524" layer="21"/>
<wire x1="12.15" y1="24.515" x2="11.515" y2="23.88" width="0.1524" layer="21"/>
<wire x1="11.515" y1="23.88" x2="10.245" y2="23.88" width="0.1524" layer="21"/>
<wire x1="10.245" y1="23.88" x2="9.61" y2="24.515" width="0.1524" layer="21"/>
<wire x1="7.07" y1="28.325" x2="7.07" y2="24.515" width="0.1524" layer="21"/>
<wire x1="7.07" y1="24.515" x2="7.705" y2="23.88" width="0.1524" layer="21"/>
<wire x1="8.975" y1="23.88" x2="7.705" y2="23.88" width="0.1524" layer="21"/>
<wire x1="14.69" y1="24.515" x2="14.055" y2="23.88" width="0.1524" layer="21"/>
<wire x1="14.055" y1="23.88" x2="12.785" y2="23.88" width="0.1524" layer="21"/>
<wire x1="12.785" y1="23.88" x2="12.15" y2="24.515" width="0.1524" layer="21"/>
<wire x1="17.23" y1="24.515" x2="16.595" y2="23.88" width="0.1524" layer="21"/>
<wire x1="19.77" y1="24.515" x2="19.135" y2="23.88" width="0.1524" layer="21"/>
<wire x1="19.135" y1="23.88" x2="17.865" y2="23.88" width="0.1524" layer="21"/>
<wire x1="17.865" y1="23.88" x2="17.23" y2="24.515" width="0.1524" layer="21"/>
<wire x1="14.69" y1="24.515" x2="15.325" y2="23.88" width="0.1524" layer="21"/>
<wire x1="16.595" y1="23.88" x2="15.325" y2="23.88" width="0.1524" layer="21"/>
<wire x1="22.31" y1="24.515" x2="21.675" y2="23.88" width="0.1524" layer="21"/>
<wire x1="21.675" y1="23.88" x2="20.405" y2="23.88" width="0.1524" layer="21"/>
<wire x1="20.405" y1="23.88" x2="19.77" y2="24.515" width="0.1524" layer="21"/>
<wire x1="24.215" y1="28.96" x2="24.85" y2="28.325" width="0.1524" layer="21"/>
<wire x1="22.945" y1="28.96" x2="24.215" y2="28.96" width="0.1524" layer="21"/>
<wire x1="22.31" y1="28.325" x2="22.945" y2="28.96" width="0.1524" layer="21"/>
<wire x1="22.945" y1="23.88" x2="22.31" y2="24.515" width="0.1524" layer="21"/>
<wire x1="24.215" y1="23.88" x2="22.945" y2="23.88" width="0.1524" layer="21"/>
<wire x1="24.85" y1="24.515" x2="24.215" y2="23.88" width="0.1524" layer="21"/>
<wire x1="25.485" y1="28.96" x2="26.755" y2="28.96" width="0.1524" layer="21"/>
<wire x1="26.755" y1="28.96" x2="27.39" y2="28.325" width="0.1524" layer="21"/>
<wire x1="27.39" y1="28.325" x2="28.025" y2="28.96" width="0.1524" layer="21"/>
<wire x1="28.025" y1="28.96" x2="29.295" y2="28.96" width="0.1524" layer="21"/>
<wire x1="29.295" y1="28.96" x2="29.93" y2="28.325" width="0.1524" layer="21"/>
<wire x1="25.485" y1="28.96" x2="24.85" y2="28.325" width="0.1524" layer="21"/>
<wire x1="29.93" y1="28.325" x2="30.565" y2="28.96" width="0.1524" layer="21"/>
<wire x1="30.565" y1="28.96" x2="31.835" y2="28.96" width="0.1524" layer="21"/>
<wire x1="31.835" y1="28.96" x2="32.47" y2="28.325" width="0.1524" layer="21"/>
<wire x1="33.105" y1="28.96" x2="34.375" y2="28.96" width="0.1524" layer="21"/>
<wire x1="34.375" y1="28.96" x2="35.01" y2="28.325" width="0.1524" layer="21"/>
<wire x1="35.01" y1="28.325" x2="35.645" y2="28.96" width="0.1524" layer="21"/>
<wire x1="35.645" y1="28.96" x2="36.915" y2="28.96" width="0.1524" layer="21"/>
<wire x1="36.915" y1="28.96" x2="37.55" y2="28.325" width="0.1524" layer="21"/>
<wire x1="33.105" y1="28.96" x2="32.47" y2="28.325" width="0.1524" layer="21"/>
<wire x1="37.55" y1="28.325" x2="38.185" y2="28.96" width="0.1524" layer="21"/>
<wire x1="38.185" y1="28.96" x2="39.455" y2="28.96" width="0.1524" layer="21"/>
<wire x1="39.455" y1="28.96" x2="40.09" y2="28.325" width="0.1524" layer="21"/>
<wire x1="27.39" y1="24.515" x2="26.755" y2="23.88" width="0.1524" layer="21"/>
<wire x1="29.93" y1="24.515" x2="29.295" y2="23.88" width="0.1524" layer="21"/>
<wire x1="29.295" y1="23.88" x2="28.025" y2="23.88" width="0.1524" layer="21"/>
<wire x1="28.025" y1="23.88" x2="27.39" y2="24.515" width="0.1524" layer="21"/>
<wire x1="24.85" y1="24.515" x2="25.485" y2="23.88" width="0.1524" layer="21"/>
<wire x1="26.755" y1="23.88" x2="25.485" y2="23.88" width="0.1524" layer="21"/>
<wire x1="32.47" y1="24.515" x2="31.835" y2="23.88" width="0.1524" layer="21"/>
<wire x1="31.835" y1="23.88" x2="30.565" y2="23.88" width="0.1524" layer="21"/>
<wire x1="30.565" y1="23.88" x2="29.93" y2="24.515" width="0.1524" layer="21"/>
<wire x1="35.01" y1="24.515" x2="34.375" y2="23.88" width="0.1524" layer="21"/>
<wire x1="37.55" y1="24.515" x2="36.915" y2="23.88" width="0.1524" layer="21"/>
<wire x1="36.915" y1="23.88" x2="35.645" y2="23.88" width="0.1524" layer="21"/>
<wire x1="35.645" y1="23.88" x2="35.01" y2="24.515" width="0.1524" layer="21"/>
<wire x1="32.47" y1="24.515" x2="33.105" y2="23.88" width="0.1524" layer="21"/>
<wire x1="34.375" y1="23.88" x2="33.105" y2="23.88" width="0.1524" layer="21"/>
<wire x1="40.09" y1="24.515" x2="39.455" y2="23.88" width="0.1524" layer="21"/>
<wire x1="39.455" y1="23.88" x2="38.185" y2="23.88" width="0.1524" layer="21"/>
<wire x1="38.185" y1="23.88" x2="37.55" y2="24.515" width="0.1524" layer="21"/>
<wire x1="41.995" y1="28.96" x2="42.63" y2="28.325" width="0.1524" layer="21"/>
<wire x1="40.725" y1="28.96" x2="41.995" y2="28.96" width="0.1524" layer="21"/>
<wire x1="40.09" y1="28.325" x2="40.725" y2="28.96" width="0.1524" layer="21"/>
<wire x1="40.725" y1="23.88" x2="40.09" y2="24.515" width="0.1524" layer="21"/>
<wire x1="41.995" y1="23.88" x2="40.725" y2="23.88" width="0.1524" layer="21"/>
<wire x1="42.63" y1="24.515" x2="41.995" y2="23.88" width="0.1524" layer="21"/>
<wire x1="43.265" y1="28.96" x2="44.535" y2="28.96" width="0.1524" layer="21"/>
<wire x1="44.535" y1="28.96" x2="45.17" y2="28.325" width="0.1524" layer="21"/>
<wire x1="45.17" y1="28.325" x2="45.805" y2="28.96" width="0.1524" layer="21"/>
<wire x1="45.805" y1="28.96" x2="47.075" y2="28.96" width="0.1524" layer="21"/>
<wire x1="47.075" y1="28.96" x2="47.71" y2="28.325" width="0.1524" layer="21"/>
<wire x1="43.265" y1="28.96" x2="42.63" y2="28.325" width="0.1524" layer="21"/>
<wire x1="47.71" y1="28.325" x2="48.345" y2="28.96" width="0.1524" layer="21"/>
<wire x1="48.345" y1="28.96" x2="49.615" y2="28.96" width="0.1524" layer="21"/>
<wire x1="49.615" y1="28.96" x2="50.25" y2="28.325" width="0.1524" layer="21"/>
<wire x1="50.885" y1="28.96" x2="52.155" y2="28.96" width="0.1524" layer="21"/>
<wire x1="52.155" y1="28.96" x2="52.79" y2="28.325" width="0.1524" layer="21"/>
<wire x1="52.79" y1="28.325" x2="53.425" y2="28.96" width="0.1524" layer="21"/>
<wire x1="53.425" y1="28.96" x2="54.695" y2="28.96" width="0.1524" layer="21"/>
<wire x1="54.695" y1="28.96" x2="55.33" y2="28.325" width="0.1524" layer="21"/>
<wire x1="50.885" y1="28.96" x2="50.25" y2="28.325" width="0.1524" layer="21"/>
<wire x1="55.33" y1="28.325" x2="55.965" y2="28.96" width="0.1524" layer="21"/>
<wire x1="55.965" y1="28.96" x2="57.235" y2="28.96" width="0.1524" layer="21"/>
<wire x1="45.17" y1="24.515" x2="44.535" y2="23.88" width="0.1524" layer="21"/>
<wire x1="47.71" y1="24.515" x2="47.075" y2="23.88" width="0.1524" layer="21"/>
<wire x1="47.075" y1="23.88" x2="45.805" y2="23.88" width="0.1524" layer="21"/>
<wire x1="45.805" y1="23.88" x2="45.17" y2="24.515" width="0.1524" layer="21"/>
<wire x1="42.63" y1="24.515" x2="43.265" y2="23.88" width="0.1524" layer="21"/>
<wire x1="44.535" y1="23.88" x2="43.265" y2="23.88" width="0.1524" layer="21"/>
<wire x1="50.25" y1="24.515" x2="49.615" y2="23.88" width="0.1524" layer="21"/>
<wire x1="49.615" y1="23.88" x2="48.345" y2="23.88" width="0.1524" layer="21"/>
<wire x1="48.345" y1="23.88" x2="47.71" y2="24.515" width="0.1524" layer="21"/>
<wire x1="52.79" y1="24.515" x2="52.155" y2="23.88" width="0.1524" layer="21"/>
<wire x1="55.33" y1="24.515" x2="54.695" y2="23.88" width="0.1524" layer="21"/>
<wire x1="54.695" y1="23.88" x2="53.425" y2="23.88" width="0.1524" layer="21"/>
<wire x1="53.425" y1="23.88" x2="52.79" y2="24.515" width="0.1524" layer="21"/>
<wire x1="50.25" y1="24.515" x2="50.885" y2="23.88" width="0.1524" layer="21"/>
<wire x1="52.155" y1="23.88" x2="50.885" y2="23.88" width="0.1524" layer="21"/>
<wire x1="57.235" y1="23.88" x2="55.965" y2="23.88" width="0.1524" layer="21"/>
<wire x1="55.965" y1="23.88" x2="55.33" y2="24.515" width="0.1524" layer="21"/>
<wire x1="57.87" y1="28.325" x2="57.87" y2="24.515" width="0.1524" layer="21"/>
<wire x1="57.235" y1="28.96" x2="57.87" y2="28.325" width="0.1524" layer="21"/>
<wire x1="57.87" y1="24.515" x2="57.235" y2="23.88" width="0.1524" layer="21"/>
<rectangle x1="10.626" y1="24.896" x2="11.134" y2="25.404" layer="51"/>
<rectangle x1="8.086" y1="24.896" x2="8.594" y2="25.404" layer="51"/>
<rectangle x1="13.166" y1="24.896" x2="13.674" y2="25.404" layer="51"/>
<rectangle x1="18.246" y1="24.896" x2="18.754" y2="25.404" layer="51"/>
<rectangle x1="15.706" y1="24.896" x2="16.214" y2="25.404" layer="51"/>
<rectangle x1="20.786" y1="24.896" x2="21.294" y2="25.404" layer="51"/>
<rectangle x1="8.086" y1="27.436" x2="8.594" y2="27.944" layer="51"/>
<rectangle x1="10.626" y1="27.436" x2="11.134" y2="27.944" layer="51"/>
<rectangle x1="13.166" y1="27.436" x2="13.674" y2="27.944" layer="51"/>
<rectangle x1="15.706" y1="27.436" x2="16.214" y2="27.944" layer="51"/>
<rectangle x1="18.246" y1="27.436" x2="18.754" y2="27.944" layer="51"/>
<rectangle x1="20.786" y1="27.436" x2="21.294" y2="27.944" layer="51"/>
<rectangle x1="23.326" y1="27.436" x2="23.834" y2="27.944" layer="51"/>
<rectangle x1="23.326" y1="24.896" x2="23.834" y2="25.404" layer="51"/>
<rectangle x1="28.406" y1="24.896" x2="28.914" y2="25.404" layer="51"/>
<rectangle x1="25.866" y1="24.896" x2="26.374" y2="25.404" layer="51"/>
<rectangle x1="30.946" y1="24.896" x2="31.454" y2="25.404" layer="51"/>
<rectangle x1="36.026" y1="24.896" x2="36.534" y2="25.404" layer="51"/>
<rectangle x1="33.486" y1="24.896" x2="33.994" y2="25.404" layer="51"/>
<rectangle x1="38.566" y1="24.896" x2="39.074" y2="25.404" layer="51"/>
<rectangle x1="25.866" y1="27.436" x2="26.374" y2="27.944" layer="51"/>
<rectangle x1="28.406" y1="27.436" x2="28.914" y2="27.944" layer="51"/>
<rectangle x1="30.946" y1="27.436" x2="31.454" y2="27.944" layer="51"/>
<rectangle x1="33.486" y1="27.436" x2="33.994" y2="27.944" layer="51"/>
<rectangle x1="36.026" y1="27.436" x2="36.534" y2="27.944" layer="51"/>
<rectangle x1="38.566" y1="27.436" x2="39.074" y2="27.944" layer="51"/>
<rectangle x1="41.106" y1="27.436" x2="41.614" y2="27.944" layer="51"/>
<rectangle x1="41.106" y1="24.896" x2="41.614" y2="25.404" layer="51"/>
<rectangle x1="46.186" y1="24.896" x2="46.694" y2="25.404" layer="51"/>
<rectangle x1="43.646" y1="24.896" x2="44.154" y2="25.404" layer="51"/>
<rectangle x1="48.726" y1="24.896" x2="49.234" y2="25.404" layer="51"/>
<rectangle x1="53.806" y1="24.896" x2="54.314" y2="25.404" layer="51"/>
<rectangle x1="51.266" y1="24.896" x2="51.774" y2="25.404" layer="51"/>
<rectangle x1="56.346" y1="24.896" x2="56.854" y2="25.404" layer="51"/>
<rectangle x1="43.646" y1="27.436" x2="44.154" y2="27.944" layer="51"/>
<rectangle x1="46.186" y1="27.436" x2="46.694" y2="27.944" layer="51"/>
<rectangle x1="48.726" y1="27.436" x2="49.234" y2="27.944" layer="51"/>
<rectangle x1="51.266" y1="27.436" x2="51.774" y2="27.944" layer="51"/>
<rectangle x1="53.806" y1="27.436" x2="54.314" y2="27.944" layer="51"/>
<rectangle x1="56.346" y1="27.436" x2="56.854" y2="27.944" layer="51"/>
<pad name="1" x="8.34" y="25.15" drill="1.016" shape="square"/>
<pad name="2" x="8.34" y="27.69" drill="1.016" shape="octagon"/>
<pad name="3" x="10.88" y="25.15" drill="1.016" shape="octagon"/>
<pad name="4" x="10.88" y="27.69" drill="1.016" shape="octagon"/>
<pad name="5" x="13.42" y="25.15" drill="1.016" shape="octagon"/>
<pad name="6" x="13.42" y="27.69" drill="1.016" shape="octagon"/>
<pad name="7" x="15.96" y="25.15" drill="1.016" shape="octagon"/>
<pad name="8" x="15.96" y="27.69" drill="1.016" shape="octagon"/>
<pad name="9" x="18.5" y="25.15" drill="1.016" shape="octagon"/>
<pad name="10" x="18.5" y="27.69" drill="1.016" shape="octagon"/>
<pad name="11" x="21.04" y="25.15" drill="1.016" shape="octagon"/>
<pad name="12" x="21.04" y="27.69" drill="1.016" shape="octagon"/>
<pad name="13" x="23.58" y="25.15" drill="1.016" shape="octagon"/>
<pad name="14" x="23.58" y="27.69" drill="1.016" shape="octagon"/>
<pad name="15" x="26.12" y="25.15" drill="1.016" shape="octagon"/>
<pad name="16" x="26.12" y="27.69" drill="1.016" shape="octagon"/>
<pad name="17" x="28.66" y="25.15" drill="1.016" shape="octagon"/>
<pad name="18" x="28.66" y="27.69" drill="1.016" shape="octagon"/>
<pad name="19" x="31.2" y="25.15" drill="1.016" shape="octagon"/>
<pad name="20" x="31.2" y="27.69" drill="1.016" shape="octagon"/>
<pad name="21" x="33.74" y="25.15" drill="1.016" shape="octagon"/>
<pad name="22" x="33.74" y="27.69" drill="1.016" shape="octagon"/>
<pad name="23" x="36.28" y="25.15" drill="1.016" shape="octagon"/>
<pad name="24" x="36.28" y="27.69" drill="1.016" shape="octagon"/>
<pad name="25" x="38.82" y="25.15" drill="1.016" shape="octagon"/>
<pad name="26" x="38.82" y="27.69" drill="1.016" shape="octagon"/>
<pad name="27" x="41.36" y="25.15" drill="1.016" shape="octagon"/>
<pad name="28" x="41.36" y="27.69" drill="1.016" shape="octagon"/>
<pad name="29" x="43.9" y="25.15" drill="1.016" shape="octagon"/>
<pad name="30" x="43.9" y="27.69" drill="1.016" shape="octagon"/>
<pad name="31" x="46.44" y="25.15" drill="1.016" shape="octagon"/>
<pad name="32" x="46.44" y="27.69" drill="1.016" shape="octagon"/>
<pad name="33" x="48.98" y="25.15" drill="1.016" shape="octagon"/>
<pad name="34" x="48.98" y="27.69" drill="1.016" shape="octagon"/>
<pad name="35" x="51.52" y="25.15" drill="1.016" shape="octagon"/>
<pad name="36" x="51.52" y="27.69" drill="1.016" shape="octagon"/>
<pad name="37" x="54.06" y="25.15" drill="1.016" shape="octagon"/>
<pad name="38" x="54.06" y="27.69" drill="1.016" shape="octagon"/>
<pad name="39" x="56.6" y="25.15" drill="1.016" shape="octagon"/>
<pad name="40" x="56.6" y="27.69" drill="1.016" shape="octagon"/>
<text x="7.832" y="22.229" size="1.27" layer="21" ratio="10">1</text>
<text x="37.55" y="22.229" size="1.27" layer="27" ratio="10">&gt;VALUE</text>
<text x="19.77" y="22.229" size="1.27" layer="25" ratio="10">&gt;NAME</text>
</package>
</packages>
<symbols>
<symbol name="RPI">
<wire x1="8.89" y1="0" x2="1.27" y2="0" width="0.4064" layer="94"/>
<wire x1="6.35" y1="7.62" x2="7.62" y2="7.62" width="0.6096" layer="94"/>
<wire x1="6.35" y1="5.08" x2="7.62" y2="5.08" width="0.6096" layer="94"/>
<wire x1="6.35" y1="2.54" x2="7.62" y2="2.54" width="0.6096" layer="94"/>
<wire x1="2.54" y1="7.62" x2="3.81" y2="7.62" width="0.6096" layer="94"/>
<wire x1="2.54" y1="5.08" x2="3.81" y2="5.08" width="0.6096" layer="94"/>
<wire x1="2.54" y1="2.54" x2="3.81" y2="2.54" width="0.6096" layer="94"/>
<wire x1="6.35" y1="12.7" x2="7.62" y2="12.7" width="0.6096" layer="94"/>
<wire x1="6.35" y1="10.16" x2="7.62" y2="10.16" width="0.6096" layer="94"/>
<wire x1="2.54" y1="12.7" x2="3.81" y2="12.7" width="0.6096" layer="94"/>
<wire x1="2.54" y1="10.16" x2="3.81" y2="10.16" width="0.6096" layer="94"/>
<wire x1="6.35" y1="20.32" x2="7.62" y2="20.32" width="0.6096" layer="94"/>
<wire x1="6.35" y1="17.78" x2="7.62" y2="17.78" width="0.6096" layer="94"/>
<wire x1="6.35" y1="15.24" x2="7.62" y2="15.24" width="0.6096" layer="94"/>
<wire x1="2.54" y1="20.32" x2="3.81" y2="20.32" width="0.6096" layer="94"/>
<wire x1="2.54" y1="17.78" x2="3.81" y2="17.78" width="0.6096" layer="94"/>
<wire x1="2.54" y1="15.24" x2="3.81" y2="15.24" width="0.6096" layer="94"/>
<wire x1="6.35" y1="25.4" x2="7.62" y2="25.4" width="0.6096" layer="94"/>
<wire x1="6.35" y1="22.86" x2="7.62" y2="22.86" width="0.6096" layer="94"/>
<wire x1="2.54" y1="25.4" x2="3.81" y2="25.4" width="0.6096" layer="94"/>
<wire x1="2.54" y1="22.86" x2="3.81" y2="22.86" width="0.6096" layer="94"/>
<wire x1="6.35" y1="33.02" x2="7.62" y2="33.02" width="0.6096" layer="94"/>
<wire x1="6.35" y1="30.48" x2="7.62" y2="30.48" width="0.6096" layer="94"/>
<wire x1="6.35" y1="27.94" x2="7.62" y2="27.94" width="0.6096" layer="94"/>
<wire x1="2.54" y1="33.02" x2="3.81" y2="33.02" width="0.6096" layer="94"/>
<wire x1="2.54" y1="30.48" x2="3.81" y2="30.48" width="0.6096" layer="94"/>
<wire x1="2.54" y1="27.94" x2="3.81" y2="27.94" width="0.6096" layer="94"/>
<wire x1="6.35" y1="38.1" x2="7.62" y2="38.1" width="0.6096" layer="94"/>
<wire x1="6.35" y1="35.56" x2="7.62" y2="35.56" width="0.6096" layer="94"/>
<wire x1="2.54" y1="38.1" x2="3.81" y2="38.1" width="0.6096" layer="94"/>
<wire x1="2.54" y1="35.56" x2="3.81" y2="35.56" width="0.6096" layer="94"/>
<wire x1="6.35" y1="43.18" x2="7.62" y2="43.18" width="0.6096" layer="94"/>
<wire x1="6.35" y1="40.64" x2="7.62" y2="40.64" width="0.6096" layer="94"/>
<wire x1="2.54" y1="43.18" x2="3.81" y2="43.18" width="0.6096" layer="94"/>
<wire x1="2.54" y1="40.64" x2="3.81" y2="40.64" width="0.6096" layer="94"/>
<wire x1="1.27" y1="53.34" x2="1.27" y2="0" width="0.4064" layer="94"/>
<wire x1="8.89" y1="0" x2="8.89" y2="53.34" width="0.4064" layer="94"/>
<wire x1="1.27" y1="53.34" x2="8.89" y2="53.34" width="0.4064" layer="94"/>
<wire x1="2.54" y1="45.72" x2="3.81" y2="45.72" width="0.6096" layer="94"/>
<wire x1="2.54" y1="48.26" x2="3.81" y2="48.26" width="0.6096" layer="94"/>
<wire x1="2.54" y1="50.8" x2="3.81" y2="50.8" width="0.6096" layer="94"/>
<wire x1="6.35" y1="45.72" x2="7.62" y2="45.72" width="0.6096" layer="94"/>
<wire x1="6.35" y1="48.26" x2="7.62" y2="48.26" width="0.6096" layer="94"/>
<wire x1="6.35" y1="50.8" x2="7.62" y2="50.8" width="0.6096" layer="94"/>
<pin name="1" x="12.7" y="2.54" visible="pad" length="middle" direction="pas" swaplevel="1" rot="R180"/>
<pin name="2" x="-2.54" y="2.54" visible="pad" length="middle" direction="pas" swaplevel="1"/>
<pin name="3" x="12.7" y="5.08" visible="pad" length="middle" direction="pas" swaplevel="1" rot="R180"/>
<pin name="4" x="-2.54" y="5.08" visible="pad" length="middle" direction="pas" swaplevel="1"/>
<pin name="5" x="12.7" y="7.62" visible="pad" length="middle" direction="pas" swaplevel="1" rot="R180"/>
<pin name="6" x="-2.54" y="7.62" visible="pad" length="middle" direction="pas" swaplevel="1"/>
<pin name="7" x="12.7" y="10.16" visible="pad" length="middle" direction="pas" swaplevel="1" rot="R180"/>
<pin name="8" x="-2.54" y="10.16" visible="pad" length="middle" direction="pas" swaplevel="1"/>
<pin name="9" x="12.7" y="12.7" visible="pad" length="middle" direction="pas" swaplevel="1" rot="R180"/>
<pin name="10" x="-2.54" y="12.7" visible="pad" length="middle" direction="pas" swaplevel="1"/>
<pin name="11" x="12.7" y="15.24" visible="pad" length="middle" direction="pas" swaplevel="1" rot="R180"/>
<pin name="12" x="-2.54" y="15.24" visible="pad" length="middle" direction="pas" swaplevel="1"/>
<pin name="13" x="12.7" y="17.78" visible="pad" length="middle" direction="pas" swaplevel="1" rot="R180"/>
<pin name="14" x="-2.54" y="17.78" visible="pad" length="middle" direction="pas" swaplevel="1"/>
<pin name="15" x="12.7" y="20.32" visible="pad" length="middle" direction="pas" swaplevel="1" rot="R180"/>
<pin name="16" x="-2.54" y="20.32" visible="pad" length="middle" direction="pas" swaplevel="1"/>
<pin name="17" x="12.7" y="22.86" visible="pad" length="middle" direction="pas" swaplevel="1" rot="R180"/>
<pin name="18" x="-2.54" y="22.86" visible="pad" length="middle" direction="pas" swaplevel="1"/>
<pin name="19" x="12.7" y="25.4" visible="pad" length="middle" direction="pas" swaplevel="1" rot="R180"/>
<pin name="20" x="-2.54" y="25.4" visible="pad" length="middle" direction="pas" swaplevel="1"/>
<pin name="21" x="12.7" y="27.94" visible="pad" length="middle" direction="pas" swaplevel="1" rot="R180"/>
<pin name="22" x="-2.54" y="27.94" visible="pad" length="middle" direction="pas" swaplevel="1"/>
<pin name="23" x="12.7" y="30.48" visible="pad" length="middle" direction="pas" swaplevel="1" rot="R180"/>
<pin name="24" x="-2.54" y="30.48" visible="pad" length="middle" direction="pas" swaplevel="1"/>
<pin name="25" x="12.7" y="33.02" visible="pad" length="middle" direction="pas" swaplevel="1" rot="R180"/>
<pin name="26" x="-2.54" y="33.02" visible="pad" length="middle" direction="pas" swaplevel="1"/>
<pin name="27" x="12.7" y="35.56" visible="pad" length="middle" direction="pas" swaplevel="1" rot="R180"/>
<pin name="28" x="-2.54" y="35.56" visible="pad" length="middle" direction="pas" swaplevel="1"/>
<pin name="29" x="12.7" y="38.1" visible="pad" length="middle" direction="pas" swaplevel="1" rot="R180"/>
<pin name="30" x="-2.54" y="38.1" visible="pad" length="middle" direction="pas" swaplevel="1"/>
<pin name="31" x="12.7" y="40.64" visible="pad" length="middle" direction="pas" swaplevel="1" rot="R180"/>
<pin name="32" x="-2.54" y="40.64" visible="pad" length="middle" direction="pas" swaplevel="1"/>
<pin name="33" x="12.7" y="43.18" visible="pad" length="middle" direction="pas" swaplevel="1" rot="R180"/>
<pin name="34" x="-2.54" y="43.18" visible="pad" length="middle" direction="pas" swaplevel="1"/>
<pin name="35" x="12.7" y="45.72" visible="pad" length="middle" direction="pas" swaplevel="1" rot="R180"/>
<pin name="36" x="-2.54" y="45.72" visible="pad" length="middle" direction="pas" swaplevel="1"/>
<pin name="37" x="12.7" y="48.26" visible="pad" length="middle" direction="pas" swaplevel="1" rot="R180"/>
<pin name="38" x="-2.54" y="48.26" visible="pad" length="middle" direction="pas" swaplevel="1"/>
<pin name="39" x="12.7" y="50.8" visible="pad" length="middle" direction="pas" swaplevel="1" rot="R180"/>
<pin name="40" x="-2.54" y="50.8" visible="pad" length="middle" direction="pas" swaplevel="1"/>
<text x="1.27" y="-2.54" size="1.778" layer="96">&gt;VALUE</text>
<text x="1.27" y="54.102" size="1.778" layer="95">&gt;NAME</text>
</symbol>
</symbols>
<devicesets>
<deviceset name="PIZERO_THROUGH_HOLE">
<gates>
<gate name="1" symbol="RPI" x="0" y="0"/>
</gates>
<devices>
<device name="" package="PIZERO_THOUGH_HOLE">
<connects>
<connect gate="1" pin="1" pad="1"/>
<connect gate="1" pin="10" pad="10"/>
<connect gate="1" pin="11" pad="11"/>
<connect gate="1" pin="12" pad="12"/>
<connect gate="1" pin="13" pad="13"/>
<connect gate="1" pin="14" pad="14"/>
<connect gate="1" pin="15" pad="15"/>
<connect gate="1" pin="16" pad="16"/>
<connect gate="1" pin="17" pad="17"/>
<connect gate="1" pin="18" pad="18"/>
<connect gate="1" pin="19" pad="19"/>
<connect gate="1" pin="2" pad="2"/>
<connect gate="1" pin="20" pad="20"/>
<connect gate="1" pin="21" pad="21"/>
<connect gate="1" pin="22" pad="22"/>
<connect gate="1" pin="23" pad="23"/>
<connect gate="1" pin="24" pad="24"/>
<connect gate="1" pin="25" pad="25"/>
<connect gate="1" pin="26" pad="26"/>
<connect gate="1" pin="27" pad="27"/>
<connect gate="1" pin="28" pad="28"/>
<connect gate="1" pin="29" pad="29"/>
<connect gate="1" pin="3" pad="3"/>
<connect gate="1" pin="30" pad="30"/>
<connect gate="1" pin="31" pad="31"/>
<connect gate="1" pin="32" pad="32"/>
<connect gate="1" pin="33" pad="33"/>
<connect gate="1" pin="34" pad="34"/>
<connect gate="1" pin="35" pad="35"/>
<connect gate="1" pin="36" pad="36"/>
<connect gate="1" pin="37" pad="37"/>
<connect gate="1" pin="38" pad="38"/>
<connect gate="1" pin="39" pad="39"/>
<connect gate="1" pin="4" pad="4"/>
<connect gate="1" pin="40" pad="40"/>
<connect gate="1" pin="5" pad="5"/>
<connect gate="1" pin="6" pad="6"/>
<connect gate="1" pin="7" pad="7"/>
<connect gate="1" pin="8" pad="8"/>
<connect gate="1" pin="9" pad="9"/>
</connects>
<technologies>
<technology name=""/>
</technologies>
</device>
</devices>
</deviceset>
</devicesets>
</library>
<library name="optocoupler">
<description>&lt;b&gt;Opto Couplers&lt;/b&gt;&lt;p&gt;
Siemens, Hewlett-Packard, Texas Instuments, Sharp, Motorola&lt;p&gt;
&lt;author&gt;Created by librarian@cadsoft.de&lt;/author&gt;</description>
<packages>
<package name="DIL06">
<description>&lt;b&gt;Dual In Line Package&lt;/b&gt;</description>
<wire x1="3.81" y1="2.921" x2="-3.81" y2="2.921" width="0.1524" layer="21"/>
<wire x1="-3.81" y1="-2.921" x2="3.81" y2="-2.921" width="0.1524" layer="21"/>
<wire x1="3.81" y1="2.921" x2="3.81" y2="-2.921" width="0.1524" layer="21"/>
<wire x1="-3.81" y1="2.921" x2="-3.81" y2="1.016" width="0.1524" layer="21"/>
<wire x1="-3.81" y1="-2.921" x2="-3.81" y2="-1.016" width="0.1524" layer="21"/>
<wire x1="-3.81" y1="1.016" x2="-3.81" y2="-1.016" width="0.1524" layer="21" curve="-180"/>
<pad name="1" x="-2.54" y="-3.81" drill="0.8128" shape="offset" rot="R270"/>
<pad name="2" x="0" y="-3.81" drill="0.8128" shape="offset" rot="R270"/>
<pad name="5" x="0" y="3.81" drill="0.8128" shape="offset" rot="R90"/>
<pad name="6" x="-2.54" y="3.81" drill="0.8128" shape="offset" rot="R90"/>
<pad name="3" x="2.54" y="-3.81" drill="0.8128" shape="offset" rot="R270"/>
<pad name="4" x="2.54" y="3.81" drill="0.8128" shape="offset" rot="R90"/>
<text x="-2.413" y="-0.635" size="1.27" layer="27" ratio="10">&gt;VALUE</text>
<text x="-4.064" y="-2.921" size="1.27" layer="25" ratio="10" rot="R90">&gt;NAME</text>
</package>
<package name="DIL6-SMD">
<description>&lt;b&gt;DIL 6 SMD&lt;/b&gt;&lt;p&gt;
Source: http://www.fairchildsemi.com/pf/4N/4N35-M.html</description>
<wire x1="4.36" y1="3.18" x2="4.36" y2="-2.664" width="0.1524" layer="21"/>
<wire x1="4.36" y1="-2.664" x2="4.36" y2="-3.18" width="0.1524" layer="21"/>
<wire x1="-4.385" y1="3.18" x2="4.36" y2="3.18" width="0.1524" layer="21"/>
<wire x1="4.36" y1="-3.18" x2="-4.385" y2="-3.18" width="0.1524" layer="21"/>
<wire x1="-4.385" y1="-3.18" x2="-4.385" y2="3.18" width="0.1524" layer="21"/>
<wire x1="4.36" y1="-2.664" x2="-4.285" y2="-2.664" width="0.1524" layer="21"/>
<circle x="-3.5" y="-2" radius="0.2761" width="0" layer="21"/>
<smd name="1" x="-2.54" y="-4.645" dx="1.78" dy="1.52" layer="1"/>
<smd name="2" x="0" y="-4.645" dx="1.78" dy="1.52" layer="1"/>
<smd name="3" x="2.54" y="-4.645" dx="1.78" dy="1.52" layer="1"/>
<smd name="4" x="2.54" y="4.645" dx="1.78" dy="1.52" layer="1" rot="R180"/>
<smd name="5" x="0" y="4.645" dx="1.78" dy="1.52" layer="1" rot="R180"/>
<smd name="6" x="-2.54" y="4.645" dx="1.78" dy="1.52" layer="1" rot="R180"/>
<text x="-5.08" y="-3.175" size="1.27" layer="25" ratio="10" rot="R90">&gt;NAME</text>
<text x="-3.81" y="-0.635" size="1.27" layer="27" ratio="10">&gt;VALUE</text>
<rectangle x1="-3.145" y1="-4.95" x2="-1.92" y2="-3.2" layer="51"/>
<rectangle x1="-0.605" y1="-4.95" x2="0.62" y2="-3.2" layer="51"/>
<rectangle x1="1.935" y1="-4.95" x2="3.16" y2="-3.2" layer="51"/>
<rectangle x1="1.92" y1="3.2" x2="3.145" y2="4.95" layer="51" rot="R180"/>
<rectangle x1="-0.62" y1="3.2" x2="0.605" y2="4.95" layer="51" rot="R180"/>
<rectangle x1="-3.16" y1="3.2" x2="-1.935" y2="4.95" layer="51" rot="R180"/>
</package>
<package name="DIL6-04">
<description>&lt;b&gt;DIL 6 0.4 Inch&lt;/b&gt;&lt;p&gt;
Source: http://www.fairchildsemi.com/pf/4N/4N35-M.html</description>
<wire x1="3.81" y1="2.921" x2="-3.81" y2="2.921" width="0.1524" layer="21"/>
<wire x1="-3.81" y1="-2.921" x2="3.81" y2="-2.921" width="0.1524" layer="21"/>
<wire x1="3.81" y1="2.921" x2="3.81" y2="-2.921" width="0.1524" layer="21"/>
<wire x1="-3.81" y1="2.921" x2="-3.81" y2="1.016" width="0.1524" layer="21"/>
<wire x1="-3.81" y1="-2.921" x2="-3.81" y2="-1.016" width="0.1524" layer="21"/>
<wire x1="-3.81" y1="1.016" x2="-3.81" y2="-1.016" width="0.1524" layer="21" curve="-180"/>
<pad name="1" x="-2.54" y="-5.08" drill="0.8128" rot="R270"/>
<pad name="2" x="0" y="-5.08" drill="0.8128" rot="R270"/>
<pad name="5" x="0" y="5.08" drill="0.8128" rot="R90"/>
<pad name="6" x="-2.54" y="5.08" drill="0.8128" rot="R90"/>
<pad name="3" x="2.54" y="-5.08" drill="0.8128" rot="R270"/>
<pad name="4" x="2.54" y="5.08" drill="0.8128" rot="R90"/>
<text x="-2.413" y="-0.635" size="1.27" layer="27" ratio="10">&gt;VALUE</text>
<text x="-4.064" y="-2.921" size="1.27" layer="25" ratio="10" rot="R90">&gt;NAME</text>
<rectangle x1="-2.915" y1="-5.175" x2="-2.165" y2="-4.2" layer="51"/>
<rectangle x1="-2.915" y1="-4.2" x2="-2.165" y2="-2.975" layer="21"/>
<rectangle x1="-0.375" y1="-5.175" x2="0.375" y2="-4.2" layer="51"/>
<rectangle x1="-0.375" y1="-4.2" x2="0.375" y2="-2.975" layer="21"/>
<rectangle x1="2.165" y1="-5.175" x2="2.915" y2="-4.2" layer="51"/>
<rectangle x1="2.165" y1="-4.2" x2="2.915" y2="-2.975" layer="21"/>
<rectangle x1="2.165" y1="4.2" x2="2.915" y2="5.175" layer="51" rot="R180"/>
<rectangle x1="2.165" y1="2.975" x2="2.915" y2="4.2" layer="21" rot="R180"/>
<rectangle x1="-0.375" y1="4.2" x2="0.375" y2="5.175" layer="51" rot="R180"/>
<rectangle x1="-0.375" y1="2.975" x2="0.375" y2="4.2" layer="21" rot="R180"/>
<rectangle x1="-2.915" y1="4.2" x2="-2.165" y2="5.175" layer="51" rot="R180"/>
<rectangle x1="-2.915" y1="2.975" x2="-2.165" y2="4.2" layer="21" rot="R180"/>
</package>
<package name="DIL06B">
<description>&lt;b&gt;Dual In Line&lt;/b&gt; 0.4" Lead spacing&lt;p&gt;
Source: &lt;a href="http://www.fairchildsemi.com/ds/MO/MOC3031M.pdf"&gt; Data sheet&lt;/&lt;&gt;</description>
<wire x1="-3.81" y1="-3.175" x2="-3.81" y2="-0.635" width="0.1524" layer="21"/>
<wire x1="-3.81" y1="0.635" x2="-3.81" y2="3.175" width="0.1524" layer="21"/>
<wire x1="-3.81" y1="-0.635" x2="-3.81" y2="0.635" width="0.1524" layer="21" curve="180"/>
<wire x1="3.81" y1="-3.175" x2="3.81" y2="3.175" width="0.1524" layer="21"/>
<wire x1="3.81" y1="-3.175" x2="-3.81" y2="-3.175" width="0.1524" layer="21"/>
<wire x1="3.81" y1="3.175" x2="-3.81" y2="3.175" width="0.1524" layer="21"/>
<pad name="1" x="-2.54" y="-5.08" drill="0.8128" shape="octagon"/>
<pad name="2" x="0" y="-5.08" drill="0.8128" shape="octagon"/>
<pad name="3" x="2.54" y="-5.08" drill="0.8128" shape="octagon"/>
<pad name="4" x="2.54" y="5.08" drill="0.8128" shape="octagon"/>
<pad name="5" x="0" y="5.08" drill="0.8128" shape="octagon"/>
<pad name="6" x="-2.54" y="5.08" drill="0.8128" shape="octagon"/>
<text x="-4.318" y="-2.921" size="1.27" layer="25" ratio="10" rot="R90">&gt;NAME</text>
<text x="-3.175" y="-0.508" size="1.27" layer="27" ratio="10">&gt;VALUE</text>
<rectangle x1="-0.635" y1="-4.191" x2="0.635" y2="-3.175" layer="21"/>
<rectangle x1="1.905" y1="-4.191" x2="3.175" y2="-3.175" layer="21"/>
<rectangle x1="-3.175" y1="-4.191" x2="-1.905" y2="-3.175" layer="21"/>
<rectangle x1="-3.175" y1="3.175" x2="-1.905" y2="4.191" layer="21"/>
<rectangle x1="-0.635" y1="3.175" x2="0.635" y2="4.191" layer="21"/>
<rectangle x1="1.905" y1="3.175" x2="3.175" y2="4.191" layer="21"/>
</package>
</packages>
<symbols>
<symbol name="OK-B">
<wire x1="0" y1="-2.54" x2="0" y2="2.54" width="0.1524" layer="94"/>
<wire x1="0" y1="2.54" x2="5.08" y2="2.54" width="0.1524" layer="94"/>
<wire x1="0" y1="-2.54" x2="1.016" y2="-2.54" width="0.1524" layer="94"/>
<wire x1="-2.413" y1="-2.413" x2="-1.016" y2="-1.016" width="0.1524" layer="94"/>
<wire x1="-1.016" y1="-1.016" x2="-1.905" y2="-1.397" width="0.1524" layer="94"/>
<wire x1="-1.905" y1="-1.397" x2="-1.397" y2="-1.905" width="0.1524" layer="94"/>
<wire x1="-1.397" y1="-1.905" x2="-1.016" y2="-1.016" width="0.1524" layer="94"/>
<wire x1="-1.143" y1="0.127" x2="-2.032" y2="-0.254" width="0.1524" layer="94"/>
<wire x1="-2.032" y1="-0.254" x2="-1.524" y2="-0.762" width="0.1524" layer="94"/>
<wire x1="-1.524" y1="-0.762" x2="-1.143" y2="0.127" width="0.1524" layer="94"/>
<wire x1="-2.54" y1="-1.27" x2="-1.143" y2="0.127" width="0.1524" layer="94"/>
<wire x1="-3.175" y1="0" x2="-4.445" y2="-2.54" width="0.254" layer="94"/>
<wire x1="-4.445" y1="-2.54" x2="-5.715" y2="0" width="0.254" layer="94"/>
<wire x1="-3.175" y1="-2.54" x2="-4.445" y2="-2.54" width="0.254" layer="94"/>
<wire x1="-4.445" y1="-2.54" x2="-5.715" y2="-2.54" width="0.254" layer="94"/>
<wire x1="-3.175" y1="0" x2="-4.445" y2="0" width="0.254" layer="94"/>
<wire x1="-4.445" y1="0" x2="-4.445" y2="-2.54" width="0.254" layer="94"/>
<wire x1="-4.445" y1="0" x2="-5.715" y2="0" width="0.254" layer="94"/>
<wire x1="-6.985" y1="-7.62" x2="4.445" y2="-7.62" width="0.4064" layer="94"/>
<wire x1="-6.985" y1="5.08" x2="-6.985" y2="-7.62" width="0.4064" layer="94"/>
<wire x1="4.445" y1="5.08" x2="4.445" y2="-7.62" width="0.4064" layer="94"/>
<wire x1="-7.62" y1="2.54" x2="-4.445" y2="2.54" width="0.1524" layer="94"/>
<wire x1="-4.445" y1="2.54" x2="-4.445" y2="0" width="0.1524" layer="94"/>
<wire x1="-4.445" y1="-2.54" x2="-4.445" y2="-5.08" width="0.1524" layer="94"/>
<wire x1="-4.445" y1="-5.08" x2="-7.62" y2="-5.08" width="0.1524" layer="94"/>
<wire x1="-6.985" y1="5.08" x2="4.445" y2="5.08" width="0.4064" layer="94"/>
<wire x1="3.81" y1="0" x2="1.27" y2="-2.54" width="0.1524" layer="94"/>
<wire x1="1.27" y1="-2.54" x2="3.556" y2="-4.826" width="0.1524" layer="94"/>
<wire x1="3.81" y1="-5.08" x2="5.08" y2="-5.08" width="0.1524" layer="94"/>
<wire x1="3.81" y1="0" x2="5.08" y2="0" width="0.1524" layer="94"/>
<wire x1="3.048" y1="-3.556" x2="3.556" y2="-4.826" width="0.1524" layer="94"/>
<wire x1="3.556" y1="-4.826" x2="3.81" y2="-5.08" width="0.1524" layer="94"/>
<wire x1="3.556" y1="-4.826" x2="2.286" y2="-4.318" width="0.1524" layer="94"/>
<wire x1="2.286" y1="-4.318" x2="3.048" y2="-3.556" width="0.1524" layer="94"/>
<text x="-6.985" y="5.715" size="1.778" layer="95">&gt;NAME</text>
<text x="-6.985" y="-10.16" size="1.778" layer="96">&gt;VALUE</text>
<rectangle x1="0.889" y1="-5.08" x2="1.651" y2="0" layer="94"/>
<pin name="A" x="-10.16" y="2.54" visible="pad" length="short" direction="pas"/>
<pin name="C" x="-10.16" y="-5.08" visible="pad" length="short" direction="pas"/>
<pin name="BAS" x="7.62" y="2.54" visible="pad" length="short" direction="pas" rot="R180"/>
<pin name="EMI" x="7.62" y="-5.08" visible="pad" length="short" direction="pas" rot="R180"/>
<pin name="COL" x="7.62" y="0" visible="pad" length="short" direction="pas" rot="R180"/>
</symbol>
<symbol name="OK-TRN">
<wire x1="2.54" y1="2.54" x2="2.54" y2="5.08" width="0.1524" layer="94"/>
<wire x1="2.54" y1="5.08" x2="-0.635" y2="5.08" width="0.1524" layer="94"/>
<wire x1="-0.635" y1="5.08" x2="-0.635" y2="-1.27" width="0.1524" layer="94"/>
<wire x1="0.635" y1="0" x2="0" y2="-1.27" width="0.1524" layer="94"/>
<wire x1="0.635" y1="-1.27" x2="0.635" y2="-3.175" width="0.254" layer="94"/>
<wire x1="0.635" y1="-5.08" x2="-3.175" y2="-5.08" width="0.254" layer="94"/>
<wire x1="-3.175" y1="-5.08" x2="-3.175" y2="-1.27" width="0.254" layer="94"/>
<wire x1="-3.175" y1="-1.27" x2="-0.635" y2="-1.27" width="0.254" layer="94"/>
<wire x1="0.635" y1="-3.175" x2="2.54" y2="-3.175" width="0.1524" layer="94"/>
<wire x1="0.635" y1="-3.175" x2="0.635" y2="-5.08" width="0.254" layer="94"/>
<wire x1="-1.651" y1="-4.064" x2="-1.27" y2="-4.064" width="0.254" layer="94"/>
<wire x1="-1.27" y1="-4.064" x2="-1.27" y2="-2.413" width="0.254" layer="94"/>
<wire x1="-1.27" y1="-4.064" x2="-0.889" y2="-4.064" width="0.254" layer="94"/>
<wire x1="-1.27" y1="-2.413" x2="-1.651" y2="-2.794" width="0.254" layer="94"/>
<wire x1="-2.159" y1="-4.445" x2="-0.381" y2="-4.445" width="0.1524" layer="94"/>
<wire x1="-0.381" y1="-4.445" x2="-0.381" y2="-2.032" width="0.1524" layer="94"/>
<wire x1="-0.381" y1="-2.032" x2="-2.159" y2="-2.032" width="0.1524" layer="94"/>
<wire x1="-2.159" y1="-2.032" x2="-2.159" y2="-4.445" width="0.1524" layer="94"/>
<wire x1="0" y1="-1.27" x2="0.635" y2="-1.27" width="0.254" layer="94"/>
<wire x1="-3.048" y1="0.127" x2="-1.651" y2="1.524" width="0.1524" layer="94"/>
<wire x1="-1.651" y1="1.524" x2="-2.54" y2="1.143" width="0.1524" layer="94"/>
<wire x1="-2.54" y1="1.143" x2="-2.032" y2="0.635" width="0.1524" layer="94"/>
<wire x1="-2.032" y1="0.635" x2="-1.651" y2="1.524" width="0.1524" layer="94"/>
<wire x1="-1.778" y1="2.667" x2="-2.667" y2="2.286" width="0.1524" layer="94"/>
<wire x1="-2.667" y1="2.286" x2="-2.159" y2="1.778" width="0.1524" layer="94"/>
<wire x1="-2.159" y1="1.778" x2="-1.778" y2="2.667" width="0.1524" layer="94"/>
<wire x1="-3.175" y1="1.27" x2="-1.778" y2="2.667" width="0.1524" layer="94"/>
<wire x1="-3.81" y1="2.54" x2="-5.08" y2="0" width="0.254" layer="94"/>
<wire x1="-5.08" y1="0" x2="-6.35" y2="2.54" width="0.254" layer="94"/>
<wire x1="-3.81" y1="0" x2="-5.08" y2="0" width="0.254" layer="94"/>
<wire x1="-5.08" y1="0" x2="-6.35" y2="0" width="0.254" layer="94"/>
<wire x1="-3.81" y1="2.54" x2="-5.08" y2="2.54" width="0.254" layer="94"/>
<wire x1="-5.08" y1="2.54" x2="-5.08" y2="0" width="0.254" layer="94"/>
<wire x1="-5.08" y1="2.54" x2="-6.35" y2="2.54" width="0.254" layer="94"/>
<wire x1="-5.08" y1="0" x2="-5.08" y2="-5.08" width="0.1524" layer="94"/>
<wire x1="-5.08" y1="5.08" x2="-5.08" y2="2.54" width="0.1524" layer="94"/>
<wire x1="2.54" y1="2.54" x2="1.27" y2="0" width="0.254" layer="94"/>
<wire x1="1.27" y1="0" x2="0" y2="2.54" width="0.254" layer="94"/>
<wire x1="2.54" y1="0" x2="1.27" y2="0" width="0.254" layer="94"/>
<wire x1="1.27" y1="0" x2="0" y2="0" width="0.254" layer="94"/>
<wire x1="2.54" y1="2.54" x2="0" y2="2.54" width="0.254" layer="94"/>
<wire x1="2.54" y1="0" x2="3.81" y2="2.54" width="0.254" layer="94"/>
<wire x1="3.81" y1="2.54" x2="5.08" y2="0" width="0.254" layer="94"/>
<wire x1="2.54" y1="2.54" x2="3.81" y2="2.54" width="0.254" layer="94"/>
<wire x1="3.81" y1="2.54" x2="5.08" y2="2.54" width="0.254" layer="94"/>
<wire x1="2.54" y1="0" x2="5.08" y2="0" width="0.254" layer="94"/>
<wire x1="-0.635" y1="-1.27" x2="0" y2="-1.27" width="0.254" layer="94"/>
<wire x1="2.54" y1="5.08" x2="7.62" y2="5.08" width="0.1524" layer="94"/>
<wire x1="2.54" y1="-3.175" x2="2.54" y2="0" width="0.1524" layer="94"/>
<wire x1="-5.08" y1="5.08" x2="-7.62" y2="5.08" width="0.1524" layer="94"/>
<wire x1="-7.62" y1="-7.62" x2="6.35" y2="-7.62" width="0.4064" layer="94"/>
<wire x1="2.54" y1="-3.175" x2="2.54" y2="-5.08" width="0.1524" layer="94"/>
<wire x1="2.54" y1="-5.08" x2="7.62" y2="-5.08" width="0.1524" layer="94"/>
<wire x1="-7.62" y1="7.62" x2="6.35" y2="7.62" width="0.4064" layer="94"/>
<wire x1="6.35" y1="7.62" x2="6.35" y2="-7.62" width="0.4064" layer="94"/>
<wire x1="-7.62" y1="7.62" x2="-7.62" y2="5.08" width="0.4064" layer="94"/>
<wire x1="-7.62" y1="5.08" x2="-7.62" y2="-5.08" width="0.4064" layer="94"/>
<wire x1="-7.62" y1="-5.08" x2="-7.62" y2="-7.62" width="0.4064" layer="94"/>
<wire x1="-5.08" y1="-5.08" x2="-7.62" y2="-5.08" width="0.1524" layer="94"/>
<circle x="2.54" y="5.08" radius="0.127" width="0.4064" layer="94"/>
<circle x="2.54" y="-3.175" radius="0.127" width="0.4064" layer="94"/>
<text x="-7.6454" y="8.2296" size="1.778" layer="95">&gt;NAME</text>
<text x="-7.6454" y="-10.0838" size="1.778" layer="96">&gt;VALUE</text>
<pin name="A" x="-10.16" y="5.08" visible="pad" length="short" direction="pas"/>
<pin name="C" x="-10.16" y="-5.08" visible="pad" length="short" direction="pas"/>
<pin name="A1" x="10.16" y="-5.08" visible="pad" length="short" direction="pas" rot="R180"/>
<pin name="A2" x="10.16" y="5.08" visible="pad" length="short" direction="pas" rot="R180"/>
</symbol>
</symbols>
<devicesets>
<deviceset name="H11A*?M" prefix="OK">
<description>&lt;b&gt;General Purpose 6-Pin Phototransistor Optocouplers&lt;/b&gt;&lt;p&gt;
Source: http://www.fairchildsemi.com/ds/4N/4N35-M.pdf</description>
<gates>
<gate name="G$1" symbol="OK-B" x="0" y="0"/>
</gates>
<devices>
<device name="" package="DIL06">
<connects>
<connect gate="G$1" pin="A" pad="1"/>
<connect gate="G$1" pin="BAS" pad="6"/>
<connect gate="G$1" pin="C" pad="2"/>
<connect gate="G$1" pin="COL" pad="5"/>
<connect gate="G$1" pin="EMI" pad="4"/>
</connects>
<technologies>
<technology name="1">
<attribute name="MF" value="" constant="no"/>
<attribute name="MPN" value="H11A1-M" constant="no"/>
<attribute name="OC_FARNELL" value="1021358" constant="no"/>
<attribute name="OC_NEWARK" value="97K1793" constant="no"/>
</technology>
<technology name="2">
<attribute name="MF" value="FAIRCHILD SEMICONDUCTOR" constant="no"/>
<attribute name="MPN" value="H11A2M" constant="no"/>
<attribute name="OC_FARNELL" value="6421362" constant="no"/>
<attribute name="OC_NEWARK" value="84H5960" constant="no"/>
</technology>
<technology name="3">
<attribute name="MF" value="FAIRCHILD SEMICONDUCTOR" constant="no"/>
<attribute name="MPN" value="H11A3M" constant="no"/>
<attribute name="OC_FARNELL" value="1612459" constant="no"/>
<attribute name="OC_NEWARK" value="84H5972" constant="no"/>
</technology>
<technology name="4">
<attribute name="MF" value="VISHAY/TELEFUNKEN" constant="no"/>
<attribute name="MPN" value="H11A4" constant="no"/>
<attribute name="OC_FARNELL" value="unknown" constant="no"/>
<attribute name="OC_NEWARK" value="58K1623" constant="no"/>
</technology>
<technology name="5">
<attribute name="MF" value="FAIRCHILD SEMICONDUCTOR" constant="no"/>
<attribute name="MPN" value="H11A5M" constant="no"/>
<attribute name="OC_FARNELL" value="unknown" constant="no"/>
<attribute name="OC_NEWARK" value="84H5984" constant="no"/>
</technology>
</technologies>
</device>
<device name="S" package="DIL6-SMD">
<connects>
<connect gate="G$1" pin="A" pad="1"/>
<connect gate="G$1" pin="BAS" pad="6"/>
<connect gate="G$1" pin="C" pad="2"/>
<connect gate="G$1" pin="COL" pad="5"/>
<connect gate="G$1" pin="EMI" pad="4"/>
</connects>
<technologies>
<technology name="1">
<attribute name="MF" value="" constant="no"/>
<attribute name="MPN" value="" constant="no"/>
<attribute name="OC_FARNELL" value="unknown" constant="no"/>
<attribute name="OC_NEWARK" value="unknown" constant="no"/>
</technology>
<technology name="2">
<attribute name="MF" value="" constant="no"/>
<attribute name="MPN" value="" constant="no"/>
<attribute name="OC_FARNELL" value="unknown" constant="no"/>
<attribute name="OC_NEWARK" value="unknown" constant="no"/>
</technology>
<technology name="3">
<attribute name="MF" value="" constant="no"/>
<attribute name="MPN" value="" constant="no"/>
<attribute name="OC_FARNELL" value="unknown" constant="no"/>
<attribute name="OC_NEWARK" value="unknown" constant="no"/>
</technology>
<technology name="4">
<attribute name="MF" value="" constant="no"/>
<attribute name="MPN" value="" constant="no"/>
<attribute name="OC_FARNELL" value="unknown" constant="no"/>
<attribute name="OC_NEWARK" value="unknown" constant="no"/>
</technology>
<technology name="5">
<attribute name="MF" value="" constant="no"/>
<attribute name="MPN" value="" constant="no"/>
<attribute name="OC_FARNELL" value="unknown" constant="no"/>
<attribute name="OC_NEWARK" value="unknown" constant="no"/>
</technology>
</technologies>
</device>
<device name="T" package="DIL6-04">
<connects>
<connect gate="G$1" pin="A" pad="1"/>
<connect gate="G$1" pin="BAS" pad="6"/>
<connect gate="G$1" pin="C" pad="2"/>
<connect gate="G$1" pin="COL" pad="5"/>
<connect gate="G$1" pin="EMI" pad="4"/>
</connects>
<technologies>
<technology name="1">
<attribute name="MF" value="FAIRCHILD SEMICONDUCTOR" constant="no"/>
<attribute name="MPN" value="H11A1TV-M" constant="no"/>
<attribute name="OC_FARNELL" value="unknown" constant="no"/>
<attribute name="OC_NEWARK" value="05C2394" constant="no"/>
</technology>
<technology name="2">
<attribute name="MF" value="" constant="no"/>
<attribute name="MPN" value="" constant="no"/>
<attribute name="OC_FARNELL" value="unknown" constant="no"/>
<attribute name="OC_NEWARK" value="unknown" constant="no"/>
</technology>
<technology name="3">
<attribute name="MF" value="" constant="no"/>
<attribute name="MPN" value="" constant="no"/>
<attribute name="OC_FARNELL" value="unknown" constant="no"/>
<attribute name="OC_NEWARK" value="unknown" constant="no"/>
</technology>
<technology name="4">
<attribute name="MF" value="" constant="no"/>
<attribute name="MPN" value="" constant="no"/>
<attribute name="OC_FARNELL" value="unknown" constant="no"/>
<attribute name="OC_NEWARK" value="unknown" constant="no"/>
</technology>
<technology name="5">
<attribute name="MF" value="" constant="no"/>
<attribute name="MPN" value="" constant="no"/>
<attribute name="OC_FARNELL" value="unknown" constant="no"/>
<attribute name="OC_NEWARK" value="unknown" constant="no"/>
</technology>
</technologies>
</device>
</devices>
</deviceset>
<deviceset name="MOC30*" prefix="OK">
<description>&lt;b&gt;6-Pin DIP Zero-Cross Optoisolators Triac Driver Output&lt;/b&gt; (250/400 Volt Peak)&lt;p&gt;
Source: &lt;a href="http://www.fairchildsemi.com/ds/MO/MOC3031M.pdf"&lt; Data sheet &lt;/a&gt;&lt;br&gt;
The old path of data sheet not more available 2013-05-06.</description>
<gates>
<gate name="-1" symbol="OK-TRN" x="0" y="0"/>
</gates>
<devices>
<device name="" package="DIL06">
<connects>
<connect gate="-1" pin="A" pad="1"/>
<connect gate="-1" pin="A1" pad="4"/>
<connect gate="-1" pin="A2" pad="6"/>
<connect gate="-1" pin="C" pad="2"/>
</connects>
<technologies>
<technology name="31M">
<attribute name="MF" value="FAIRCHILD SEMICONDUCTOR" constant="no"/>
<attribute name="MPN" value="MOC3031M" constant="no"/>
<attribute name="OC_FARNELL" value="9875964" constant="no"/>
<attribute name="OC_NEWARK" value="78K6089" constant="no"/>
</technology>
<technology name="32M">
<attribute name="MF" value="FAIRCHILD SEMICONDUCTOR" constant="no"/>
<attribute name="MPN" value="MOC3032-M" constant="no"/>
<attribute name="OC_FARNELL" value="1203802" constant="no"/>
<attribute name="OC_NEWARK" value="72K8897" constant="no"/>
</technology>
<technology name="33M">
<attribute name="MF" value="FAIRCHILD SEMICONDUCTOR" constant="no"/>
<attribute name="MPN" value="MOC3033-M" constant="no"/>
<attribute name="OC_FARNELL" value="1133987" constant="no"/>
<attribute name="OC_NEWARK" value="72K8898" constant="no"/>
</technology>
<technology name="41M">
<attribute name="MF" value="FAIRCHILD SEMICONDUCTOR" constant="no"/>
<attribute name="MPN" value="MOC3041M" constant="no"/>
<attribute name="OC_FARNELL" value="1086677" constant="no"/>
<attribute name="OC_NEWARK" value="78K6090" constant="no"/>
</technology>
<technology name="42M">
<attribute name="MF" value="FAIRCHILD SEMICONDUCTOR" constant="no"/>
<attribute name="MPN" value="MOC3042-M" constant="no"/>
<attribute name="OC_FARNELL" value="1021368" constant="no"/>
<attribute name="OC_NEWARK" value="72K8899" constant="no"/>
</technology>
<technology name="43M">
<attribute name="MF" value="FAIRCHILD SEMICONDUCTOR" constant="no"/>
<attribute name="MPN" value="MOC3043-M" constant="no"/>
<attribute name="OC_FARNELL" value="1021371" constant="no"/>
<attribute name="OC_NEWARK" value="72K8900" constant="no"/>
</technology>
</technologies>
</device>
<device name="S" package="DIL6-SMD">
<connects>
<connect gate="-1" pin="A" pad="1"/>
<connect gate="-1" pin="A1" pad="4"/>
<connect gate="-1" pin="A2" pad="6"/>
<connect gate="-1" pin="C" pad="2"/>
</connects>
<technologies>
<technology name="31">
<attribute name="MF" value="FAIRCHILD SEMICONDUCTOR" constant="no"/>
<attribute name="MPN" value="MOC3031SM" constant="no"/>
<attribute name="OC_FARNELL" value="unknown" constant="no"/>
<attribute name="OC_NEWARK" value="34C1335" constant="no"/>
</technology>
<technology name="32">
<attribute name="MF" value="FAIRCHILD SEMICONDUCTOR" constant="no"/>
<attribute name="MPN" value="MOC3032S-M" constant="no"/>
<attribute name="OC_FARNELL" value="unknown" constant="no"/>
<attribute name="OC_NEWARK" value="05C2871" constant="no"/>
</technology>
<technology name="33">
<attribute name="MF" value="FAIRCHILD SEMICONDUCTOR" constant="no"/>
<attribute name="MPN" value="MOC3033S-M" constant="no"/>
<attribute name="OC_FARNELL" value="unknown" constant="no"/>
<attribute name="OC_NEWARK" value="05C2878" constant="no"/>
</technology>
<technology name="41">
<attribute name="MF" value="FAIRCHILD SEMICONDUCTOR" constant="no"/>
<attribute name="MPN" value="MOC3041S-M" constant="no"/>
<attribute name="OC_FARNELL" value="unknown" constant="no"/>
<attribute name="OC_NEWARK" value="05C2885" constant="no"/>
</technology>
<technology name="42">
<attribute name="MF" value="FAIRCHILD SEMICONDUCTOR" constant="no"/>
<attribute name="MPN" value="MOC3042SM" constant="no"/>
<attribute name="OC_FARNELL" value="unknown" constant="no"/>
<attribute name="OC_NEWARK" value="34C1339" constant="no"/>
</technology>
<technology name="43">
<attribute name="MF" value="FAIRCHILD SEMICONDUCTOR" constant="no"/>
<attribute name="MPN" value="MOC3043SM" constant="no"/>
<attribute name="OC_FARNELL" value="1505441" constant="no"/>
<attribute name="OC_NEWARK" value="78K6091" constant="no"/>
</technology>
</technologies>
</device>
<device name="T" package="DIL06B">
<connects>
<connect gate="-1" pin="A" pad="1"/>
<connect gate="-1" pin="A1" pad="4"/>
<connect gate="-1" pin="A2" pad="6"/>
<connect gate="-1" pin="C" pad="2"/>
</connects>
<technologies>
<technology name="31">
<attribute name="MF" value="" constant="no"/>
<attribute name="MPN" value="" constant="no"/>
<attribute name="OC_FARNELL" value="unknown" constant="no"/>
<attribute name="OC_NEWARK" value="unknown" constant="no"/>
</technology>
<technology name="32">
<attribute name="MF" value="" constant="no"/>
<attribute name="MPN" value="" constant="no"/>
<attribute name="OC_FARNELL" value="unknown" constant="no"/>
<attribute name="OC_NEWARK" value="unknown" constant="no"/>
</technology>
<technology name="33">
<attribute name="MF" value="FAIRCHILD SEMICONDUCTOR" constant="no"/>
<attribute name="MPN" value="MOC3033TV-M" constant="no"/>
<attribute name="OC_FARNELL" value="unknown" constant="no"/>
<attribute name="OC_NEWARK" value="05C2883" constant="no"/>
</technology>
<technology name="41">
<attribute name="MF" value="" constant="no"/>
<attribute name="MPN" value="" constant="no"/>
<attribute name="OC_FARNELL" value="unknown" constant="no"/>
<attribute name="OC_NEWARK" value="unknown" constant="no"/>
</technology>
<technology name="42">
<attribute name="MF" value="" constant="no"/>
<attribute name="MPN" value="" constant="no"/>
<attribute name="OC_FARNELL" value="unknown" constant="no"/>
<attribute name="OC_NEWARK" value="unknown" constant="no"/>
</technology>
<technology name="43">
<attribute name="MF" value="FAIRCHILD SEMICONDUCTOR" constant="no"/>
<attribute name="MPN" value="MOC3043TM" constant="no"/>
<attribute name="OC_FARNELL" value="unknown" constant="no"/>
<attribute name="OC_NEWARK" value="34C1342" constant="no"/>
</technology>
</technologies>
</device>
</devices>
</deviceset>
</devicesets>
</library>
<library name="SparkFun-Connectors">
<description>&lt;h3&gt;SparkFun Electronics' preferred foot prints&lt;/h3&gt;
In this library you'll find connectors and sockets- basically anything that can be plugged into or onto.&lt;br&gt;&lt;br&gt;
We've spent an enormous amount of time creating and checking these footprints and parts, but it is the end user's responsibility to ensure correctness and suitablity for a given componet or application. If you enjoy using this library, please buy one of our products at www.sparkfun.com.
&lt;br&gt;&lt;br&gt;
&lt;b&gt;Licensing:&lt;/b&gt; Creative Commons ShareAlike 4.0 International - https://creativecommons.org/licenses/by-sa/4.0/ 
&lt;br&gt;&lt;br&gt;
You are welcome to use this library for commercial purposes. For attribution, we ask that when you begin to sell your device using our footprint, you email us with a link to the product being sold. We want bragging rights that we helped (in a very small part) to create your 8th world wonder. We would like the opportunity to feature your device on our homepage.</description>
<packages>
<package name="1X02">
<wire x1="-0.635" y1="1.27" x2="0.635" y2="1.27" width="0.2032" layer="21"/>
<wire x1="0.635" y1="1.27" x2="1.27" y2="0.635" width="0.2032" layer="21"/>
<wire x1="1.27" y1="-0.635" x2="0.635" y2="-1.27" width="0.2032" layer="21"/>
<wire x1="1.27" y1="0.635" x2="1.905" y2="1.27" width="0.2032" layer="21"/>
<wire x1="1.905" y1="1.27" x2="3.175" y2="1.27" width="0.2032" layer="21"/>
<wire x1="3.175" y1="1.27" x2="3.81" y2="0.635" width="0.2032" layer="21"/>
<wire x1="3.81" y1="-0.635" x2="3.175" y2="-1.27" width="0.2032" layer="21"/>
<wire x1="3.175" y1="-1.27" x2="1.905" y2="-1.27" width="0.2032" layer="21"/>
<wire x1="1.905" y1="-1.27" x2="1.27" y2="-0.635" width="0.2032" layer="21"/>
<wire x1="-1.27" y1="0.635" x2="-1.27" y2="-0.635" width="0.2032" layer="21"/>
<wire x1="-0.635" y1="1.27" x2="-1.27" y2="0.635" width="0.2032" layer="21"/>
<wire x1="-1.27" y1="-0.635" x2="-0.635" y2="-1.27" width="0.2032" layer="21"/>
<wire x1="0.635" y1="-1.27" x2="-0.635" y2="-1.27" width="0.2032" layer="21"/>
<wire x1="3.81" y1="0.635" x2="3.81" y2="-0.635" width="0.2032" layer="21"/>
<pad name="1" x="0" y="0" drill="1.016" diameter="1.8796" rot="R90"/>
<pad name="2" x="2.54" y="0" drill="1.016" diameter="1.8796" rot="R90"/>
<text x="-1.3462" y="1.8288" size="1.27" layer="25" ratio="10">&gt;NAME</text>
<text x="-1.27" y="-3.175" size="1.27" layer="27">&gt;VALUE</text>
<rectangle x1="2.286" y1="-0.254" x2="2.794" y2="0.254" layer="51"/>
<rectangle x1="-0.254" y1="-0.254" x2="0.254" y2="0.254" layer="51"/>
</package>
<package name="MOLEX-1X2">
<wire x1="-1.27" y1="3.048" x2="-1.27" y2="-2.54" width="0.127" layer="21"/>
<wire x1="3.81" y1="3.048" x2="3.81" y2="-2.54" width="0.127" layer="21"/>
<wire x1="3.81" y1="3.048" x2="-1.27" y2="3.048" width="0.127" layer="21"/>
<wire x1="3.81" y1="-2.54" x2="2.54" y2="-2.54" width="0.127" layer="21"/>
<wire x1="2.54" y1="-2.54" x2="0" y2="-2.54" width="0.127" layer="21"/>
<wire x1="0" y1="-2.54" x2="-1.27" y2="-2.54" width="0.127" layer="21"/>
<wire x1="0" y1="-2.54" x2="0" y2="-1.27" width="0.127" layer="21"/>
<wire x1="0" y1="-1.27" x2="2.54" y2="-1.27" width="0.127" layer="21"/>
<wire x1="2.54" y1="-1.27" x2="2.54" y2="-2.54" width="0.127" layer="21"/>
<pad name="1" x="0" y="0" drill="1.016" diameter="1.8796" shape="square"/>
<pad name="2" x="2.54" y="0" drill="1.016" diameter="1.8796"/>
</package>
<package name="SCREWTERMINAL-3.5MM-2">
<circle x="2" y="3" radius="0.2828" width="0.127" layer="51"/>
<wire x1="-1.75" y1="3.4" x2="5.25" y2="3.4" width="0.2032" layer="21"/>
<wire x1="5.25" y1="3.4" x2="5.25" y2="-2.8" width="0.2032" layer="21"/>
<wire x1="5.25" y1="-2.8" x2="5.25" y2="-3.6" width="0.2032" layer="21"/>
<wire x1="5.25" y1="-3.6" x2="-1.75" y2="-3.6" width="0.2032" layer="21"/>
<wire x1="-1.75" y1="-3.6" x2="-1.75" y2="-2.8" width="0.2032" layer="21"/>
<wire x1="-1.75" y1="-2.8" x2="-1.75" y2="3.4" width="0.2032" layer="21"/>
<wire x1="5.25" y1="-2.8" x2="-1.75" y2="-2.8" width="0.2032" layer="21"/>
<wire x1="-1.75" y1="-1.35" x2="-2.25" y2="-1.35" width="0.2032" layer="51"/>
<wire x1="-2.25" y1="-1.35" x2="-2.25" y2="-2.35" width="0.2032" layer="51"/>
<wire x1="-2.25" y1="-2.35" x2="-1.75" y2="-2.35" width="0.2032" layer="51"/>
<wire x1="5.25" y1="3.15" x2="5.75" y2="3.15" width="0.2032" layer="51"/>
<wire x1="5.75" y1="3.15" x2="5.75" y2="2.15" width="0.2032" layer="51"/>
<wire x1="5.75" y1="2.15" x2="5.25" y2="2.15" width="0.2032" layer="51"/>
<pad name="1" x="0" y="0" drill="1.2" diameter="2.032" shape="square"/>
<pad name="2" x="3.5" y="0" drill="1.2" diameter="2.032"/>
<text x="-1.27" y="2.54" size="0.4064" layer="25">&gt;NAME</text>
<text x="-1.27" y="1.27" size="0.4064" layer="27">&gt;VALUE</text>
</package>
<package name="JST-2-SMD">
<description>2mm SMD side-entry connector. tDocu layer indicates the actual physical plastic housing. +/- indicate SparkFun standard batteries and wiring.</description>
<wire x1="-4" y1="-1" x2="-4" y2="-4.5" width="0.2032" layer="21"/>
<wire x1="-4" y1="-4.5" x2="-3.2" y2="-4.5" width="0.2032" layer="21"/>
<wire x1="-3.2" y1="-4.5" x2="-3.2" y2="-2" width="0.2032" layer="21"/>
<wire x1="-3.2" y1="-2" x2="-2" y2="-2" width="0.2032" layer="21"/>
<wire x1="2" y1="-2" x2="3.2" y2="-2" width="0.2032" layer="21"/>
<wire x1="3.2" y1="-2" x2="3.2" y2="-4.5" width="0.2032" layer="21"/>
<wire x1="3.2" y1="-4.5" x2="4" y2="-4.5" width="0.2032" layer="21"/>
<wire x1="4" y1="-4.5" x2="4" y2="-1" width="0.2032" layer="21"/>
<wire x1="2" y1="3" x2="-2" y2="3" width="0.2032" layer="21"/>
<smd name="1" x="-1" y="-3.7" dx="1" dy="4.6" layer="1"/>
<smd name="2" x="1" y="-3.7" dx="1" dy="4.6" layer="1"/>
<smd name="NC1" x="-3.4" y="1.5" dx="3.4" dy="1.6" layer="1" rot="R90"/>
<smd name="NC2" x="3.4" y="1.5" dx="3.4" dy="1.6" layer="1" rot="R90"/>
<text x="-1.27" y="1.27" size="0.4064" layer="25">&gt;Name</text>
<text x="-1.27" y="0" size="0.4064" layer="27">&gt;Value</text>
</package>
<package name="1X02_BIG">
<wire x1="-1.27" y1="1.27" x2="-1.27" y2="-1.27" width="0.127" layer="21"/>
<wire x1="-1.27" y1="-1.27" x2="5.08" y2="-1.27" width="0.127" layer="21"/>
<wire x1="5.08" y1="-1.27" x2="5.08" y2="1.27" width="0.127" layer="21"/>
<wire x1="5.08" y1="1.27" x2="-1.27" y2="1.27" width="0.127" layer="21"/>
<pad name="P$1" x="0" y="0" drill="1.0668"/>
<pad name="P$2" x="3.81" y="0" drill="1.0668"/>
</package>
<package name="JST-2-SMD-VERT">
<wire x1="-4.1" y1="2.97" x2="4.2" y2="2.97" width="0.2032" layer="51"/>
<wire x1="4.2" y1="2.97" x2="4.2" y2="-2.13" width="0.2032" layer="51"/>
<wire x1="4.2" y1="-2.13" x2="-4.1" y2="-2.13" width="0.2032" layer="51"/>
<wire x1="-4.1" y1="-2.13" x2="-4.1" y2="2.97" width="0.2032" layer="51"/>
<wire x1="-4.1" y1="3" x2="4.2" y2="3" width="0.2032" layer="21"/>
<wire x1="4.2" y1="3" x2="4.2" y2="2.3" width="0.2032" layer="21"/>
<wire x1="-4.1" y1="3" x2="-4.1" y2="2.3" width="0.2032" layer="21"/>
<wire x1="2" y1="-2.1" x2="4.2" y2="-2.1" width="0.2032" layer="21"/>
<wire x1="4.2" y1="-2.1" x2="4.2" y2="-1.7" width="0.2032" layer="21"/>
<wire x1="-2" y1="-2.1" x2="-4.1" y2="-2.1" width="0.2032" layer="21"/>
<wire x1="-4.1" y1="-2.1" x2="-4.1" y2="-1.8" width="0.2032" layer="21"/>
<smd name="P$1" x="-3.4" y="0.27" dx="3" dy="1.6" layer="1" rot="R90"/>
<smd name="P$2" x="3.4" y="0.27" dx="3" dy="1.6" layer="1" rot="R90"/>
<smd name="VCC" x="-1" y="-2" dx="1" dy="5.5" layer="1"/>
<smd name="GND" x="1" y="-2" dx="1" dy="5.5" layer="1"/>
<text x="2.54" y="-5.08" size="1.27" layer="25">&gt;Name</text>
<text x="2.24" y="3.48" size="1.27" layer="27">&gt;Value</text>
</package>
<package name="R_SW_TH">
<wire x1="-1.651" y1="19.2532" x2="-1.651" y2="-1.3716" width="0.2032" layer="21"/>
<wire x1="-1.651" y1="-1.3716" x2="-1.651" y2="-2.2352" width="0.2032" layer="21"/>
<wire x1="-1.651" y1="19.2532" x2="13.589" y2="19.2532" width="0.2032" layer="21"/>
<wire x1="13.589" y1="19.2532" x2="13.589" y2="-2.2352" width="0.2032" layer="21"/>
<wire x1="13.589" y1="-2.2352" x2="-1.651" y2="-2.2352" width="0.2032" layer="21"/>
<pad name="P$1" x="0" y="0" drill="1.6002"/>
<pad name="P$2" x="0" y="16.9926" drill="1.6002"/>
<pad name="P$3" x="12.0904" y="15.494" drill="1.6002"/>
<pad name="P$4" x="12.0904" y="8.4582" drill="1.6002"/>
</package>
<package name="SCREWTERMINAL-5MM-2">
<wire x1="-3.1" y1="4.2" x2="8.1" y2="4.2" width="0.2032" layer="21"/>
<wire x1="8.1" y1="4.2" x2="8.1" y2="-2.3" width="0.2032" layer="21"/>
<wire x1="8.1" y1="-2.3" x2="8.1" y2="-3.3" width="0.2032" layer="21"/>
<wire x1="8.1" y1="-3.3" x2="-3.1" y2="-3.3" width="0.2032" layer="21"/>
<wire x1="-3.1" y1="-3.3" x2="-3.1" y2="-2.3" width="0.2032" layer="21"/>
<wire x1="-3.1" y1="-2.3" x2="-3.1" y2="4.2" width="0.2032" layer="21"/>
<wire x1="8.1" y1="-2.3" x2="-3.1" y2="-2.3" width="0.2032" layer="21"/>
<wire x1="-3.1" y1="-1.35" x2="-3.7" y2="-1.35" width="0.2032" layer="51"/>
<wire x1="-3.7" y1="-1.35" x2="-3.7" y2="-2.35" width="0.2032" layer="51"/>
<wire x1="-3.7" y1="-2.35" x2="-3.1" y2="-2.35" width="0.2032" layer="51"/>
<wire x1="8.1" y1="4" x2="8.7" y2="4" width="0.2032" layer="51"/>
<wire x1="8.7" y1="4" x2="8.7" y2="3" width="0.2032" layer="51"/>
<wire x1="8.7" y1="3" x2="8.1" y2="3" width="0.2032" layer="51"/>
<circle x="2.5" y="3.7" radius="0.2828" width="0.127" layer="51"/>
<pad name="1" x="0" y="0" drill="1.3" diameter="2.032" shape="square"/>
<pad name="2" x="5" y="0" drill="1.3" diameter="2.032"/>
<text x="-1.27" y="2.54" size="0.4064" layer="25">&gt;NAME</text>
<text x="-1.27" y="1.27" size="0.4064" layer="27">&gt;VALUE</text>
</package>
<package name="1X02_LOCK">
<wire x1="-0.635" y1="1.27" x2="0.635" y2="1.27" width="0.2032" layer="21"/>
<wire x1="0.635" y1="1.27" x2="1.27" y2="0.635" width="0.2032" layer="21"/>
<wire x1="1.27" y1="-0.635" x2="0.635" y2="-1.27" width="0.2032" layer="21"/>
<wire x1="1.27" y1="0.635" x2="1.905" y2="1.27" width="0.2032" layer="21"/>
<wire x1="1.905" y1="1.27" x2="3.175" y2="1.27" width="0.2032" layer="21"/>
<wire x1="3.175" y1="1.27" x2="3.81" y2="0.635" width="0.2032" layer="21"/>
<wire x1="3.81" y1="-0.635" x2="3.175" y2="-1.27" width="0.2032" layer="21"/>
<wire x1="3.175" y1="-1.27" x2="1.905" y2="-1.27" width="0.2032" layer="21"/>
<wire x1="1.905" y1="-1.27" x2="1.27" y2="-0.635" width="0.2032" layer="21"/>
<wire x1="-1.27" y1="0.635" x2="-1.27" y2="-0.635" width="0.2032" layer="21"/>
<wire x1="-0.635" y1="1.27" x2="-1.27" y2="0.635" width="0.2032" layer="21"/>
<wire x1="-1.27" y1="-0.635" x2="-0.635" y2="-1.27" width="0.2032" layer="21"/>
<wire x1="0.635" y1="-1.27" x2="-0.635" y2="-1.27" width="0.2032" layer="21"/>
<wire x1="3.81" y1="0.635" x2="3.81" y2="-0.635" width="0.2032" layer="21"/>
<pad name="1" x="-0.1778" y="0" drill="1.016" diameter="1.8796" rot="R90"/>
<pad name="2" x="2.7178" y="0" drill="1.016" diameter="1.8796" rot="R90"/>
<text x="-1.3462" y="1.8288" size="1.27" layer="25" ratio="10">&gt;NAME</text>
<text x="-1.27" y="-3.175" size="1.27" layer="27">&gt;VALUE</text>
<rectangle x1="-0.2921" y1="-0.2921" x2="0.2921" y2="0.2921" layer="51"/>
<rectangle x1="2.2479" y1="-0.2921" x2="2.8321" y2="0.2921" layer="51"/>
</package>
<package name="MOLEX-1X2_LOCK">
<wire x1="-1.27" y1="3.048" x2="-1.27" y2="-2.54" width="0.127" layer="21"/>
<wire x1="3.81" y1="3.048" x2="3.81" y2="-2.54" width="0.127" layer="21"/>
<wire x1="3.81" y1="3.048" x2="-1.27" y2="3.048" width="0.127" layer="21"/>
<wire x1="3.81" y1="-2.54" x2="2.54" y2="-2.54" width="0.127" layer="21"/>
<wire x1="2.54" y1="-2.54" x2="0" y2="-2.54" width="0.127" layer="21"/>
<wire x1="0" y1="-2.54" x2="-1.27" y2="-2.54" width="0.127" layer="21"/>
<wire x1="0" y1="-2.54" x2="0" y2="-1.27" width="0.127" layer="21"/>
<wire x1="0" y1="-1.27" x2="2.54" y2="-1.27" width="0.127" layer="21"/>
<wire x1="2.54" y1="-1.27" x2="2.54" y2="-2.54" width="0.127" layer="21"/>
<pad name="1" x="-0.127" y="0" drill="1.016" diameter="1.8796" shape="square"/>
<pad name="2" x="2.667" y="0" drill="1.016" diameter="1.8796"/>
<rectangle x1="-0.2921" y1="-0.2921" x2="0.2921" y2="0.2921" layer="51"/>
<rectangle x1="2.2479" y1="-0.2921" x2="2.8321" y2="0.2921" layer="51"/>
</package>
<package name="1X02_LOCK_LONGPADS">
<description>This footprint was designed to help hold the alignment of a through-hole component (i.e.  6-pin header) while soldering it into place.  
You may notice that each hole has been shifted either up or down by 0.005 of an inch from it's more standard position (which is a perfectly straight line).  
This slight alteration caused the pins (the squares in the middle) to touch the edges of the holes.  Because they are alternating, it causes a "brace" 
to hold the component in place.  0.005 has proven to be the perfect amount of "off-center" position when using our standard breakaway headers.
Although looks a little odd when you look at the bare footprint, once you have a header in there, the alteration is very hard to notice.  Also,
if you push a header all the way into place, it is covered up entirely on the bottom side.  This idea of altering the position of holes to aid alignment 
will be further integrated into the Sparkfun Library for other footprints.  It can help hold any component with 3 or more connection pins.</description>
<wire x1="1.651" y1="0" x2="0.889" y2="0" width="0.2032" layer="21"/>
<wire x1="-1.27" y1="0" x2="-1.016" y2="0" width="0.2032" layer="21"/>
<wire x1="-1.27" y1="0" x2="-1.27" y2="0.9906" width="0.2032" layer="21"/>
<wire x1="-1.27" y1="0.9906" x2="-0.9906" y2="1.27" width="0.2032" layer="21"/>
<wire x1="-1.27" y1="0" x2="-1.27" y2="-0.9906" width="0.2032" layer="21"/>
<wire x1="-1.27" y1="-0.9906" x2="-0.9906" y2="-1.27" width="0.2032" layer="21"/>
<wire x1="3.81" y1="0" x2="3.556" y2="0" width="0.2032" layer="21"/>
<wire x1="3.81" y1="0" x2="3.81" y2="-0.9906" width="0.2032" layer="21"/>
<wire x1="3.81" y1="-0.9906" x2="3.5306" y2="-1.27" width="0.2032" layer="21"/>
<wire x1="3.81" y1="0" x2="3.81" y2="0.9906" width="0.2032" layer="21"/>
<wire x1="3.81" y1="0.9906" x2="3.5306" y2="1.27" width="0.2032" layer="21"/>
<pad name="1" x="-0.127" y="0" drill="1.016" shape="long" rot="R90"/>
<pad name="2" x="2.667" y="0" drill="1.016" shape="long" rot="R90"/>
<text x="-1.27" y="1.778" size="1.27" layer="25" font="vector">&gt;NAME</text>
<text x="-1.27" y="-3.302" size="1.27" layer="27" font="vector">&gt;VALUE</text>
<rectangle x1="-0.2921" y1="-0.2921" x2="0.2921" y2="0.2921" layer="51"/>
<rectangle x1="2.2479" y1="-0.2921" x2="2.8321" y2="0.2921" layer="51"/>
</package>
<package name="SCREWTERMINAL-3.5MM-2_LOCK">
<wire x1="-1.75" y1="3.4" x2="5.25" y2="3.4" width="0.2032" layer="21"/>
<wire x1="5.25" y1="3.4" x2="5.25" y2="-2.8" width="0.2032" layer="21"/>
<wire x1="5.25" y1="-2.8" x2="5.25" y2="-3.6" width="0.2032" layer="21"/>
<wire x1="5.25" y1="-3.6" x2="-1.75" y2="-3.6" width="0.2032" layer="21"/>
<wire x1="-1.75" y1="-3.6" x2="-1.75" y2="-2.8" width="0.2032" layer="21"/>
<wire x1="-1.75" y1="-2.8" x2="-1.75" y2="3.4" width="0.2032" layer="21"/>
<wire x1="5.25" y1="-2.8" x2="-1.75" y2="-2.8" width="0.2032" layer="21"/>
<wire x1="-1.75" y1="-1.35" x2="-2.15" y2="-1.35" width="0.2032" layer="51"/>
<wire x1="-2.15" y1="-1.35" x2="-2.15" y2="-2.35" width="0.2032" layer="51"/>
<wire x1="-2.15" y1="-2.35" x2="-1.75" y2="-2.35" width="0.2032" layer="51"/>
<wire x1="5.25" y1="3.15" x2="5.65" y2="3.15" width="0.2032" layer="51"/>
<wire x1="5.65" y1="3.15" x2="5.65" y2="2.15" width="0.2032" layer="51"/>
<wire x1="5.65" y1="2.15" x2="5.25" y2="2.15" width="0.2032" layer="51"/>
<circle x="2" y="3" radius="0.2828" width="0.127" layer="51"/>
<circle x="0" y="0" radius="0.4318" width="0.0254" layer="51"/>
<circle x="3.5" y="0" radius="0.4318" width="0.0254" layer="51"/>
<pad name="1" x="-0.1778" y="0" drill="1.2" diameter="2.032" shape="square"/>
<pad name="2" x="3.6778" y="0" drill="1.2" diameter="2.032"/>
<text x="-1.27" y="2.54" size="0.4064" layer="25">&gt;NAME</text>
<text x="-1.27" y="1.27" size="0.4064" layer="27">&gt;VALUE</text>
</package>
<package name="1X02_LONGPADS">
<pad name="1" x="0" y="0" drill="1.1176" diameter="1.8796" shape="long" rot="R90"/>
<pad name="2" x="2.54" y="0" drill="1.1176" diameter="1.8796" shape="long" rot="R90"/>
</package>
<package name="1X02_NO_SILK">
<pad name="1" x="0" y="0" drill="1.016" diameter="1.8796" rot="R90"/>
<pad name="2" x="2.54" y="0" drill="1.016" diameter="1.8796" rot="R90"/>
<text x="-1.3462" y="1.8288" size="1.27" layer="25" ratio="10">&gt;NAME</text>
<text x="-1.27" y="-3.175" size="1.27" layer="27">&gt;VALUE</text>
<rectangle x1="2.286" y1="-0.254" x2="2.794" y2="0.254" layer="51"/>
<rectangle x1="-0.254" y1="-0.254" x2="0.254" y2="0.254" layer="51"/>
</package>
<package name="JST-2-PTH">
<pad name="1" x="-1" y="0" drill="0.7" diameter="1.6"/>
<pad name="2" x="1" y="0" drill="0.7" diameter="1.6"/>
<text x="-1.27" y="5.27" size="0.4064" layer="25">&gt;Name</text>
<text x="-1.27" y="4" size="0.4064" layer="27">&gt;Value</text>
<text x="0.6" y="0.7" size="1.27" layer="51">+</text>
<text x="-1.4" y="0.7" size="1.27" layer="51">-</text>
<wire x1="-2.95" y1="-1.6" x2="-2.95" y2="6" width="0.2032" layer="21"/>
<wire x1="-2.95" y1="6" x2="2.95" y2="6" width="0.2032" layer="21"/>
<wire x1="2.95" y1="6" x2="2.95" y2="-1.6" width="0.2032" layer="21"/>
<wire x1="-2.95" y1="-1.6" x2="-2.3" y2="-1.6" width="0.2032" layer="21"/>
<wire x1="2.95" y1="-1.6" x2="2.3" y2="-1.6" width="0.2032" layer="21"/>
<wire x1="-2.3" y1="-1.6" x2="-2.3" y2="0" width="0.2032" layer="21"/>
<wire x1="2.3" y1="-1.6" x2="2.3" y2="0" width="0.2032" layer="21"/>
</package>
<package name="1X02_XTRA_BIG">
<wire x1="-5.08" y1="2.54" x2="-5.08" y2="-2.54" width="0.127" layer="21"/>
<wire x1="-5.08" y1="-2.54" x2="5.08" y2="-2.54" width="0.127" layer="21"/>
<wire x1="5.08" y1="-2.54" x2="5.08" y2="2.54" width="0.127" layer="21"/>
<wire x1="5.08" y1="2.54" x2="-5.08" y2="2.54" width="0.127" layer="21"/>
<pad name="1" x="-2.54" y="0" drill="2.0574" diameter="3.556"/>
<pad name="2" x="2.54" y="0" drill="2.0574" diameter="3.556"/>
</package>
<package name="1X02_PP_HOLES_ONLY">
<circle x="0" y="0" radius="0.635" width="0.127" layer="51"/>
<circle x="2.54" y="0" radius="0.635" width="0.127" layer="51"/>
<pad name="1" x="0" y="0" drill="0.889" diameter="0.8128" rot="R90"/>
<pad name="2" x="2.54" y="0" drill="0.889" diameter="0.8128" rot="R90"/>
<hole x="0" y="0" drill="1.4732"/>
<hole x="2.54" y="0" drill="1.4732"/>
</package>
<package name="SCREWTERMINAL-3.5MM-2-NS">
<wire x1="-1.75" y1="3.4" x2="5.25" y2="3.4" width="0.2032" layer="51"/>
<wire x1="5.25" y1="3.4" x2="5.25" y2="-2.8" width="0.2032" layer="51"/>
<wire x1="5.25" y1="-2.8" x2="5.25" y2="-3.6" width="0.2032" layer="51"/>
<wire x1="5.25" y1="-3.6" x2="-1.75" y2="-3.6" width="0.2032" layer="51"/>
<wire x1="-1.75" y1="-3.6" x2="-1.75" y2="-2.8" width="0.2032" layer="51"/>
<wire x1="-1.75" y1="-2.8" x2="-1.75" y2="3.4" width="0.2032" layer="51"/>
<wire x1="5.25" y1="-2.8" x2="-1.75" y2="-2.8" width="0.2032" layer="51"/>
<wire x1="-1.75" y1="-1.35" x2="-2.15" y2="-1.35" width="0.2032" layer="51"/>
<wire x1="-2.15" y1="-1.35" x2="-2.15" y2="-2.35" width="0.2032" layer="51"/>
<wire x1="-2.15" y1="-2.35" x2="-1.75" y2="-2.35" width="0.2032" layer="51"/>
<wire x1="5.25" y1="3.15" x2="5.65" y2="3.15" width="0.2032" layer="51"/>
<wire x1="5.65" y1="3.15" x2="5.65" y2="2.15" width="0.2032" layer="51"/>
<wire x1="5.65" y1="2.15" x2="5.25" y2="2.15" width="0.2032" layer="51"/>
<circle x="2" y="3" radius="0.2828" width="0.127" layer="51"/>
<pad name="1" x="0" y="0" drill="1.2" diameter="2.032" shape="square"/>
<pad name="2" x="3.5" y="0" drill="1.2" diameter="2.032"/>
<text x="-1.27" y="2.54" size="0.4064" layer="25">&gt;NAME</text>
<text x="-1.27" y="1.27" size="0.4064" layer="27">&gt;VALUE</text>
</package>
<package name="JST-2-PTH-NS">
<wire x1="-2" y1="0" x2="-2" y2="-1.8" width="0.2032" layer="51"/>
<wire x1="-2" y1="-1.8" x2="-3" y2="-1.8" width="0.2032" layer="51"/>
<wire x1="-3" y1="-1.8" x2="-3" y2="6" width="0.2032" layer="51"/>
<wire x1="-3" y1="6" x2="3" y2="6" width="0.2032" layer="51"/>
<wire x1="3" y1="6" x2="3" y2="-1.8" width="0.2032" layer="51"/>
<wire x1="3" y1="-1.8" x2="2" y2="-1.8" width="0.2032" layer="51"/>
<wire x1="2" y1="-1.8" x2="2" y2="0" width="0.2032" layer="51"/>
<pad name="1" x="-1" y="0" drill="0.7" diameter="1.6"/>
<pad name="2" x="1" y="0" drill="0.7" diameter="1.6"/>
<text x="-1.27" y="5.27" size="0.4064" layer="25">&gt;Name</text>
<text x="-1.27" y="4" size="0.4064" layer="27">&gt;Value</text>
<text x="0.6" y="0.7" size="1.27" layer="51">+</text>
<text x="-1.4" y="0.7" size="1.27" layer="51">-</text>
</package>
<package name="JST-2-PTH-KIT">
<description>&lt;H3&gt;JST-2-PTH-KIT&lt;/h3&gt;
2-Pin JST, through-hole connector&lt;br&gt;
&lt;br&gt;
&lt;b&gt;Warning:&lt;/b&gt; This is the KIT version of this package. This package has a smaller diameter top stop mask, which doesn't cover the diameter of the pad. This means only the bottom side of the pads' copper will be exposed. You'll only be able to solder to the bottom side.</description>
<wire x1="-2" y1="0" x2="-2" y2="-1.8" width="0.2032" layer="51"/>
<wire x1="-2" y1="-1.8" x2="-3" y2="-1.8" width="0.2032" layer="51"/>
<wire x1="-3" y1="-1.8" x2="-3" y2="6" width="0.2032" layer="51"/>
<wire x1="-3" y1="6" x2="3" y2="6" width="0.2032" layer="51"/>
<wire x1="3" y1="6" x2="3" y2="-1.8" width="0.2032" layer="51"/>
<wire x1="3" y1="-1.8" x2="2" y2="-1.8" width="0.2032" layer="51"/>
<wire x1="2" y1="-1.8" x2="2" y2="0" width="0.2032" layer="51"/>
<pad name="1" x="-1" y="0" drill="0.7" diameter="1.4478" stop="no"/>
<pad name="2" x="1" y="0" drill="0.7" diameter="1.4478" stop="no"/>
<text x="-1.27" y="5.27" size="0.4064" layer="25">&gt;Name</text>
<text x="-1.27" y="4" size="0.4064" layer="27">&gt;Value</text>
<text x="0.6" y="0.7" size="1.27" layer="51">+</text>
<text x="-1.4" y="0.7" size="1.27" layer="51">-</text>
<polygon width="0.127" layer="30">
<vertex x="-0.9975" y="-0.6604" curve="-90.025935"/>
<vertex x="-1.6604" y="0" curve="-90.017354"/>
<vertex x="-1" y="0.6604" curve="-90"/>
<vertex x="-0.3396" y="0" curve="-90.078137"/>
</polygon>
<polygon width="0.127" layer="29">
<vertex x="-1" y="-0.2865" curve="-90.08005"/>
<vertex x="-1.2865" y="0" curve="-90.040011"/>
<vertex x="-1" y="0.2865" curve="-90"/>
<vertex x="-0.7135" y="0" curve="-90"/>
</polygon>
<polygon width="0.127" layer="30">
<vertex x="1.0025" y="-0.6604" curve="-90.025935"/>
<vertex x="0.3396" y="0" curve="-90.017354"/>
<vertex x="1" y="0.6604" curve="-90"/>
<vertex x="1.6604" y="0" curve="-90.078137"/>
</polygon>
<polygon width="0.127" layer="29">
<vertex x="1" y="-0.2865" curve="-90.08005"/>
<vertex x="0.7135" y="0" curve="-90.040011"/>
<vertex x="1" y="0.2865" curve="-90"/>
<vertex x="1.2865" y="0" curve="-90"/>
</polygon>
</package>
<package name="SPRINGTERMINAL-2.54MM-2">
<wire x1="-4.2" y1="7.88" x2="-4.2" y2="-2.8" width="0.254" layer="21"/>
<wire x1="-4.2" y1="-2.8" x2="-4.2" y2="-4.72" width="0.254" layer="51"/>
<wire x1="-4.2" y1="-4.72" x2="3.44" y2="-4.72" width="0.254" layer="51"/>
<wire x1="3.44" y1="-4.72" x2="3.44" y2="-2.8" width="0.254" layer="51"/>
<wire x1="3.44" y1="7.88" x2="-4.2" y2="7.88" width="0.254" layer="21"/>
<wire x1="0" y1="0" x2="0" y2="5.08" width="0.254" layer="1"/>
<wire x1="0" y1="0" x2="0" y2="5.08" width="0.254" layer="16"/>
<wire x1="2.54" y1="0" x2="2.54" y2="5.08" width="0.254" layer="16"/>
<wire x1="2.54" y1="0" x2="2.54" y2="5.08" width="0.254" layer="1"/>
<wire x1="-4.2" y1="-2.8" x2="3.44" y2="-2.8" width="0.254" layer="21"/>
<wire x1="3.44" y1="4" x2="3.44" y2="1" width="0.254" layer="21"/>
<wire x1="3.44" y1="7.88" x2="3.44" y2="6" width="0.254" layer="21"/>
<wire x1="3.44" y1="-0.9" x2="3.44" y2="-2.8" width="0.254" layer="21"/>
<pad name="1" x="0" y="0" drill="1.1" diameter="1.9"/>
<pad name="P$2" x="0" y="5.08" drill="1.1" diameter="1.9"/>
<pad name="P$3" x="2.54" y="5.08" drill="1.1" diameter="1.9"/>
<pad name="2" x="2.54" y="0" drill="1.1" diameter="1.9"/>
</package>
<package name="1X02_2.54_SCREWTERM">
<pad name="P2" x="0" y="0" drill="1.016" shape="square"/>
<pad name="P1" x="2.54" y="0" drill="1.016" shape="square"/>
<wire x1="-1.5" y1="3.25" x2="4" y2="3.25" width="0.2032" layer="21"/>
<wire x1="4" y1="3.25" x2="4" y2="2.5" width="0.2032" layer="21"/>
<wire x1="4" y1="2.5" x2="4" y2="-3.25" width="0.2032" layer="21"/>
<wire x1="4" y1="-3.25" x2="-1.5" y2="-3.25" width="0.2032" layer="21"/>
<wire x1="-1.5" y1="-3.25" x2="-1.5" y2="2.5" width="0.2032" layer="21"/>
<wire x1="-1.5" y1="2.5" x2="-1.5" y2="3.25" width="0.2032" layer="21"/>
<wire x1="-1.5" y1="2.5" x2="4" y2="2.5" width="0.2032" layer="21"/>
</package>
<package name="JST-2-PTH-VERT">
<wire x1="-2.95" y1="-2.25" x2="-2.95" y2="2.25" width="0.2032" layer="21"/>
<wire x1="-2.95" y1="2.25" x2="2.95" y2="2.25" width="0.2032" layer="21"/>
<wire x1="2.95" y1="2.25" x2="2.95" y2="-2.25" width="0.2032" layer="21"/>
<wire x1="2.95" y1="-2.25" x2="1" y2="-2.25" width="0.2032" layer="21"/>
<wire x1="-1" y1="-2.25" x2="-2.95" y2="-2.25" width="0.2032" layer="21"/>
<wire x1="-1" y1="-1.75" x2="1" y2="-1.75" width="0.2032" layer="21"/>
<wire x1="1" y1="-1.75" x2="1" y2="-2.25" width="0.2032" layer="21"/>
<wire x1="-1" y1="-1.75" x2="-1" y2="-2.25" width="0.2032" layer="21"/>
<pad name="1" x="-1" y="-0.55" drill="0.7" diameter="1.6"/>
<pad name="2" x="1" y="-0.55" drill="0.7" diameter="1.6"/>
<text x="-1.984" y="3" size="0.4064" layer="25">&gt;Name</text>
<text x="2.016" y="3" size="0.4064" layer="27">&gt;Value</text>
<text x="0.616" y="0.75" size="1.27" layer="51">+</text>
<text x="-1.384" y="0.75" size="1.27" layer="51">-</text>
</package>
<package name="1X02_POKEHOME">
<description>2 pin poke-home connector

part number 2072-2P from STA</description>
<wire x1="-7.6" y1="-5.85" x2="-7.6" y2="5.85" width="0.2032" layer="21"/>
<wire x1="-7.6" y1="5.85" x2="7.6" y2="5.85" width="0.2032" layer="21"/>
<wire x1="7.6" y1="5.85" x2="7.6" y2="-5.85" width="0.2032" layer="21"/>
<wire x1="7.6" y1="-5.85" x2="-7.6" y2="-5.85" width="0.2032" layer="21"/>
<smd name="P2" x="7.2" y="-3" dx="2.6" dy="1.8" layer="1"/>
<smd name="P1" x="7.2" y="3" dx="2.6" dy="1.8" layer="1"/>
<smd name="P4" x="-4.5" y="-3" dx="7.4" dy="1.8" layer="1"/>
<smd name="P3" x="-4.5" y="3" dx="7.4" dy="1.8" layer="1"/>
</package>
</packages>
<symbols>
<symbol name="M02">
<wire x1="3.81" y1="-2.54" x2="-2.54" y2="-2.54" width="0.4064" layer="94"/>
<wire x1="1.27" y1="2.54" x2="2.54" y2="2.54" width="0.6096" layer="94"/>
<wire x1="1.27" y1="0" x2="2.54" y2="0" width="0.6096" layer="94"/>
<wire x1="-2.54" y1="5.08" x2="-2.54" y2="-2.54" width="0.4064" layer="94"/>
<wire x1="3.81" y1="-2.54" x2="3.81" y2="5.08" width="0.4064" layer="94"/>
<wire x1="-2.54" y1="5.08" x2="3.81" y2="5.08" width="0.4064" layer="94"/>
<text x="-2.54" y="-5.08" size="1.778" layer="96">&gt;VALUE</text>
<text x="-2.54" y="5.842" size="1.778" layer="95">&gt;NAME</text>
<pin name="1" x="7.62" y="0" visible="pad" length="middle" direction="pas" swaplevel="1" rot="R180"/>
<pin name="2" x="7.62" y="2.54" visible="pad" length="middle" direction="pas" swaplevel="1" rot="R180"/>
</symbol>
</symbols>
<devicesets>
<deviceset name="M02" prefix="J" uservalue="yes">
<description>Standard 2-pin 0.1" header. Use with &lt;br&gt;
- straight break away headers ( PRT-00116)&lt;br&gt;
- right angle break away headers (PRT-00553)&lt;br&gt;
- swiss pins (PRT-00743)&lt;br&gt;
- machine pins (PRT-00117)&lt;br&gt;
- female headers (PRT-00115)&lt;br&gt;&lt;br&gt;

 Molex polarized connector foot print use with: PRT-08233 with associated crimp pins and housings.&lt;br&gt;&lt;br&gt;

2.54_SCREWTERM for use with  PRT-10571.&lt;br&gt;&lt;br&gt;

3.5mm Screw Terminal footprints for  PRT-08084&lt;br&gt;&lt;br&gt;

5mm Screw Terminal footprints for use with PRT-08432</description>
<gates>
<gate name="G$1" symbol="M02" x="-2.54" y="0"/>
</gates>
<devices>
<device name="PTH" package="1X02">
<connects>
<connect gate="G$1" pin="1" pad="1"/>
<connect gate="G$1" pin="2" pad="2"/>
</connects>
<technologies>
<technology name=""/>
</technologies>
</device>
<device name="POLAR" package="MOLEX-1X2">
<connects>
<connect gate="G$1" pin="1" pad="1"/>
<connect gate="G$1" pin="2" pad="2"/>
</connects>
<technologies>
<technology name=""/>
</technologies>
</device>
<device name="3.5MM" package="SCREWTERMINAL-3.5MM-2">
<connects>
<connect gate="G$1" pin="1" pad="1"/>
<connect gate="G$1" pin="2" pad="2"/>
</connects>
<technologies>
<technology name="">
<attribute name="PROD_ID" value="CONN-08399" constant="no"/>
</technology>
</technologies>
</device>
<device name="-JST-2MM-SMT" package="JST-2-SMD">
<connects>
<connect gate="G$1" pin="1" pad="2"/>
<connect gate="G$1" pin="2" pad="1"/>
</connects>
<technologies>
<technology name="">
<attribute name="PROD_ID" value="CONN-11443"/>
</technology>
</technologies>
</device>
<device name="PTH2" package="1X02_BIG">
<connects>
<connect gate="G$1" pin="1" pad="P$1"/>
<connect gate="G$1" pin="2" pad="P$2"/>
</connects>
<technologies>
<technology name=""/>
</technologies>
</device>
<device name="4UCON-15767" package="JST-2-SMD-VERT">
<connects>
<connect gate="G$1" pin="1" pad="GND"/>
<connect gate="G$1" pin="2" pad="VCC"/>
</connects>
<technologies>
<technology name=""/>
</technologies>
</device>
<device name="ROCKER" package="R_SW_TH">
<connects>
<connect gate="G$1" pin="1" pad="P$3"/>
<connect gate="G$1" pin="2" pad="P$4"/>
</connects>
<technologies>
<technology name=""/>
</technologies>
</device>
<device name="5MM" package="SCREWTERMINAL-5MM-2">
<connects>
<connect gate="G$1" pin="1" pad="1"/>
<connect gate="G$1" pin="2" pad="2"/>
</connects>
<technologies>
<technology name="">
<attribute name="STOREFRONT_ID" value="PRT-08432" constant="no"/>
</technology>
</technologies>
</device>
<device name="LOCK" package="1X02_LOCK">
<connects>
<connect gate="G$1" pin="1" pad="1"/>
<connect gate="G$1" pin="2" pad="2"/>
</connects>
<technologies>
<technology name=""/>
</technologies>
</device>
<device name="POLAR_LOCK" package="MOLEX-1X2_LOCK">
<connects>
<connect gate="G$1" pin="1" pad="1"/>
<connect gate="G$1" pin="2" pad="2"/>
</connects>
<technologies>
<technology name=""/>
</technologies>
</device>
<device name="LOCK_LONGPADS" package="1X02_LOCK_LONGPADS">
<connects>
<connect gate="G$1" pin="1" pad="1"/>
<connect gate="G$1" pin="2" pad="2"/>
</connects>
<technologies>
<technology name=""/>
</technologies>
</device>
<device name="3.5MM_LOCK" package="SCREWTERMINAL-3.5MM-2_LOCK">
<connects>
<connect gate="G$1" pin="1" pad="1"/>
<connect gate="G$1" pin="2" pad="2"/>
</connects>
<technologies>
<technology name="">
<attribute name="PROD_ID" value="CONN-08399" constant="no"/>
</technology>
</technologies>
</device>
<device name="PTH3" package="1X02_LONGPADS">
<connects>
<connect gate="G$1" pin="1" pad="1"/>
<connect gate="G$1" pin="2" pad="2"/>
</connects>
<technologies>
<technology name=""/>
</technologies>
</device>
<device name="1X02_NO_SILK" package="1X02_NO_SILK">
<connects>
<connect gate="G$1" pin="1" pad="1"/>
<connect gate="G$1" pin="2" pad="2"/>
</connects>
<technologies>
<technology name=""/>
</technologies>
</device>
<device name="JST-PTH-2" package="JST-2-PTH">
<connects>
<connect gate="G$1" pin="1" pad="1"/>
<connect gate="G$1" pin="2" pad="2"/>
</connects>
<technologies>
<technology name="">
<attribute name="PROD_ID" value="CONN-09863" constant="no"/>
<attribute name="SKU" value="PRT-09914" constant="no"/>
</technology>
</technologies>
</device>
<device name="PTH4" package="1X02_XTRA_BIG">
<connects>
<connect gate="G$1" pin="1" pad="1"/>
<connect gate="G$1" pin="2" pad="2"/>
</connects>
<technologies>
<technology name=""/>
</technologies>
</device>
<device name="POGO_PIN_HOLES_ONLY" package="1X02_PP_HOLES_ONLY">
<connects>
<connect gate="G$1" pin="1" pad="1"/>
<connect gate="G$1" pin="2" pad="2"/>
</connects>
<technologies>
<technology name=""/>
</technologies>
</device>
<device name="3.5MM-NO_SILK" package="SCREWTERMINAL-3.5MM-2-NS">
<connects>
<connect gate="G$1" pin="1" pad="1"/>
<connect gate="G$1" pin="2" pad="2"/>
</connects>
<technologies>
<technology name="">
<attribute name="PROD_ID" value="CONN-08399" constant="no"/>
</technology>
</technologies>
</device>
<device name="-JST-2-PTH-NO_SILK" package="JST-2-PTH-NS">
<connects>
<connect gate="G$1" pin="1" pad="1"/>
<connect gate="G$1" pin="2" pad="2"/>
</connects>
<technologies>
<technology name=""/>
</technologies>
</device>
<device name="JST-PTH-2-KIT" package="JST-2-PTH-KIT">
<connects>
<connect gate="G$1" pin="1" pad="1"/>
<connect gate="G$1" pin="2" pad="2"/>
</connects>
<technologies>
<technology name=""/>
</technologies>
</device>
<device name="SPRING-2.54-RA" package="SPRINGTERMINAL-2.54MM-2">
<connects>
<connect gate="G$1" pin="1" pad="1"/>
<connect gate="G$1" pin="2" pad="2"/>
</connects>
<technologies>
<technology name=""/>
</technologies>
</device>
<device name="2.54MM_SCREWTERM" package="1X02_2.54_SCREWTERM">
<connects>
<connect gate="G$1" pin="1" pad="P1"/>
<connect gate="G$1" pin="2" pad="P2"/>
</connects>
<technologies>
<technology name=""/>
</technologies>
</device>
<device name="JST-PTH-VERT" package="JST-2-PTH-VERT">
<connects>
<connect gate="G$1" pin="1" pad="1"/>
<connect gate="G$1" pin="2" pad="2"/>
</connects>
<technologies>
<technology name=""/>
</technologies>
</device>
<device name="POKEHOME" package="1X02_POKEHOME">
<connects>
<connect gate="G$1" pin="1" pad="P1 P3"/>
<connect gate="G$1" pin="2" pad="P2 P4"/>
</connects>
<technologies>
<technology name="">
<attribute name="PROD_ID" value="CONN-?????"/>
</technology>
</technologies>
</device>
</devices>
</deviceset>
</devicesets>
</library>
<library name="SparkFun-Aesthetics">
<description>&lt;h3&gt;SparkFun Electronics' preferred foot prints&lt;/h3&gt;
In this library you'll find non-functional items- supply symbols, logos, notations, frame blocks, etc.&lt;br&gt;&lt;br&gt;
We've spent an enormous amount of time creating and checking these footprints and parts, but it is the end user's responsibility to ensure correctness and suitablity for a given componet or application. If you enjoy using this library, please buy one of our products at www.sparkfun.com.
&lt;br&gt;&lt;br&gt;
&lt;b&gt;Licensing:&lt;/b&gt; Creative Commons ShareAlike 4.0 International - https://creativecommons.org/licenses/by-sa/4.0/ 
&lt;br&gt;&lt;br&gt;
You are welcome to use this library for commercial purposes. For attribution, we ask that when you begin to sell your device using our footprint, you email us with a link to the product being sold. We want bragging rights that we helped (in a very small part) to create your 8th world wonder. We would like the opportunity to feature your device on our homepage.</description>
<packages>
</packages>
<symbols>
<symbol name="DGND">
<wire x1="-1.905" y1="0" x2="1.905" y2="0" width="0.254" layer="94"/>
<text x="-2.54" y="-2.54" size="1.778" layer="96">&gt;VALUE</text>
<pin name="GND" x="0" y="2.54" visible="off" length="short" direction="sup" rot="R270"/>
</symbol>
<symbol name="VCC">
<wire x1="0.762" y1="1.27" x2="0" y2="2.54" width="0.254" layer="94"/>
<wire x1="0" y1="2.54" x2="-0.762" y2="1.27" width="0.254" layer="94"/>
<text x="-1.016" y="3.556" size="1.778" layer="96">&gt;VALUE</text>
<pin name="VCC" x="0" y="0" visible="off" length="short" direction="sup" rot="R90"/>
</symbol>
</symbols>
<devicesets>
<deviceset name="GND" prefix="GND">
<description>&lt;b&gt;SUPPLY SYMBOL&lt;/b&gt;</description>
<gates>
<gate name="1" symbol="DGND" x="0" y="0"/>
</gates>
<devices>
<device name="">
<technologies>
<technology name=""/>
</technologies>
</device>
</devices>
</deviceset>
<deviceset name="VCC" prefix="SUPPLY">
<description>&lt;b&gt;SUPPLY SYMBOL&lt;/b&gt;</description>
<gates>
<gate name="G$1" symbol="VCC" x="0" y="0"/>
</gates>
<devices>
<device name="">
<technologies>
<technology name=""/>
</technologies>
</device>
</devices>
</deviceset>
</devicesets>
</library>
<library name="frames">
<description>&lt;b&gt;Frames for Sheet and Layout&lt;/b&gt;</description>
<packages>
</packages>
<symbols>
<symbol name="A3L-LOC">
<wire x1="288.29" y1="3.81" x2="342.265" y2="3.81" width="0.1016" layer="94"/>
<wire x1="342.265" y1="3.81" x2="373.38" y2="3.81" width="0.1016" layer="94"/>
<wire x1="373.38" y1="3.81" x2="383.54" y2="3.81" width="0.1016" layer="94"/>
<wire x1="383.54" y1="3.81" x2="383.54" y2="8.89" width="0.1016" layer="94"/>
<wire x1="383.54" y1="8.89" x2="383.54" y2="13.97" width="0.1016" layer="94"/>
<wire x1="383.54" y1="13.97" x2="383.54" y2="19.05" width="0.1016" layer="94"/>
<wire x1="383.54" y1="19.05" x2="383.54" y2="24.13" width="0.1016" layer="94"/>
<wire x1="288.29" y1="3.81" x2="288.29" y2="24.13" width="0.1016" layer="94"/>
<wire x1="288.29" y1="24.13" x2="342.265" y2="24.13" width="0.1016" layer="94"/>
<wire x1="342.265" y1="24.13" x2="383.54" y2="24.13" width="0.1016" layer="94"/>
<wire x1="373.38" y1="3.81" x2="373.38" y2="8.89" width="0.1016" layer="94"/>
<wire x1="373.38" y1="8.89" x2="383.54" y2="8.89" width="0.1016" layer="94"/>
<wire x1="373.38" y1="8.89" x2="342.265" y2="8.89" width="0.1016" layer="94"/>
<wire x1="342.265" y1="8.89" x2="342.265" y2="3.81" width="0.1016" layer="94"/>
<wire x1="342.265" y1="8.89" x2="342.265" y2="13.97" width="0.1016" layer="94"/>
<wire x1="342.265" y1="13.97" x2="383.54" y2="13.97" width="0.1016" layer="94"/>
<wire x1="342.265" y1="13.97" x2="342.265" y2="19.05" width="0.1016" layer="94"/>
<wire x1="342.265" y1="19.05" x2="383.54" y2="19.05" width="0.1016" layer="94"/>
<wire x1="342.265" y1="19.05" x2="342.265" y2="24.13" width="0.1016" layer="94"/>
<text x="344.17" y="15.24" size="2.54" layer="94">&gt;DRAWING_NAME</text>
<text x="344.17" y="10.16" size="2.286" layer="94">&gt;LAST_DATE_TIME</text>
<text x="357.505" y="5.08" size="2.54" layer="94">&gt;SHEET</text>
<text x="343.916" y="4.953" size="2.54" layer="94">Sheet:</text>
<frame x1="0" y1="0" x2="387.35" y2="260.35" columns="8" rows="5" layer="94"/>
</symbol>
</symbols>
<devicesets>
<deviceset name="A3L-LOC" prefix="FRAME" uservalue="yes">
<description>&lt;b&gt;FRAME&lt;/b&gt;&lt;p&gt;
DIN A3, landscape with location and doc. field</description>
<gates>
<gate name="G$1" symbol="A3L-LOC" x="0" y="0"/>
</gates>
<devices>
<device name="">
<technologies>
<technology name=""/>
</technologies>
</device>
</devices>
</deviceset>
</devicesets>
</library>
<library name="pinhead">
<description>&lt;b&gt;Pin Header Connectors&lt;/b&gt;&lt;p&gt;
&lt;author&gt;Created by librarian@cadsoft.de&lt;/author&gt;</description>
<packages>
<package name="1X03">
<description>&lt;b&gt;PIN HEADER&lt;/b&gt;</description>
<wire x1="-3.175" y1="1.27" x2="-1.905" y2="1.27" width="0.1524" layer="21"/>
<wire x1="-1.905" y1="1.27" x2="-1.27" y2="0.635" width="0.1524" layer="21"/>
<wire x1="-1.27" y1="0.635" x2="-1.27" y2="-0.635" width="0.1524" layer="21"/>
<wire x1="-1.27" y1="-0.635" x2="-1.905" y2="-1.27" width="0.1524" layer="21"/>
<wire x1="-1.27" y1="0.635" x2="-0.635" y2="1.27" width="0.1524" layer="21"/>
<wire x1="-0.635" y1="1.27" x2="0.635" y2="1.27" width="0.1524" layer="21"/>
<wire x1="0.635" y1="1.27" x2="1.27" y2="0.635" width="0.1524" layer="21"/>
<wire x1="1.27" y1="0.635" x2="1.27" y2="-0.635" width="0.1524" layer="21"/>
<wire x1="1.27" y1="-0.635" x2="0.635" y2="-1.27" width="0.1524" layer="21"/>
<wire x1="0.635" y1="-1.27" x2="-0.635" y2="-1.27" width="0.1524" layer="21"/>
<wire x1="-0.635" y1="-1.27" x2="-1.27" y2="-0.635" width="0.1524" layer="21"/>
<wire x1="-3.81" y1="0.635" x2="-3.81" y2="-0.635" width="0.1524" layer="21"/>
<wire x1="-3.175" y1="1.27" x2="-3.81" y2="0.635" width="0.1524" layer="21"/>
<wire x1="-3.81" y1="-0.635" x2="-3.175" y2="-1.27" width="0.1524" layer="21"/>
<wire x1="-1.905" y1="-1.27" x2="-3.175" y2="-1.27" width="0.1524" layer="21"/>
<wire x1="1.27" y1="0.635" x2="1.905" y2="1.27" width="0.1524" layer="21"/>
<wire x1="1.905" y1="1.27" x2="3.175" y2="1.27" width="0.1524" layer="21"/>
<wire x1="3.175" y1="1.27" x2="3.81" y2="0.635" width="0.1524" layer="21"/>
<wire x1="3.81" y1="0.635" x2="3.81" y2="-0.635" width="0.1524" layer="21"/>
<wire x1="3.81" y1="-0.635" x2="3.175" y2="-1.27" width="0.1524" layer="21"/>
<wire x1="3.175" y1="-1.27" x2="1.905" y2="-1.27" width="0.1524" layer="21"/>
<wire x1="1.905" y1="-1.27" x2="1.27" y2="-0.635" width="0.1524" layer="21"/>
<pad name="1" x="-2.54" y="0" drill="1.016" shape="long" rot="R90"/>
<pad name="2" x="0" y="0" drill="1.016" shape="long" rot="R90"/>
<pad name="3" x="2.54" y="0" drill="1.016" shape="long" rot="R90"/>
<text x="-3.8862" y="1.8288" size="1.27" layer="25" ratio="10">&gt;NAME</text>
<text x="-3.81" y="-3.175" size="1.27" layer="27">&gt;VALUE</text>
<rectangle x1="-0.254" y1="-0.254" x2="0.254" y2="0.254" layer="51"/>
<rectangle x1="-2.794" y1="-0.254" x2="-2.286" y2="0.254" layer="51"/>
<rectangle x1="2.286" y1="-0.254" x2="2.794" y2="0.254" layer="51"/>
</package>
<package name="1X03/90">
<description>&lt;b&gt;PIN HEADER&lt;/b&gt;</description>
<wire x1="-3.81" y1="-1.905" x2="-1.27" y2="-1.905" width="0.1524" layer="21"/>
<wire x1="-1.27" y1="-1.905" x2="-1.27" y2="0.635" width="0.1524" layer="21"/>
<wire x1="-1.27" y1="0.635" x2="-3.81" y2="0.635" width="0.1524" layer="21"/>
<wire x1="-3.81" y1="0.635" x2="-3.81" y2="-1.905" width="0.1524" layer="21"/>
<wire x1="-2.54" y1="6.985" x2="-2.54" y2="1.27" width="0.762" layer="21"/>
<wire x1="-1.27" y1="-1.905" x2="1.27" y2="-1.905" width="0.1524" layer="21"/>
<wire x1="1.27" y1="-1.905" x2="1.27" y2="0.635" width="0.1524" layer="21"/>
<wire x1="1.27" y1="0.635" x2="-1.27" y2="0.635" width="0.1524" layer="21"/>
<wire x1="0" y1="6.985" x2="0" y2="1.27" width="0.762" layer="21"/>
<wire x1="1.27" y1="-1.905" x2="3.81" y2="-1.905" width="0.1524" layer="21"/>
<wire x1="3.81" y1="-1.905" x2="3.81" y2="0.635" width="0.1524" layer="21"/>
<wire x1="3.81" y1="0.635" x2="1.27" y2="0.635" width="0.1524" layer="21"/>
<wire x1="2.54" y1="6.985" x2="2.54" y2="1.27" width="0.762" layer="21"/>
<pad name="1" x="-2.54" y="-3.81" drill="1.016" shape="long" rot="R90"/>
<pad name="2" x="0" y="-3.81" drill="1.016" shape="long" rot="R90"/>
<pad name="3" x="2.54" y="-3.81" drill="1.016" shape="long" rot="R90"/>
<text x="-4.445" y="-3.81" size="1.27" layer="25" ratio="10" rot="R90">&gt;NAME</text>
<text x="5.715" y="-3.81" size="1.27" layer="27" rot="R90">&gt;VALUE</text>
<rectangle x1="-2.921" y1="0.635" x2="-2.159" y2="1.143" layer="21"/>
<rectangle x1="-0.381" y1="0.635" x2="0.381" y2="1.143" layer="21"/>
<rectangle x1="2.159" y1="0.635" x2="2.921" y2="1.143" layer="21"/>
<rectangle x1="-2.921" y1="-2.921" x2="-2.159" y2="-1.905" layer="21"/>
<rectangle x1="-0.381" y1="-2.921" x2="0.381" y2="-1.905" layer="21"/>
<rectangle x1="2.159" y1="-2.921" x2="2.921" y2="-1.905" layer="21"/>
</package>
</packages>
<symbols>
<symbol name="PINHD3">
<wire x1="-6.35" y1="-5.08" x2="1.27" y2="-5.08" width="0.4064" layer="94"/>
<wire x1="1.27" y1="-5.08" x2="1.27" y2="5.08" width="0.4064" layer="94"/>
<wire x1="1.27" y1="5.08" x2="-6.35" y2="5.08" width="0.4064" layer="94"/>
<wire x1="-6.35" y1="5.08" x2="-6.35" y2="-5.08" width="0.4064" layer="94"/>
<text x="-6.35" y="5.715" size="1.778" layer="95">&gt;NAME</text>
<text x="-6.35" y="-7.62" size="1.778" layer="96">&gt;VALUE</text>
<pin name="1" x="-2.54" y="2.54" visible="pad" length="short" direction="pas" function="dot"/>
<pin name="2" x="-2.54" y="0" visible="pad" length="short" direction="pas" function="dot"/>
<pin name="3" x="-2.54" y="-2.54" visible="pad" length="short" direction="pas" function="dot"/>
</symbol>
</symbols>
<devicesets>
<deviceset name="PINHD-1X3" prefix="JP" uservalue="yes">
<description>&lt;b&gt;PIN HEADER&lt;/b&gt;</description>
<gates>
<gate name="A" symbol="PINHD3" x="0" y="0"/>
</gates>
<devices>
<device name="" package="1X03">
<connects>
<connect gate="A" pin="1" pad="1"/>
<connect gate="A" pin="2" pad="2"/>
<connect gate="A" pin="3" pad="3"/>
</connects>
<technologies>
<technology name=""/>
</technologies>
</device>
<device name="/90" package="1X03/90">
<connects>
<connect gate="A" pin="1" pad="1"/>
<connect gate="A" pin="2" pad="2"/>
<connect gate="A" pin="3" pad="3"/>
</connects>
<technologies>
<technology name=""/>
</technologies>
</device>
</devices>
</deviceset>
</devicesets>
</library>
<library name="SparkFun-Passives">
<description>&lt;h3&gt;SparkFun Electronics' preferred foot prints&lt;/h3&gt;
In this library you'll find resistors, capacitors, inductors, test points, jumper pads, etc.&lt;br&gt;&lt;br&gt;
We've spent an enormous amount of time creating and checking these footprints and parts, but it is the end user's responsibility to ensure correctness and suitablity for a given componet or application. If you enjoy using this library, please buy one of our products at www.sparkfun.com.
&lt;br&gt;&lt;br&gt;
&lt;b&gt;Licensing:&lt;/b&gt; Creative Commons ShareAlike 4.0 International - https://creativecommons.org/licenses/by-sa/4.0/ 
&lt;br&gt;&lt;br&gt;
You are welcome to use this library for commercial purposes. For attribution, we ask that when you begin to sell your device using our footprint, you email us with a link to the product being sold. We want bragging rights that we helped (in a very small part) to create your 8th world wonder. We would like the opportunity to feature your device on our homepage.</description>
<packages>
<package name="AXIAL-0.4">
<description>1/4W Resistor, 0.4" wide&lt;p&gt;

Yageo CFR series &lt;a href="http://www.yageo.com/pdf/yageo/Leaded-R_CFR_2008.pdf"&gt;http://www.yageo.com/pdf/yageo/Leaded-R_CFR_2008.pdf&lt;/a&gt;</description>
<wire x1="-3.15" y1="-1.2" x2="-3.15" y2="1.2" width="0.2032" layer="21"/>
<wire x1="-3.15" y1="1.2" x2="3.15" y2="1.2" width="0.2032" layer="21"/>
<wire x1="3.15" y1="1.2" x2="3.15" y2="-1.2" width="0.2032" layer="21"/>
<wire x1="3.15" y1="-1.2" x2="-3.15" y2="-1.2" width="0.2032" layer="21"/>
<pad name="P$1" x="-5.08" y="0" drill="0.9" diameter="1.8796"/>
<pad name="P$2" x="5.08" y="0" drill="0.9" diameter="1.8796"/>
<text x="-3.175" y="1.905" size="0.8128" layer="25" font="vector" ratio="15">&gt;Name</text>
<text x="-2.286" y="-0.381" size="0.8128" layer="21" font="vector" ratio="15">&gt;Value</text>
</package>
<package name="1206">
<wire x1="-2.473" y1="0.983" x2="2.473" y2="0.983" width="0.0508" layer="39"/>
<wire x1="2.473" y1="-0.983" x2="-2.473" y2="-0.983" width="0.0508" layer="39"/>
<wire x1="-2.473" y1="-0.983" x2="-2.473" y2="0.983" width="0.0508" layer="39"/>
<wire x1="2.473" y1="0.983" x2="2.473" y2="-0.983" width="0.0508" layer="39"/>
<wire x1="-0.965" y1="0.787" x2="0.965" y2="0.787" width="0.1016" layer="51"/>
<wire x1="-0.965" y1="-0.787" x2="0.965" y2="-0.787" width="0.1016" layer="51"/>
<smd name="1" x="-1.4" y="0" dx="1.6" dy="1.8" layer="1"/>
<smd name="2" x="1.4" y="0" dx="1.6" dy="1.8" layer="1"/>
<text x="-1.27" y="1.143" size="0.4064" layer="25">&gt;NAME</text>
<text x="-1.397" y="-1.524" size="0.4064" layer="27">&gt;VALUE</text>
<rectangle x1="-1.7018" y1="-0.8509" x2="-0.9517" y2="0.8491" layer="51"/>
<rectangle x1="0.9517" y1="-0.8491" x2="1.7018" y2="0.8509" layer="51"/>
<rectangle x1="-0.1999" y1="-0.4001" x2="0.1999" y2="0.4001" layer="35"/>
</package>
<package name="AXIAL-0.3">
<wire x1="-2.54" y1="0.762" x2="2.54" y2="0.762" width="0.2032" layer="21"/>
<wire x1="2.54" y1="0.762" x2="2.54" y2="0" width="0.2032" layer="21"/>
<wire x1="2.54" y1="0" x2="2.54" y2="-0.762" width="0.2032" layer="21"/>
<wire x1="2.54" y1="-0.762" x2="-2.54" y2="-0.762" width="0.2032" layer="21"/>
<wire x1="-2.54" y1="-0.762" x2="-2.54" y2="0" width="0.2032" layer="21"/>
<wire x1="-2.54" y1="0" x2="-2.54" y2="0.762" width="0.2032" layer="21"/>
<wire x1="2.54" y1="0" x2="2.794" y2="0" width="0.2032" layer="21"/>
<wire x1="-2.54" y1="0" x2="-2.794" y2="0" width="0.2032" layer="21"/>
<pad name="P$1" x="-3.81" y="0" drill="0.9" diameter="1.8796"/>
<pad name="P$2" x="3.81" y="0" drill="0.9" diameter="1.8796"/>
<text x="-2.54" y="1.27" size="0.4064" layer="25" font="vector">&gt;Name</text>
<text x="-2.032" y="-0.381" size="1.016" layer="21" font="vector" ratio="15">&gt;Value</text>
</package>
<package name="R2010">
<description>&lt;b&gt;RESISTOR&lt;/b&gt;&lt;p&gt;
chip</description>
<wire x1="-1.662" y1="1.245" x2="1.662" y2="1.245" width="0.1524" layer="51"/>
<wire x1="-1.637" y1="-1.245" x2="1.687" y2="-1.245" width="0.1524" layer="51"/>
<wire x1="-3.473" y1="1.483" x2="3.473" y2="1.483" width="0.0508" layer="39"/>
<wire x1="3.473" y1="1.483" x2="3.473" y2="-1.483" width="0.0508" layer="39"/>
<wire x1="3.473" y1="-1.483" x2="-3.473" y2="-1.483" width="0.0508" layer="39"/>
<wire x1="-3.473" y1="-1.483" x2="-3.473" y2="1.483" width="0.0508" layer="39"/>
<wire x1="-1.027" y1="1.245" x2="1.027" y2="1.245" width="0.1524" layer="21"/>
<wire x1="-1.002" y1="-1.245" x2="1.016" y2="-1.245" width="0.1524" layer="21"/>
<smd name="1" x="-2.2" y="0" dx="1.8" dy="2.7" layer="1"/>
<smd name="2" x="2.2" y="0" dx="1.8" dy="2.7" layer="1"/>
<text x="-2.54" y="1.5875" size="0.4064" layer="25">&gt;NAME</text>
<text x="-2.54" y="-2.032" size="0.4064" layer="27">&gt;VALUE</text>
<rectangle x1="-2.4892" y1="-1.3208" x2="-1.6393" y2="1.3292" layer="51"/>
<rectangle x1="1.651" y1="-1.3208" x2="2.5009" y2="1.3292" layer="51"/>
</package>
<package name="0805">
<wire x1="-0.3" y1="0.6" x2="0.3" y2="0.6" width="0.1524" layer="21"/>
<wire x1="-0.3" y1="-0.6" x2="0.3" y2="-0.6" width="0.1524" layer="21"/>
<smd name="1" x="-0.9" y="0" dx="0.8" dy="1.2" layer="1"/>
<smd name="2" x="0.9" y="0" dx="0.8" dy="1.2" layer="1"/>
<text x="-0.762" y="0.8255" size="0.4064" layer="25">&gt;NAME</text>
<text x="-1.016" y="-1.397" size="0.4064" layer="27">&gt;VALUE</text>
</package>
<package name="0603-RES">
<wire x1="-1.473" y1="0.983" x2="1.473" y2="0.983" width="0.0508" layer="39"/>
<wire x1="1.473" y1="0.983" x2="1.473" y2="-0.983" width="0.0508" layer="39"/>
<wire x1="1.473" y1="-0.983" x2="-1.473" y2="-0.983" width="0.0508" layer="39"/>
<wire x1="-1.473" y1="-0.983" x2="-1.473" y2="0.983" width="0.0508" layer="39"/>
<wire x1="-0.356" y1="0.432" x2="0.356" y2="0.432" width="0.1016" layer="51"/>
<wire x1="-0.356" y1="-0.419" x2="0.356" y2="-0.419" width="0.1016" layer="51"/>
<smd name="1" x="-0.85" y="0" dx="1.1" dy="1" layer="1"/>
<smd name="2" x="0.85" y="0" dx="1.1" dy="1" layer="1"/>
<text x="-0.889" y="0.762" size="0.4064" layer="25" font="vector">&gt;NAME</text>
<text x="-1.016" y="-1.143" size="0.4064" layer="27" font="vector">&gt;VALUE</text>
<rectangle x1="-0.8382" y1="-0.4699" x2="-0.3381" y2="0.4801" layer="51"/>
<rectangle x1="0.3302" y1="-0.4699" x2="0.8303" y2="0.4801" layer="51"/>
<rectangle x1="-0.1999" y1="-0.3" x2="0.1999" y2="0.3" layer="35"/>
<rectangle x1="-0.2286" y1="-0.381" x2="0.2286" y2="0.381" layer="21"/>
</package>
<package name="0402-RES">
<description>&lt;b&gt;CAPACITOR&lt;/b&gt;&lt;p&gt;
chip</description>
<wire x1="-0.245" y1="0.224" x2="0.245" y2="0.224" width="0.1524" layer="51"/>
<wire x1="0.245" y1="-0.224" x2="-0.245" y2="-0.224" width="0.1524" layer="51"/>
<wire x1="-1.473" y1="0.483" x2="1.473" y2="0.483" width="0.0508" layer="39"/>
<wire x1="1.473" y1="0.483" x2="1.473" y2="-0.483" width="0.0508" layer="39"/>
<wire x1="1.473" y1="-0.483" x2="-1.473" y2="-0.483" width="0.0508" layer="39"/>
<wire x1="-1.473" y1="-0.483" x2="-1.473" y2="0.483" width="0.0508" layer="39"/>
<smd name="1" x="-0.65" y="0" dx="0.7" dy="0.9" layer="1"/>
<smd name="2" x="0.65" y="0" dx="0.7" dy="0.9" layer="1"/>
<text x="-0.889" y="0.6985" size="0.4064" layer="25">&gt;NAME</text>
<text x="-1.0795" y="-1.143" size="0.4064" layer="27">&gt;VALUE</text>
<rectangle x1="-0.554" y1="-0.3048" x2="-0.254" y2="0.2951" layer="51"/>
<rectangle x1="0.2588" y1="-0.3048" x2="0.5588" y2="0.2951" layer="51"/>
<rectangle x1="-0.1999" y1="-0.3" x2="0.1999" y2="0.3" layer="35"/>
<rectangle x1="-0.2032" y1="-0.3556" x2="0.2032" y2="0.3556" layer="21"/>
</package>
<package name="1/6W-RES">
<description>1/6W Thru-hole Resistor - *UNPROVEN*</description>
<wire x1="-1.55" y1="0.85" x2="-1.55" y2="-0.85" width="0.2032" layer="21"/>
<wire x1="-1.55" y1="-0.85" x2="1.55" y2="-0.85" width="0.2032" layer="21"/>
<wire x1="1.55" y1="-0.85" x2="1.55" y2="0.85" width="0.2032" layer="21"/>
<wire x1="1.55" y1="0.85" x2="-1.55" y2="0.85" width="0.2032" layer="21"/>
<pad name="1" x="-2.5" y="0" drill="0.762"/>
<pad name="2" x="2.5" y="0" drill="0.762"/>
<text x="-1.2662" y="0.9552" size="0.6096" layer="25">&gt;NAME</text>
<text x="-1.423" y="-0.4286" size="0.8128" layer="21" ratio="15">&gt;VALUE</text>
</package>
<package name="R2512">
<wire x1="-2.362" y1="1.473" x2="2.387" y2="1.473" width="0.1524" layer="51"/>
<wire x1="-2.362" y1="-1.473" x2="2.387" y2="-1.473" width="0.1524" layer="51"/>
<smd name="1" x="-2.8" y="0" dx="1.8" dy="3.2" layer="1"/>
<smd name="2" x="2.8" y="0" dx="1.8" dy="3.2" layer="1"/>
<text x="-2.54" y="1.905" size="1.27" layer="25">&gt;NAME</text>
<text x="-2.54" y="-3.175" size="1.27" layer="27">&gt;VALUE</text>
<rectangle x1="-3.2004" y1="-1.5494" x2="-2.3505" y2="1.5507" layer="51"/>
<rectangle x1="2.3622" y1="-1.5494" x2="3.2121" y2="1.5507" layer="51"/>
</package>
<package name="AXIAL-0.5">
<description>1/2W Resistor, 0.5" wide&lt;p&gt;

Yageo CFR series &lt;a href="http://www.yageo.com/pdf/yageo/Leaded-R_CFR_2008.pdf"&gt;http://www.yageo.com/pdf/yageo/Leaded-R_CFR_2008.pdf&lt;/a&gt;</description>
<wire x1="-4.5" y1="-1.65" x2="-4.5" y2="1.65" width="0.2032" layer="21"/>
<wire x1="-4.5" y1="1.65" x2="4.5" y2="1.65" width="0.2032" layer="21"/>
<wire x1="4.5" y1="1.65" x2="4.5" y2="-1.65" width="0.2032" layer="21"/>
<wire x1="4.5" y1="-1.65" x2="-4.5" y2="-1.65" width="0.2032" layer="21"/>
<pad name="P$1" x="-6.35" y="0" drill="0.9" diameter="1.8796"/>
<pad name="P$2" x="6.35" y="0" drill="0.9" diameter="1.8796"/>
<text x="-4.445" y="2.54" size="0.8128" layer="25" font="vector" ratio="15">&gt;Name</text>
<text x="-3.429" y="-0.381" size="0.8128" layer="21" font="vector" ratio="15">&gt;Value</text>
</package>
<package name="AXIAL-0.6">
<description>1W Resistor, 0.6" wide&lt;p&gt;

Yageo CFR series &lt;a href="http://www.yageo.com/pdf/yageo/Leaded-R_CFR_2008.pdf"&gt;http://www.yageo.com/pdf/yageo/Leaded-R_CFR_2008.pdf&lt;/a&gt;</description>
<wire x1="-5.75" y1="-2.25" x2="-5.75" y2="2.25" width="0.2032" layer="21"/>
<wire x1="-5.75" y1="2.25" x2="5.75" y2="2.25" width="0.2032" layer="21"/>
<wire x1="5.75" y1="2.25" x2="5.75" y2="-2.25" width="0.2032" layer="21"/>
<wire x1="5.75" y1="-2.25" x2="-5.75" y2="-2.25" width="0.2032" layer="21"/>
<pad name="P$1" x="-7.62" y="0" drill="1.2" diameter="1.8796"/>
<pad name="P$2" x="7.62" y="0" drill="1.2" diameter="1.8796"/>
<text x="-5.715" y="3.175" size="0.8128" layer="25" font="vector" ratio="15">&gt;Name</text>
<text x="-4.064" y="-0.381" size="0.8128" layer="21" font="vector" ratio="15">&gt;Value</text>
</package>
<package name="AXIAL-0.8">
<description>2W Resistor, 0.8" wide&lt;p&gt;

Yageo CFR series &lt;a href="http://www.yageo.com/pdf/yageo/Leaded-R_CFR_2008.pdf"&gt;http://www.yageo.com/pdf/yageo/Leaded-R_CFR_2008.pdf&lt;/a&gt;</description>
<wire x1="-7.75" y1="-2.5" x2="-7.75" y2="2.5" width="0.2032" layer="21"/>
<wire x1="-7.75" y1="2.5" x2="7.75" y2="2.5" width="0.2032" layer="21"/>
<wire x1="7.75" y1="2.5" x2="7.75" y2="-2.5" width="0.2032" layer="21"/>
<wire x1="7.75" y1="-2.5" x2="-7.75" y2="-2.5" width="0.2032" layer="21"/>
<pad name="P$1" x="-10.16" y="0" drill="1.2" diameter="1.8796"/>
<pad name="P$2" x="10.16" y="0" drill="1.2" diameter="1.8796"/>
<text x="-7.62" y="3.175" size="0.8128" layer="25" font="vector" ratio="15">&gt;Name</text>
<text x="-5.969" y="-0.381" size="0.8128" layer="21" font="vector" ratio="15">&gt;Value</text>
</package>
<package name="AXIAL-0.3-KIT">
<description>&lt;h3&gt;AXIAL-0.3-KIT&lt;/h3&gt;

Commonly used for 1/4W through-hole resistors. 0.3" pitch between holes.&lt;br&gt;
&lt;br&gt;

&lt;b&gt;Warning:&lt;/b&gt; This is the KIT version of the AXIAL-0.3 package. This package has a smaller diameter top stop mask, which doesn't cover the diameter of the pad. This means only the bottom side of the pads' copper will be exposed. You'll only be able to solder to the bottom side.</description>
<wire x1="-2.54" y1="1.27" x2="2.54" y2="1.27" width="0.254" layer="21"/>
<wire x1="2.54" y1="1.27" x2="2.54" y2="0" width="0.254" layer="21"/>
<wire x1="2.54" y1="0" x2="2.54" y2="-1.27" width="0.254" layer="21"/>
<wire x1="2.54" y1="-1.27" x2="-2.54" y2="-1.27" width="0.254" layer="21"/>
<wire x1="-2.54" y1="-1.27" x2="-2.54" y2="0" width="0.254" layer="21"/>
<wire x1="-2.54" y1="0" x2="-2.54" y2="1.27" width="0.254" layer="21"/>
<wire x1="2.54" y1="0" x2="2.794" y2="0" width="0.254" layer="21"/>
<wire x1="-2.54" y1="0" x2="-2.794" y2="0" width="0.254" layer="21"/>
<pad name="P$1" x="-3.81" y="0" drill="1.016" diameter="2.032" stop="no"/>
<pad name="P$2" x="3.81" y="0" drill="1.016" diameter="2.032" stop="no"/>
<text x="-2.54" y="1.27" size="0.4064" layer="25" font="vector">&gt;Name</text>
<text x="-2.159" y="-0.762" size="1.27" layer="21" font="vector" ratio="15">&gt;Value</text>
<polygon width="0.127" layer="30">
<vertex x="3.8201" y="-0.9449" curve="-90"/>
<vertex x="2.8652" y="-0.0152" curve="-90.011749"/>
<vertex x="3.8176" y="0.9602" curve="-90"/>
<vertex x="4.7676" y="-0.0178" curve="-90.024193"/>
</polygon>
<polygon width="0.127" layer="29">
<vertex x="3.8176" y="-0.4369" curve="-90.012891"/>
<vertex x="3.3731" y="-0.0127" curve="-90"/>
<vertex x="3.8176" y="0.4546" curve="-90"/>
<vertex x="4.2595" y="-0.0025" curve="-90.012967"/>
</polygon>
<polygon width="0.127" layer="30">
<vertex x="-3.8075" y="-0.9525" curve="-90"/>
<vertex x="-4.7624" y="-0.0228" curve="-90.011749"/>
<vertex x="-3.81" y="0.9526" curve="-90"/>
<vertex x="-2.86" y="-0.0254" curve="-90.024193"/>
</polygon>
<polygon width="0.127" layer="29">
<vertex x="-3.81" y="-0.4445" curve="-90.012891"/>
<vertex x="-4.2545" y="-0.0203" curve="-90"/>
<vertex x="-3.81" y="0.447" curve="-90"/>
<vertex x="-3.3681" y="-0.0101" curve="-90.012967"/>
</polygon>
</package>
<package name="AXIAL-0.3EZ">
<description>This is the "EZ" version of the standard .3" spaced resistor package.&lt;br&gt;
It has a reduced top mask to make it harder to install upside-down.</description>
<wire x1="-2.54" y1="0.762" x2="2.54" y2="0.762" width="0.2032" layer="21"/>
<wire x1="2.54" y1="0.762" x2="2.54" y2="0" width="0.2032" layer="21"/>
<wire x1="2.54" y1="0" x2="2.54" y2="-0.762" width="0.2032" layer="21"/>
<wire x1="2.54" y1="-0.762" x2="-2.54" y2="-0.762" width="0.2032" layer="21"/>
<wire x1="-2.54" y1="-0.762" x2="-2.54" y2="0" width="0.2032" layer="21"/>
<wire x1="-2.54" y1="0" x2="-2.54" y2="0.762" width="0.2032" layer="21"/>
<wire x1="2.54" y1="0" x2="2.794" y2="0" width="0.2032" layer="21"/>
<wire x1="-2.54" y1="0" x2="-2.794" y2="0" width="0.2032" layer="21"/>
<pad name="P$1" x="-3.81" y="0" drill="0.9" diameter="1.8796" stop="no"/>
<pad name="P$2" x="3.81" y="0" drill="0.9" diameter="1.8796" stop="no"/>
<text x="-2.54" y="1.27" size="0.4064" layer="25" font="vector">&gt;Name</text>
<text x="-2.032" y="-0.381" size="1.016" layer="21" font="vector" ratio="15">&gt;Value</text>
<circle x="-3.81" y="0" radius="0.508" width="0" layer="29"/>
<circle x="3.81" y="0" radius="0.523634375" width="0" layer="29"/>
<circle x="-3.81" y="0" radius="1.02390625" width="0" layer="30"/>
<circle x="3.81" y="0" radius="1.04726875" width="0" layer="30"/>
</package>
</packages>
<symbols>
<symbol name="RESISTOR">
<wire x1="-2.54" y1="0" x2="-2.159" y2="1.016" width="0.1524" layer="94"/>
<wire x1="-2.159" y1="1.016" x2="-1.524" y2="-1.016" width="0.1524" layer="94"/>
<wire x1="-1.524" y1="-1.016" x2="-0.889" y2="1.016" width="0.1524" layer="94"/>
<wire x1="-0.889" y1="1.016" x2="-0.254" y2="-1.016" width="0.1524" layer="94"/>
<wire x1="-0.254" y1="-1.016" x2="0.381" y2="1.016" width="0.1524" layer="94"/>
<wire x1="0.381" y1="1.016" x2="1.016" y2="-1.016" width="0.1524" layer="94"/>
<wire x1="1.016" y1="-1.016" x2="1.651" y2="1.016" width="0.1524" layer="94"/>
<wire x1="1.651" y1="1.016" x2="2.286" y2="-1.016" width="0.1524" layer="94"/>
<wire x1="2.286" y1="-1.016" x2="2.54" y2="0" width="0.1524" layer="94"/>
<text x="-3.81" y="1.4986" size="1.778" layer="95">&gt;NAME</text>
<text x="-3.81" y="-3.302" size="1.778" layer="96">&gt;VALUE</text>
<pin name="2" x="5.08" y="0" visible="off" length="short" direction="pas" swaplevel="1" rot="R180"/>
<pin name="1" x="-5.08" y="0" visible="off" length="short" direction="pas" swaplevel="1"/>
</symbol>
</symbols>
<devicesets>
<deviceset name="RESISTOR" prefix="R" uservalue="yes">
<description>&lt;b&gt;Resistor&lt;/b&gt;
Basic schematic elements and footprints for 0603, 1206, and PTH resistors.</description>
<gates>
<gate name="G$1" symbol="RESISTOR" x="0" y="0"/>
</gates>
<devices>
<device name="1206" package="1206">
<connects>
<connect gate="G$1" pin="1" pad="1"/>
<connect gate="G$1" pin="2" pad="2"/>
</connects>
<technologies>
<technology name=""/>
</technologies>
</device>
<device name="AXIAL-0.3" package="AXIAL-0.3">
<connects>
<connect gate="G$1" pin="1" pad="P$1"/>
<connect gate="G$1" pin="2" pad="P$2"/>
</connects>
<technologies>
<technology name=""/>
</technologies>
</device>
<device name="2010" package="R2010">
<connects>
<connect gate="G$1" pin="1" pad="1"/>
<connect gate="G$1" pin="2" pad="2"/>
</connects>
<technologies>
<technology name=""/>
</technologies>
</device>
<device name="0805-RES" package="0805">
<connects>
<connect gate="G$1" pin="1" pad="1"/>
<connect gate="G$1" pin="2" pad="2"/>
</connects>
<technologies>
<technology name=""/>
</technologies>
</device>
<device name="0603-RES" package="0603-RES">
<connects>
<connect gate="G$1" pin="1" pad="1"/>
<connect gate="G$1" pin="2" pad="2"/>
</connects>
<technologies>
<technology name=""/>
</technologies>
</device>
<device name="0402-RES" package="0402-RES">
<connects>
<connect gate="G$1" pin="1" pad="1"/>
<connect gate="G$1" pin="2" pad="2"/>
</connects>
<technologies>
<technology name=""/>
</technologies>
</device>
<device name="PTH-1/6W" package="1/6W-RES">
<connects>
<connect gate="G$1" pin="1" pad="1"/>
<connect gate="G$1" pin="2" pad="2"/>
</connects>
<technologies>
<technology name=""/>
</technologies>
</device>
<device name="2512" package="R2512">
<connects>
<connect gate="G$1" pin="1" pad="1"/>
<connect gate="G$1" pin="2" pad="2"/>
</connects>
<technologies>
<technology name=""/>
</technologies>
</device>
<device name="PTH-1/4W" package="AXIAL-0.4">
<connects>
<connect gate="G$1" pin="1" pad="P$1"/>
<connect gate="G$1" pin="2" pad="P$2"/>
</connects>
<technologies>
<technology name=""/>
</technologies>
</device>
<device name="PTH-1/2W" package="AXIAL-0.5">
<connects>
<connect gate="G$1" pin="1" pad="P$1"/>
<connect gate="G$1" pin="2" pad="P$2"/>
</connects>
<technologies>
<technology name=""/>
</technologies>
</device>
<device name="PTH-1W" package="AXIAL-0.6">
<connects>
<connect gate="G$1" pin="1" pad="P$1"/>
<connect gate="G$1" pin="2" pad="P$2"/>
</connects>
<technologies>
<technology name=""/>
</technologies>
</device>
<device name="PTH-2W" package="AXIAL-0.8">
<connects>
<connect gate="G$1" pin="1" pad="P$1"/>
<connect gate="G$1" pin="2" pad="P$2"/>
</connects>
<technologies>
<technology name=""/>
</technologies>
</device>
<device name="KIT" package="AXIAL-0.3-KIT">
<connects>
<connect gate="G$1" pin="1" pad="P$1"/>
<connect gate="G$1" pin="2" pad="P$2"/>
</connects>
<technologies>
<technology name=""/>
</technologies>
</device>
<device name="EZ" package="AXIAL-0.3EZ">
<connects>
<connect gate="G$1" pin="1" pad="P$1"/>
<connect gate="G$1" pin="2" pad="P$2"/>
</connects>
<technologies>
<technology name=""/>
</technologies>
</device>
</devices>
</deviceset>
</devicesets>
</library>
<library name="triac">
<description>&lt;b&gt;Thyristors, Triacs, Trigger Diodes&lt;/b&gt;&lt;p&gt;
&lt;author&gt;Created by librarian@cadsoft.de&lt;/author&gt;</description>
<packages>
<package name="TO220AB">
<description>&lt;B&gt;TO220 AB&lt;/B&gt;&lt;p&gt;
3-lead molded horzintal</description>
<wire x1="-5.207" y1="-1.27" x2="5.207" y2="-1.27" width="0.1524" layer="21"/>
<wire x1="5.207" y1="14.605" x2="-5.207" y2="14.605" width="0.1524" layer="21"/>
<wire x1="5.207" y1="-1.27" x2="5.207" y2="11.176" width="0.1524" layer="21"/>
<wire x1="5.207" y1="11.176" x2="4.318" y2="11.176" width="0.1524" layer="21"/>
<wire x1="4.318" y1="11.176" x2="4.318" y2="12.7" width="0.1524" layer="21"/>
<wire x1="4.318" y1="12.7" x2="5.207" y2="12.7" width="0.1524" layer="21"/>
<wire x1="5.207" y1="12.7" x2="5.207" y2="14.605" width="0.1524" layer="21"/>
<wire x1="-5.207" y1="-1.27" x2="-5.207" y2="11.176" width="0.1524" layer="21"/>
<wire x1="-5.207" y1="11.176" x2="-4.318" y2="11.176" width="0.1524" layer="21"/>
<wire x1="-4.318" y1="11.176" x2="-4.318" y2="12.7" width="0.1524" layer="21"/>
<wire x1="-4.318" y1="12.7" x2="-5.207" y2="12.7" width="0.1524" layer="21"/>
<wire x1="-5.207" y1="12.7" x2="-5.207" y2="14.605" width="0.1524" layer="21"/>
<wire x1="-4.572" y1="-0.635" x2="4.572" y2="-0.635" width="0.0508" layer="21"/>
<wire x1="4.572" y1="7.62" x2="4.572" y2="-0.635" width="0.0508" layer="21"/>
<wire x1="4.572" y1="7.62" x2="-4.572" y2="7.62" width="0.0508" layer="21"/>
<wire x1="-4.572" y1="-0.635" x2="-4.572" y2="7.62" width="0.0508" layer="21"/>
<circle x="0" y="11.176" radius="1.8034" width="0.1524" layer="21"/>
<circle x="0" y="11.176" radius="2.921" width="0" layer="42"/>
<circle x="0" y="11.176" radius="2.921" width="0" layer="43"/>
<pad name="1" x="-2.54" y="-6.35" drill="1.1176" shape="long" rot="R90"/>
<pad name="2" x="0" y="-6.35" drill="1.1176" shape="long" rot="R90"/>
<pad name="3" x="2.54" y="-6.35" drill="1.1176" shape="long" rot="R90"/>
<text x="-5.461" y="-1.27" size="1.778" layer="25" ratio="10" rot="R90">&gt;NAME</text>
<text x="-3.937" y="2.54" size="1.778" layer="27" ratio="10">&gt;VALUE</text>
<text x="-4.445" y="7.874" size="0.9906" layer="21" ratio="10">A17,5mm</text>
<rectangle x1="2.159" y1="-4.445" x2="2.921" y2="-3.81" layer="21"/>
<rectangle x1="-0.381" y1="-4.445" x2="0.381" y2="-3.81" layer="21"/>
<rectangle x1="-2.921" y1="-4.445" x2="-2.159" y2="-3.81" layer="21"/>
<rectangle x1="-3.175" y1="-3.81" x2="-1.905" y2="-1.27" layer="21"/>
<rectangle x1="-0.635" y1="-3.81" x2="0.635" y2="-1.27" layer="21"/>
<rectangle x1="1.905" y1="-3.81" x2="3.175" y2="-1.27" layer="21"/>
<rectangle x1="2.159" y1="-6.35" x2="2.921" y2="-4.445" layer="51"/>
<rectangle x1="-0.381" y1="-6.35" x2="0.381" y2="-4.445" layer="51"/>
<rectangle x1="-2.921" y1="-6.35" x2="-2.159" y2="-4.445" layer="51"/>
<hole x="0" y="11.176" drill="3.302"/>
</package>
</packages>
<symbols>
<symbol name="TRIAC">
<wire x1="-2.54" y1="2.794" x2="-1.016" y2="0.508" width="0.254" layer="94"/>
<wire x1="-1.016" y1="0.508" x2="0.254" y2="2.794" width="0.254" layer="94"/>
<wire x1="0.254" y1="2.794" x2="-2.54" y2="2.794" width="0.254" layer="94"/>
<wire x1="1.016" y1="2.794" x2="0.254" y2="2.794" width="0.254" layer="94"/>
<wire x1="-0.254" y1="0.508" x2="1.016" y2="2.794" width="0.254" layer="94"/>
<wire x1="1.016" y1="2.794" x2="2.54" y2="0.508" width="0.254" layer="94"/>
<wire x1="2.54" y1="0.508" x2="0" y2="0.508" width="0.254" layer="94"/>
<wire x1="0" y1="0.508" x2="-0.254" y2="0.508" width="0.254" layer="94"/>
<wire x1="1.016" y1="2.794" x2="2.54" y2="2.794" width="0.254" layer="94"/>
<wire x1="-1.905" y1="0.508" x2="-2.54" y2="0" width="0.1524" layer="94"/>
<wire x1="-1.016" y1="0.508" x2="-1.905" y2="0.508" width="0.254" layer="94"/>
<wire x1="-1.905" y1="0.508" x2="-2.54" y2="0.508" width="0.254" layer="94"/>
<wire x1="-1.016" y1="0.508" x2="-0.254" y2="0.508" width="0.254" layer="94"/>
<wire x1="0" y1="0" x2="0" y2="0.508" width="0.1524" layer="94"/>
<text x="3.81" y="2.54" size="1.778" layer="95">&gt;NAME</text>
<text x="3.81" y="0" size="1.778" layer="96">&gt;VALUE</text>
<pin name="A2" x="0" y="5.08" visible="off" length="short" direction="pas" rot="R270"/>
<pin name="A1" x="0" y="-2.54" visible="off" length="short" direction="pas" rot="R90"/>
<pin name="G" x="-5.08" y="0" visible="off" length="short" direction="pas"/>
</symbol>
</symbols>
<devicesets>
<deviceset name="BT136" prefix="T">
<description>&lt;b&gt;Triac BT136 series E sensitive gate&lt;/b&gt;&lt;p&gt;
Source: http://www.nxp.com/acrobat_download/datasheets/BT136_SERIES_E_2.pdf</description>
<gates>
<gate name="-1" symbol="TRIAC" x="0" y="0"/>
</gates>
<devices>
<device name="" package="TO220AB">
<connects>
<connect gate="-1" pin="A1" pad="1"/>
<connect gate="-1" pin="A2" pad="2"/>
<connect gate="-1" pin="G" pad="3"/>
</connects>
<technologies>
<technology name=""/>
</technologies>
</device>
</devices>
</deviceset>
</devicesets>
</library>
<library name="supply2">
<description>&lt;b&gt;Supply Symbols&lt;/b&gt;&lt;p&gt;
GND, VCC, 0V, +5V, -5V, etc.&lt;p&gt;
Please keep in mind, that these devices are necessary for the
automatic wiring of the supply signals.&lt;p&gt;
The pin name defined in the symbol is identical to the net which is to be wired automatically.&lt;p&gt;
In this library the device names are the same as the pin names of the symbols, therefore the correct signal names appear next to the supply symbols in the schematic.&lt;p&gt;
&lt;author&gt;Created by librarian@cadsoft.de&lt;/author&gt;</description>
<packages>
</packages>
<symbols>
<symbol name="VEE">
<circle x="0" y="1.27" radius="1.27" width="0.254" layer="94"/>
<text x="-1.905" y="3.175" size="1.778" layer="96">&gt;VALUE</text>
<pin name="VEE" x="0" y="-2.54" visible="off" length="short" direction="sup" rot="R90"/>
</symbol>
</symbols>
<devicesets>
<deviceset name="VEE" prefix="SUPPLY">
<description>&lt;b&gt;SUPPLY SYMBOL&lt;/b&gt;</description>
<gates>
<gate name="G$1" symbol="VEE" x="0" y="0"/>
</gates>
<devices>
<device name="">
<technologies>
<technology name=""/>
</technologies>
</device>
</devices>
</deviceset>
</devicesets>
</library>
</libraries>
<attributes>
</attributes>
<variantdefs>
</variantdefs>
<classes>
<class number="0" name="default" width="0" drill="0">
</class>
</classes>
<parts>
<part name="U$1" library="pizero" deviceset="PIZERO_THROUGH_HOLE" device=""/>
<part name="OK1" library="optocoupler" deviceset="H11A*?M" device="" technology="1"/>
<part name="R1" library="SparkFun-Passives" deviceset="RESISTOR" device="PTH-2W" value="10k 2W"/>
<part name="R2" library="SparkFun-Passives" deviceset="RESISTOR" device="PTH-2W" value="10k 2W"/>
<part name="AC_IN" library="SparkFun-Connectors" deviceset="M02" device="3.5MM_LOCK" value="230v"/>
<part name="GND1" library="SparkFun-Aesthetics" deviceset="GND" device=""/>
<part name="SUPPLY1" library="SparkFun-Aesthetics" deviceset="VCC" device=""/>
<part name="R3" library="SparkFun-Passives" deviceset="RESISTOR" device="PTH-1/4W" value="10k"/>
<part name="FRAME1" library="frames" deviceset="A3L-LOC" device=""/>
<part name="SUPPLY2" library="SparkFun-Aesthetics" deviceset="VCC" device=""/>
<part name="GND2" library="SparkFun-Aesthetics" deviceset="GND" device=""/>
<part name="GND3" library="SparkFun-Aesthetics" deviceset="GND" device=""/>
<part name="SUPPLY3" library="SparkFun-Aesthetics" deviceset="VCC" device=""/>
<part name="GND4" library="SparkFun-Aesthetics" deviceset="GND" device=""/>
<part name="JP2" library="pinhead" deviceset="PINHD-1X3" device=""/>
<part name="JP3" library="pinhead" deviceset="PINHD-1X3" device=""/>
<part name="GND5" library="SparkFun-Aesthetics" deviceset="GND" device=""/>
<part name="SUPPLY4" library="SparkFun-Aesthetics" deviceset="VCC" device=""/>
<part name="J1" library="SparkFun-Connectors" deviceset="M02" device="3.5MM_LOCK"/>
<part name="OK2" library="optocoupler" deviceset="MOC30*" device="" technology="31M"/>
<part name="T1" library="triac" deviceset="BT136" device=""/>
<part name="R4" library="SparkFun-Passives" deviceset="RESISTOR" device="PTH-1/4W" value="330E"/>
<part name="R5" library="SparkFun-Passives" deviceset="RESISTOR" device="PTH-1/2W" value="180E 1/2W"/>
<part name="J2" library="SparkFun-Connectors" deviceset="M02" device="3.5MM_LOCK"/>
<part name="SUPPLY5" library="supply2" deviceset="VEE" device="" value="VEE 3v3"/>
<part name="SUPPLY6" library="supply2" deviceset="VEE" device="" value="VEE 3v3"/>
<part name="OK3" library="optocoupler" deviceset="MOC30*" device="" technology="31M"/>
<part name="T2" library="triac" deviceset="BT136" device=""/>
<part name="R6" library="SparkFun-Passives" deviceset="RESISTOR" device="PTH-1/4W" value="330E"/>
<part name="R7" library="SparkFun-Passives" deviceset="RESISTOR" device="PTH-1/2W" value="180E 1/2W"/>
<part name="J3" library="SparkFun-Connectors" deviceset="M02" device="3.5MM_LOCK"/>
<part name="SUPPLY7" library="supply2" deviceset="VEE" device="" value="VEE 3v3"/>
<part name="OK4" library="optocoupler" deviceset="MOC30*" device="" technology="31M"/>
<part name="T3" library="triac" deviceset="BT136" device=""/>
<part name="R8" library="SparkFun-Passives" deviceset="RESISTOR" device="PTH-1/4W" value="330E"/>
<part name="R9" library="SparkFun-Passives" deviceset="RESISTOR" device="PTH-1/2W" value="180E 1/2W"/>
<part name="J4" library="SparkFun-Connectors" deviceset="M02" device="3.5MM_LOCK"/>
<part name="SUPPLY8" library="supply2" deviceset="VEE" device="" value="VEE 3v3"/>
<part name="OK5" library="optocoupler" deviceset="MOC30*" device="" technology="31M"/>
<part name="T4" library="triac" deviceset="BT136" device=""/>
<part name="R10" library="SparkFun-Passives" deviceset="RESISTOR" device="PTH-1/4W" value="330E"/>
<part name="R11" library="SparkFun-Passives" deviceset="RESISTOR" device="PTH-1/2W" value="180E 1/2W"/>
<part name="J5" library="SparkFun-Connectors" deviceset="M02" device="3.5MM_LOCK"/>
<part name="SUPPLY9" library="supply2" deviceset="VEE" device="" value="VEE 3v3"/>
<part name="OK6" library="optocoupler" deviceset="MOC30*" device="" technology="31M"/>
<part name="T5" library="triac" deviceset="BT136" device=""/>
<part name="R12" library="SparkFun-Passives" deviceset="RESISTOR" device="PTH-1/4W" value="330E"/>
<part name="R13" library="SparkFun-Passives" deviceset="RESISTOR" device="PTH-1/2W" value="180E 1/2W"/>
<part name="J6" library="SparkFun-Connectors" deviceset="M02" device="3.5MM_LOCK"/>
<part name="SUPPLY10" library="supply2" deviceset="VEE" device="" value="VEE 3v3"/>
<part name="OK7" library="optocoupler" deviceset="MOC30*" device="" technology="31M"/>
<part name="T6" library="triac" deviceset="BT136" device=""/>
<part name="R14" library="SparkFun-Passives" deviceset="RESISTOR" device="PTH-1/4W" value="330E"/>
<part name="R15" library="SparkFun-Passives" deviceset="RESISTOR" device="PTH-1/2W" value="180E 1/2W"/>
<part name="J7" library="SparkFun-Connectors" deviceset="M02" device="3.5MM_LOCK"/>
<part name="SUPPLY11" library="supply2" deviceset="VEE" device="" value="VEE 3v3"/>
<part name="OK8" library="optocoupler" deviceset="MOC30*" device="" technology="31M"/>
<part name="T7" library="triac" deviceset="BT136" device=""/>
<part name="R16" library="SparkFun-Passives" deviceset="RESISTOR" device="PTH-1/4W" value="330E"/>
<part name="R17" library="SparkFun-Passives" deviceset="RESISTOR" device="PTH-1/2W" value="180E 1/2W"/>
<part name="J8" library="SparkFun-Connectors" deviceset="M02" device="3.5MM_LOCK"/>
<part name="SUPPLY12" library="supply2" deviceset="VEE" device="" value="VEE 3v3"/>
<part name="OK9" library="optocoupler" deviceset="MOC30*" device="" technology="31M"/>
<part name="T8" library="triac" deviceset="BT136" device=""/>
<part name="R18" library="SparkFun-Passives" deviceset="RESISTOR" device="PTH-1/4W" value="330E"/>
<part name="R19" library="SparkFun-Passives" deviceset="RESISTOR" device="PTH-1/2W" value="180E 1/2W"/>
<part name="J9" library="SparkFun-Connectors" deviceset="M02" device="3.5MM_LOCK"/>
<part name="SUPPLY13" library="supply2" deviceset="VEE" device="" value="VEE 3v3"/>
</parts>
<sheets>
<sheet>
<plain>
<text x="-66.04" y="93.98" size="1.778" layer="91">MAINS ZCD</text>
<text x="-88.9" y="43.18" size="1.778" layer="91">SMPS_IN</text>
<text x="15.24" y="104.14" size="1.778" layer="91">PIR [3-pin JST connectors]</text>
<text x="-60.96" y="2.54" size="1.778" layer="91">OUTPUT_TRIACS</text>
</plain>
<instances>
<instance part="U$1" gate="1" x="114.3" y="76.2" rot="R180"/>
<instance part="OK1" gate="G$1" x="-35.56" y="76.2"/>
<instance part="R1" gate="G$1" x="-60.96" y="78.74"/>
<instance part="R2" gate="G$1" x="-60.96" y="71.12"/>
<instance part="AC_IN" gate="G$1" x="-83.82" y="73.66"/>
<instance part="GND1" gate="1" x="-20.32" y="55.88"/>
<instance part="SUPPLY1" gate="G$1" x="-20.32" y="99.06"/>
<instance part="R3" gate="G$1" x="-20.32" y="86.36" rot="R90"/>
<instance part="FRAME1" gate="G$1" x="-114.3" y="-147.32"/>
<instance part="SUPPLY2" gate="G$1" x="127" y="73.66" rot="R270"/>
<instance part="GND2" gate="1" x="137.16" y="68.58" rot="R90"/>
<instance part="GND3" gate="1" x="96.52" y="20.32"/>
<instance part="SUPPLY3" gate="G$1" x="-73.66" y="40.64"/>
<instance part="GND4" gate="1" x="-73.66" y="22.86"/>
<instance part="JP2" gate="A" x="20.32" y="99.06" rot="R90"/>
<instance part="JP3" gate="A" x="38.1" y="99.06" rot="R90"/>
<instance part="GND5" gate="1" x="17.78" y="66.04"/>
<instance part="SUPPLY4" gate="G$1" x="40.64" y="68.58" rot="R180"/>
<instance part="J1" gate="G$1" x="-86.36" y="30.48"/>
<instance part="OK2" gate="-1" x="-55.88" y="-20.32"/>
<instance part="T1" gate="-1" x="-22.86" y="-25.4"/>
<instance part="R4" gate="G$1" x="-76.2" y="-25.4" rot="R180"/>
<instance part="R5" gate="G$1" x="-35.56" y="-15.24"/>
<instance part="J2" gate="G$1" x="0" y="-17.78" rot="R180"/>
<instance part="SUPPLY5" gate="G$1" x="-73.66" y="-7.62"/>
<instance part="SUPPLY6" gate="G$1" x="99.06" y="83.82"/>
<instance part="OK3" gate="-1" x="-53.34" y="-55.88"/>
<instance part="T2" gate="-1" x="-22.86" y="-60.96"/>
<instance part="R6" gate="G$1" x="-76.2" y="-60.96" rot="R180"/>
<instance part="R7" gate="G$1" x="-35.56" y="-50.8"/>
<instance part="J3" gate="G$1" x="0" y="-53.34" rot="R180"/>
<instance part="SUPPLY7" gate="G$1" x="-73.66" y="-43.18"/>
<instance part="OK4" gate="-1" x="-55.88" y="-91.44"/>
<instance part="T3" gate="-1" x="-22.86" y="-96.52"/>
<instance part="R8" gate="G$1" x="-76.2" y="-96.52" rot="R180"/>
<instance part="R9" gate="G$1" x="-35.56" y="-86.36"/>
<instance part="J4" gate="G$1" x="0" y="-88.9" rot="R180"/>
<instance part="SUPPLY8" gate="G$1" x="-73.66" y="-78.74"/>
<instance part="OK5" gate="-1" x="-55.88" y="-127"/>
<instance part="T4" gate="-1" x="-22.86" y="-132.08"/>
<instance part="R10" gate="G$1" x="-76.2" y="-132.08" rot="R180"/>
<instance part="R11" gate="G$1" x="-35.56" y="-121.92"/>
<instance part="J5" gate="G$1" x="0" y="-124.46" rot="R180"/>
<instance part="SUPPLY9" gate="G$1" x="-73.66" y="-114.3"/>
<instance part="OK6" gate="-1" x="48.26" y="-20.32"/>
<instance part="T5" gate="-1" x="81.28" y="-25.4"/>
<instance part="R12" gate="G$1" x="27.94" y="-25.4" rot="R180"/>
<instance part="R13" gate="G$1" x="68.58" y="-15.24"/>
<instance part="J6" gate="G$1" x="104.14" y="-17.78" rot="R180"/>
<instance part="SUPPLY10" gate="G$1" x="30.48" y="-7.62"/>
<instance part="OK7" gate="-1" x="48.26" y="-55.88"/>
<instance part="T6" gate="-1" x="81.28" y="-60.96"/>
<instance part="R14" gate="G$1" x="27.94" y="-60.96" rot="R180"/>
<instance part="R15" gate="G$1" x="68.58" y="-50.8"/>
<instance part="J7" gate="G$1" x="104.14" y="-53.34" rot="R180"/>
<instance part="SUPPLY11" gate="G$1" x="30.48" y="-43.18"/>
<instance part="OK8" gate="-1" x="48.26" y="-91.44"/>
<instance part="T7" gate="-1" x="81.28" y="-96.52"/>
<instance part="R16" gate="G$1" x="27.94" y="-96.52" rot="R180"/>
<instance part="R17" gate="G$1" x="68.58" y="-86.36"/>
<instance part="J8" gate="G$1" x="104.14" y="-88.9" rot="R180"/>
<instance part="SUPPLY12" gate="G$1" x="30.48" y="-78.74"/>
<instance part="OK9" gate="-1" x="48.26" y="-127"/>
<instance part="T8" gate="-1" x="81.28" y="-132.08"/>
<instance part="R18" gate="G$1" x="27.94" y="-132.08" rot="R180"/>
<instance part="R19" gate="G$1" x="68.58" y="-121.92"/>
<instance part="J9" gate="G$1" x="104.14" y="-124.46" rot="R180"/>
<instance part="SUPPLY13" gate="G$1" x="30.48" y="-114.3"/>
</instances>
<busses>
</busses>
<nets>
<net name="N$1" class="0">
<segment>
<pinref part="AC_IN" gate="G$1" pin="2"/>
<wire x1="-76.2" y1="76.2" x2="-73.66" y2="76.2" width="0.1524" layer="91"/>
<wire x1="-73.66" y1="76.2" x2="-73.66" y2="78.74" width="0.1524" layer="91"/>
<pinref part="R1" gate="G$1" pin="1"/>
<wire x1="-73.66" y1="78.74" x2="-66.04" y2="78.74" width="0.1524" layer="91"/>
</segment>
</net>
<net name="N$2" class="0">
<segment>
<pinref part="R2" gate="G$1" pin="1"/>
<wire x1="-66.04" y1="71.12" x2="-73.66" y2="71.12" width="0.1524" layer="91"/>
<wire x1="-73.66" y1="71.12" x2="-73.66" y2="73.66" width="0.1524" layer="91"/>
<pinref part="AC_IN" gate="G$1" pin="1"/>
<wire x1="-73.66" y1="73.66" x2="-76.2" y2="73.66" width="0.1524" layer="91"/>
</segment>
</net>
<net name="N$3" class="0">
<segment>
<pinref part="R1" gate="G$1" pin="2"/>
<pinref part="OK1" gate="G$1" pin="A"/>
<wire x1="-55.88" y1="78.74" x2="-45.72" y2="78.74" width="0.1524" layer="91"/>
</segment>
</net>
<net name="N$4" class="0">
<segment>
<pinref part="OK1" gate="G$1" pin="C"/>
<pinref part="R2" gate="G$1" pin="2"/>
<wire x1="-45.72" y1="71.12" x2="-55.88" y2="71.12" width="0.1524" layer="91"/>
</segment>
</net>
<net name="VCC" class="0">
<segment>
<pinref part="SUPPLY1" gate="G$1" pin="VCC"/>
<pinref part="R3" gate="G$1" pin="2"/>
<wire x1="-20.32" y1="99.06" x2="-20.32" y2="91.44" width="0.1524" layer="91"/>
</segment>
<segment>
<pinref part="U$1" gate="1" pin="2"/>
<pinref part="SUPPLY2" gate="G$1" pin="VCC"/>
<wire x1="116.84" y1="73.66" x2="119.38" y2="73.66" width="0.1524" layer="91"/>
<pinref part="U$1" gate="1" pin="4"/>
<wire x1="119.38" y1="73.66" x2="127" y2="73.66" width="0.1524" layer="91"/>
<wire x1="116.84" y1="71.12" x2="119.38" y2="71.12" width="0.1524" layer="91"/>
<wire x1="119.38" y1="71.12" x2="119.38" y2="73.66" width="0.1524" layer="91"/>
<junction x="119.38" y="73.66"/>
</segment>
<segment>
<pinref part="JP3" gate="A" pin="3"/>
<pinref part="SUPPLY4" gate="G$1" pin="VCC"/>
<wire x1="40.64" y1="96.52" x2="40.64" y2="76.2" width="0.1524" layer="91"/>
<pinref part="JP2" gate="A" pin="3"/>
<wire x1="40.64" y1="76.2" x2="40.64" y2="68.58" width="0.1524" layer="91"/>
<wire x1="22.86" y1="96.52" x2="22.86" y2="76.2" width="0.1524" layer="91"/>
<wire x1="22.86" y1="76.2" x2="40.64" y2="76.2" width="0.1524" layer="91"/>
<junction x="40.64" y="76.2"/>
</segment>
<segment>
<pinref part="J1" gate="G$1" pin="2"/>
<pinref part="SUPPLY3" gate="G$1" pin="VCC"/>
<wire x1="-78.74" y1="33.02" x2="-73.66" y2="33.02" width="0.1524" layer="91"/>
<wire x1="-73.66" y1="33.02" x2="-73.66" y2="40.64" width="0.1524" layer="91"/>
</segment>
</net>
<net name="GND" class="0">
<segment>
<pinref part="OK1" gate="G$1" pin="EMI"/>
<pinref part="GND1" gate="1" pin="GND"/>
<wire x1="-27.94" y1="71.12" x2="-20.32" y2="71.12" width="0.1524" layer="91"/>
<wire x1="-20.32" y1="71.12" x2="-20.32" y2="58.42" width="0.1524" layer="91"/>
</segment>
<segment>
<pinref part="U$1" gate="1" pin="6"/>
<pinref part="GND2" gate="1" pin="GND"/>
<wire x1="116.84" y1="68.58" x2="134.62" y2="68.58" width="0.1524" layer="91"/>
</segment>
<segment>
<pinref part="U$1" gate="1" pin="39"/>
<pinref part="GND3" gate="1" pin="GND"/>
<wire x1="101.6" y1="25.4" x2="96.52" y2="25.4" width="0.1524" layer="91"/>
<wire x1="96.52" y1="25.4" x2="96.52" y2="22.86" width="0.1524" layer="91"/>
</segment>
<segment>
<pinref part="JP2" gate="A" pin="1"/>
<pinref part="GND5" gate="1" pin="GND"/>
<wire x1="17.78" y1="96.52" x2="17.78" y2="81.28" width="0.1524" layer="91"/>
<pinref part="JP3" gate="A" pin="1"/>
<wire x1="17.78" y1="81.28" x2="17.78" y2="68.58" width="0.1524" layer="91"/>
<wire x1="35.56" y1="96.52" x2="35.56" y2="81.28" width="0.1524" layer="91"/>
<wire x1="35.56" y1="81.28" x2="17.78" y2="81.28" width="0.1524" layer="91"/>
<junction x="17.78" y="81.28"/>
</segment>
<segment>
<pinref part="J1" gate="G$1" pin="1"/>
<pinref part="GND4" gate="1" pin="GND"/>
<wire x1="-78.74" y1="30.48" x2="-73.66" y2="30.48" width="0.1524" layer="91"/>
<wire x1="-73.66" y1="30.48" x2="-73.66" y2="25.4" width="0.1524" layer="91"/>
</segment>
</net>
<net name="ZCD_PULSE" class="0">
<segment>
<pinref part="OK1" gate="G$1" pin="COL"/>
<wire x1="-27.94" y1="76.2" x2="-20.32" y2="76.2" width="0.1524" layer="91"/>
<pinref part="R3" gate="G$1" pin="1"/>
<wire x1="-20.32" y1="76.2" x2="-10.16" y2="76.2" width="0.1524" layer="91"/>
<wire x1="-20.32" y1="81.28" x2="-20.32" y2="76.2" width="0.1524" layer="91"/>
<junction x="-20.32" y="76.2"/>
<label x="-10.16" y="76.2" size="1.778" layer="95"/>
</segment>
<segment>
<pinref part="U$1" gate="1" pin="8"/>
<wire x1="116.84" y1="66.04" x2="134.62" y2="66.04" width="0.1524" layer="91"/>
<wire x1="134.62" y1="66.04" x2="134.62" y2="60.96" width="0.1524" layer="91"/>
<wire x1="134.62" y1="60.96" x2="139.7" y2="60.96" width="0.1524" layer="91"/>
<label x="139.7" y="60.96" size="1.778" layer="95"/>
</segment>
</net>
<net name="PIR1_OUT" class="0">
<segment>
<pinref part="JP2" gate="A" pin="2"/>
<wire x1="20.32" y1="96.52" x2="20.32" y2="55.88" width="0.1524" layer="91"/>
<label x="20.32" y="55.88" size="1.778" layer="95"/>
</segment>
<segment>
<pinref part="U$1" gate="1" pin="3"/>
<wire x1="101.6" y1="71.12" x2="81.28" y2="71.12" width="0.1524" layer="91"/>
<label x="81.28" y="71.12" size="1.778" layer="95"/>
</segment>
</net>
<net name="PIR2_OUT" class="0">
<segment>
<pinref part="JP3" gate="A" pin="2"/>
<wire x1="38.1" y1="96.52" x2="38.1" y2="55.88" width="0.1524" layer="91"/>
<label x="38.1" y="55.88" size="1.778" layer="95"/>
</segment>
<segment>
<pinref part="U$1" gate="1" pin="5"/>
<wire x1="101.6" y1="68.58" x2="81.28" y2="68.58" width="0.1524" layer="91"/>
<label x="81.28" y="68.58" size="1.778" layer="95"/>
</segment>
</net>
<net name="N$6" class="0">
<segment>
<pinref part="OK2" gate="-1" pin="A2"/>
<pinref part="R5" gate="G$1" pin="1"/>
<wire x1="-45.72" y1="-15.24" x2="-40.64" y2="-15.24" width="0.1524" layer="91"/>
</segment>
</net>
<net name="N$7" class="0">
<segment>
<pinref part="J2" gate="G$1" pin="1"/>
<wire x1="-7.62" y1="-17.78" x2="-10.16" y2="-17.78" width="0.1524" layer="91"/>
<wire x1="-10.16" y1="-17.78" x2="-10.16" y2="-7.62" width="0.1524" layer="91"/>
<pinref part="T1" gate="-1" pin="A2"/>
<wire x1="-10.16" y1="-7.62" x2="-22.86" y2="-7.62" width="0.1524" layer="91"/>
<wire x1="-22.86" y1="-7.62" x2="-22.86" y2="-15.24" width="0.1524" layer="91"/>
<pinref part="R5" gate="G$1" pin="2"/>
<wire x1="-22.86" y1="-15.24" x2="-22.86" y2="-20.32" width="0.1524" layer="91"/>
<wire x1="-30.48" y1="-15.24" x2="-22.86" y2="-15.24" width="0.1524" layer="91"/>
<junction x="-22.86" y="-15.24"/>
</segment>
</net>
<net name="N$8" class="0">
<segment>
<pinref part="OK2" gate="-1" pin="A1"/>
<pinref part="T1" gate="-1" pin="G"/>
<wire x1="-45.72" y1="-25.4" x2="-27.94" y2="-25.4" width="0.1524" layer="91"/>
</segment>
</net>
<net name="N$9" class="0">
<segment>
<pinref part="T1" gate="-1" pin="A1"/>
<wire x1="-22.86" y1="-27.94" x2="-22.86" y2="-30.48" width="0.1524" layer="91"/>
<wire x1="-22.86" y1="-30.48" x2="-10.16" y2="-30.48" width="0.1524" layer="91"/>
<wire x1="-10.16" y1="-30.48" x2="-10.16" y2="-20.32" width="0.1524" layer="91"/>
<pinref part="J2" gate="G$1" pin="2"/>
<wire x1="-10.16" y1="-20.32" x2="-7.62" y2="-20.32" width="0.1524" layer="91"/>
</segment>
</net>
<net name="TR1" class="0">
<segment>
<pinref part="R4" gate="G$1" pin="2"/>
<wire x1="-81.28" y1="-25.4" x2="-86.36" y2="-25.4" width="0.1524" layer="91"/>
<label x="-86.36" y="-25.4" size="1.778" layer="95"/>
</segment>
<segment>
<pinref part="U$1" gate="1" pin="32"/>
<wire x1="116.84" y1="35.56" x2="132.08" y2="35.56" width="0.1524" layer="91"/>
<label x="132.08" y="35.56" size="1.778" layer="95"/>
</segment>
</net>
<net name="N$10" class="0">
<segment>
<pinref part="R4" gate="G$1" pin="1"/>
<pinref part="OK2" gate="-1" pin="C"/>
<wire x1="-71.12" y1="-25.4" x2="-66.04" y2="-25.4" width="0.1524" layer="91"/>
</segment>
</net>
<net name="VEE" class="0">
<segment>
<pinref part="SUPPLY5" gate="G$1" pin="VEE"/>
<wire x1="-73.66" y1="-10.16" x2="-73.66" y2="-15.24" width="0.1524" layer="91"/>
<pinref part="OK2" gate="-1" pin="A"/>
<wire x1="-73.66" y1="-15.24" x2="-66.04" y2="-15.24" width="0.1524" layer="91"/>
</segment>
<segment>
<pinref part="SUPPLY6" gate="G$1" pin="VEE"/>
<wire x1="99.06" y1="81.28" x2="99.06" y2="73.66" width="0.1524" layer="91"/>
<pinref part="U$1" gate="1" pin="1"/>
<wire x1="99.06" y1="73.66" x2="101.6" y2="73.66" width="0.1524" layer="91"/>
</segment>
<segment>
<pinref part="SUPPLY7" gate="G$1" pin="VEE"/>
<wire x1="-73.66" y1="-45.72" x2="-73.66" y2="-50.8" width="0.1524" layer="91"/>
<pinref part="OK3" gate="-1" pin="A"/>
<wire x1="-73.66" y1="-50.8" x2="-63.5" y2="-50.8" width="0.1524" layer="91"/>
</segment>
<segment>
<pinref part="SUPPLY8" gate="G$1" pin="VEE"/>
<wire x1="-73.66" y1="-81.28" x2="-73.66" y2="-86.36" width="0.1524" layer="91"/>
<pinref part="OK4" gate="-1" pin="A"/>
<wire x1="-73.66" y1="-86.36" x2="-66.04" y2="-86.36" width="0.1524" layer="91"/>
</segment>
<segment>
<pinref part="SUPPLY9" gate="G$1" pin="VEE"/>
<wire x1="-73.66" y1="-116.84" x2="-73.66" y2="-121.92" width="0.1524" layer="91"/>
<pinref part="OK5" gate="-1" pin="A"/>
<wire x1="-73.66" y1="-121.92" x2="-66.04" y2="-121.92" width="0.1524" layer="91"/>
</segment>
<segment>
<pinref part="SUPPLY10" gate="G$1" pin="VEE"/>
<wire x1="30.48" y1="-10.16" x2="30.48" y2="-15.24" width="0.1524" layer="91"/>
<pinref part="OK6" gate="-1" pin="A"/>
<wire x1="30.48" y1="-15.24" x2="38.1" y2="-15.24" width="0.1524" layer="91"/>
</segment>
<segment>
<pinref part="SUPPLY11" gate="G$1" pin="VEE"/>
<wire x1="30.48" y1="-45.72" x2="30.48" y2="-50.8" width="0.1524" layer="91"/>
<pinref part="OK7" gate="-1" pin="A"/>
<wire x1="30.48" y1="-50.8" x2="38.1" y2="-50.8" width="0.1524" layer="91"/>
</segment>
<segment>
<pinref part="SUPPLY12" gate="G$1" pin="VEE"/>
<wire x1="30.48" y1="-81.28" x2="30.48" y2="-86.36" width="0.1524" layer="91"/>
<pinref part="OK8" gate="-1" pin="A"/>
<wire x1="30.48" y1="-86.36" x2="38.1" y2="-86.36" width="0.1524" layer="91"/>
</segment>
<segment>
<pinref part="SUPPLY13" gate="G$1" pin="VEE"/>
<wire x1="30.48" y1="-116.84" x2="30.48" y2="-121.92" width="0.1524" layer="91"/>
<pinref part="OK9" gate="-1" pin="A"/>
<wire x1="30.48" y1="-121.92" x2="38.1" y2="-121.92" width="0.1524" layer="91"/>
</segment>
</net>
<net name="N$5" class="0">
<segment>
<pinref part="OK3" gate="-1" pin="A2"/>
<pinref part="R7" gate="G$1" pin="1"/>
<wire x1="-43.18" y1="-50.8" x2="-40.64" y2="-50.8" width="0.1524" layer="91"/>
</segment>
</net>
<net name="N$11" class="0">
<segment>
<pinref part="J3" gate="G$1" pin="1"/>
<wire x1="-7.62" y1="-53.34" x2="-10.16" y2="-53.34" width="0.1524" layer="91"/>
<wire x1="-10.16" y1="-53.34" x2="-10.16" y2="-43.18" width="0.1524" layer="91"/>
<pinref part="T2" gate="-1" pin="A2"/>
<wire x1="-10.16" y1="-43.18" x2="-22.86" y2="-43.18" width="0.1524" layer="91"/>
<wire x1="-22.86" y1="-43.18" x2="-22.86" y2="-50.8" width="0.1524" layer="91"/>
<pinref part="R7" gate="G$1" pin="2"/>
<wire x1="-22.86" y1="-50.8" x2="-22.86" y2="-55.88" width="0.1524" layer="91"/>
<wire x1="-30.48" y1="-50.8" x2="-22.86" y2="-50.8" width="0.1524" layer="91"/>
<junction x="-22.86" y="-50.8"/>
</segment>
</net>
<net name="N$12" class="0">
<segment>
<pinref part="OK3" gate="-1" pin="A1"/>
<pinref part="T2" gate="-1" pin="G"/>
<wire x1="-43.18" y1="-60.96" x2="-27.94" y2="-60.96" width="0.1524" layer="91"/>
</segment>
</net>
<net name="N$13" class="0">
<segment>
<pinref part="T2" gate="-1" pin="A1"/>
<wire x1="-22.86" y1="-63.5" x2="-22.86" y2="-66.04" width="0.1524" layer="91"/>
<wire x1="-22.86" y1="-66.04" x2="-10.16" y2="-66.04" width="0.1524" layer="91"/>
<wire x1="-10.16" y1="-66.04" x2="-10.16" y2="-55.88" width="0.1524" layer="91"/>
<pinref part="J3" gate="G$1" pin="2"/>
<wire x1="-10.16" y1="-55.88" x2="-7.62" y2="-55.88" width="0.1524" layer="91"/>
</segment>
</net>
<net name="N$14" class="0">
<segment>
<pinref part="R6" gate="G$1" pin="1"/>
<pinref part="OK3" gate="-1" pin="C"/>
<wire x1="-71.12" y1="-60.96" x2="-63.5" y2="-60.96" width="0.1524" layer="91"/>
</segment>
</net>
<net name="N$15" class="0">
<segment>
<pinref part="OK4" gate="-1" pin="A2"/>
<pinref part="R9" gate="G$1" pin="1"/>
<wire x1="-45.72" y1="-86.36" x2="-40.64" y2="-86.36" width="0.1524" layer="91"/>
</segment>
</net>
<net name="N$16" class="0">
<segment>
<pinref part="J4" gate="G$1" pin="1"/>
<wire x1="-7.62" y1="-88.9" x2="-10.16" y2="-88.9" width="0.1524" layer="91"/>
<wire x1="-10.16" y1="-88.9" x2="-10.16" y2="-78.74" width="0.1524" layer="91"/>
<pinref part="T3" gate="-1" pin="A2"/>
<wire x1="-10.16" y1="-78.74" x2="-22.86" y2="-78.74" width="0.1524" layer="91"/>
<wire x1="-22.86" y1="-78.74" x2="-22.86" y2="-86.36" width="0.1524" layer="91"/>
<pinref part="R9" gate="G$1" pin="2"/>
<wire x1="-22.86" y1="-86.36" x2="-22.86" y2="-91.44" width="0.1524" layer="91"/>
<wire x1="-30.48" y1="-86.36" x2="-22.86" y2="-86.36" width="0.1524" layer="91"/>
<junction x="-22.86" y="-86.36"/>
</segment>
</net>
<net name="N$17" class="0">
<segment>
<pinref part="OK4" gate="-1" pin="A1"/>
<pinref part="T3" gate="-1" pin="G"/>
<wire x1="-45.72" y1="-96.52" x2="-27.94" y2="-96.52" width="0.1524" layer="91"/>
</segment>
</net>
<net name="N$18" class="0">
<segment>
<pinref part="T3" gate="-1" pin="A1"/>
<wire x1="-22.86" y1="-99.06" x2="-22.86" y2="-101.6" width="0.1524" layer="91"/>
<wire x1="-22.86" y1="-101.6" x2="-10.16" y2="-101.6" width="0.1524" layer="91"/>
<wire x1="-10.16" y1="-101.6" x2="-10.16" y2="-91.44" width="0.1524" layer="91"/>
<pinref part="J4" gate="G$1" pin="2"/>
<wire x1="-10.16" y1="-91.44" x2="-7.62" y2="-91.44" width="0.1524" layer="91"/>
</segment>
</net>
<net name="N$19" class="0">
<segment>
<pinref part="R8" gate="G$1" pin="1"/>
<pinref part="OK4" gate="-1" pin="C"/>
<wire x1="-71.12" y1="-96.52" x2="-66.04" y2="-96.52" width="0.1524" layer="91"/>
</segment>
</net>
<net name="N$20" class="0">
<segment>
<pinref part="OK5" gate="-1" pin="A2"/>
<pinref part="R11" gate="G$1" pin="1"/>
<wire x1="-45.72" y1="-121.92" x2="-40.64" y2="-121.92" width="0.1524" layer="91"/>
</segment>
</net>
<net name="N$21" class="0">
<segment>
<pinref part="J5" gate="G$1" pin="1"/>
<wire x1="-7.62" y1="-124.46" x2="-10.16" y2="-124.46" width="0.1524" layer="91"/>
<wire x1="-10.16" y1="-124.46" x2="-10.16" y2="-114.3" width="0.1524" layer="91"/>
<pinref part="T4" gate="-1" pin="A2"/>
<wire x1="-10.16" y1="-114.3" x2="-22.86" y2="-114.3" width="0.1524" layer="91"/>
<wire x1="-22.86" y1="-114.3" x2="-22.86" y2="-121.92" width="0.1524" layer="91"/>
<pinref part="R11" gate="G$1" pin="2"/>
<wire x1="-22.86" y1="-121.92" x2="-22.86" y2="-127" width="0.1524" layer="91"/>
<wire x1="-30.48" y1="-121.92" x2="-22.86" y2="-121.92" width="0.1524" layer="91"/>
<junction x="-22.86" y="-121.92"/>
</segment>
</net>
<net name="N$22" class="0">
<segment>
<pinref part="OK5" gate="-1" pin="A1"/>
<pinref part="T4" gate="-1" pin="G"/>
<wire x1="-45.72" y1="-132.08" x2="-27.94" y2="-132.08" width="0.1524" layer="91"/>
</segment>
</net>
<net name="N$23" class="0">
<segment>
<pinref part="T4" gate="-1" pin="A1"/>
<wire x1="-22.86" y1="-134.62" x2="-22.86" y2="-137.16" width="0.1524" layer="91"/>
<wire x1="-22.86" y1="-137.16" x2="-10.16" y2="-137.16" width="0.1524" layer="91"/>
<wire x1="-10.16" y1="-137.16" x2="-10.16" y2="-127" width="0.1524" layer="91"/>
<pinref part="J5" gate="G$1" pin="2"/>
<wire x1="-10.16" y1="-127" x2="-7.62" y2="-127" width="0.1524" layer="91"/>
</segment>
</net>
<net name="N$24" class="0">
<segment>
<pinref part="R10" gate="G$1" pin="1"/>
<pinref part="OK5" gate="-1" pin="C"/>
<wire x1="-71.12" y1="-132.08" x2="-66.04" y2="-132.08" width="0.1524" layer="91"/>
</segment>
</net>
<net name="N$25" class="0">
<segment>
<pinref part="OK6" gate="-1" pin="A2"/>
<pinref part="R13" gate="G$1" pin="1"/>
<wire x1="58.42" y1="-15.24" x2="63.5" y2="-15.24" width="0.1524" layer="91"/>
</segment>
</net>
<net name="N$26" class="0">
<segment>
<pinref part="J6" gate="G$1" pin="1"/>
<wire x1="96.52" y1="-17.78" x2="93.98" y2="-17.78" width="0.1524" layer="91"/>
<wire x1="93.98" y1="-17.78" x2="93.98" y2="-7.62" width="0.1524" layer="91"/>
<pinref part="T5" gate="-1" pin="A2"/>
<wire x1="93.98" y1="-7.62" x2="81.28" y2="-7.62" width="0.1524" layer="91"/>
<wire x1="81.28" y1="-7.62" x2="81.28" y2="-15.24" width="0.1524" layer="91"/>
<pinref part="R13" gate="G$1" pin="2"/>
<wire x1="81.28" y1="-15.24" x2="81.28" y2="-20.32" width="0.1524" layer="91"/>
<wire x1="73.66" y1="-15.24" x2="81.28" y2="-15.24" width="0.1524" layer="91"/>
<junction x="81.28" y="-15.24"/>
</segment>
</net>
<net name="N$27" class="0">
<segment>
<pinref part="OK6" gate="-1" pin="A1"/>
<pinref part="T5" gate="-1" pin="G"/>
<wire x1="58.42" y1="-25.4" x2="76.2" y2="-25.4" width="0.1524" layer="91"/>
</segment>
</net>
<net name="N$28" class="0">
<segment>
<pinref part="T5" gate="-1" pin="A1"/>
<wire x1="81.28" y1="-27.94" x2="81.28" y2="-30.48" width="0.1524" layer="91"/>
<wire x1="81.28" y1="-30.48" x2="93.98" y2="-30.48" width="0.1524" layer="91"/>
<wire x1="93.98" y1="-30.48" x2="93.98" y2="-20.32" width="0.1524" layer="91"/>
<pinref part="J6" gate="G$1" pin="2"/>
<wire x1="93.98" y1="-20.32" x2="96.52" y2="-20.32" width="0.1524" layer="91"/>
</segment>
</net>
<net name="N$29" class="0">
<segment>
<pinref part="R12" gate="G$1" pin="1"/>
<pinref part="OK6" gate="-1" pin="C"/>
<wire x1="33.02" y1="-25.4" x2="38.1" y2="-25.4" width="0.1524" layer="91"/>
</segment>
</net>
<net name="N$30" class="0">
<segment>
<pinref part="OK7" gate="-1" pin="A2"/>
<pinref part="R15" gate="G$1" pin="1"/>
<wire x1="58.42" y1="-50.8" x2="63.5" y2="-50.8" width="0.1524" layer="91"/>
</segment>
</net>
<net name="N$31" class="0">
<segment>
<pinref part="J7" gate="G$1" pin="1"/>
<wire x1="96.52" y1="-53.34" x2="93.98" y2="-53.34" width="0.1524" layer="91"/>
<wire x1="93.98" y1="-53.34" x2="93.98" y2="-43.18" width="0.1524" layer="91"/>
<pinref part="T6" gate="-1" pin="A2"/>
<wire x1="93.98" y1="-43.18" x2="81.28" y2="-43.18" width="0.1524" layer="91"/>
<wire x1="81.28" y1="-43.18" x2="81.28" y2="-50.8" width="0.1524" layer="91"/>
<pinref part="R15" gate="G$1" pin="2"/>
<wire x1="81.28" y1="-50.8" x2="81.28" y2="-55.88" width="0.1524" layer="91"/>
<wire x1="73.66" y1="-50.8" x2="81.28" y2="-50.8" width="0.1524" layer="91"/>
<junction x="81.28" y="-50.8"/>
</segment>
</net>
<net name="N$32" class="0">
<segment>
<pinref part="OK7" gate="-1" pin="A1"/>
<pinref part="T6" gate="-1" pin="G"/>
<wire x1="58.42" y1="-60.96" x2="76.2" y2="-60.96" width="0.1524" layer="91"/>
</segment>
</net>
<net name="N$33" class="0">
<segment>
<pinref part="T6" gate="-1" pin="A1"/>
<wire x1="81.28" y1="-63.5" x2="81.28" y2="-66.04" width="0.1524" layer="91"/>
<wire x1="81.28" y1="-66.04" x2="93.98" y2="-66.04" width="0.1524" layer="91"/>
<wire x1="93.98" y1="-66.04" x2="93.98" y2="-55.88" width="0.1524" layer="91"/>
<pinref part="J7" gate="G$1" pin="2"/>
<wire x1="93.98" y1="-55.88" x2="96.52" y2="-55.88" width="0.1524" layer="91"/>
</segment>
</net>
<net name="N$34" class="0">
<segment>
<pinref part="R14" gate="G$1" pin="1"/>
<pinref part="OK7" gate="-1" pin="C"/>
<wire x1="33.02" y1="-60.96" x2="38.1" y2="-60.96" width="0.1524" layer="91"/>
</segment>
</net>
<net name="N$35" class="0">
<segment>
<pinref part="OK8" gate="-1" pin="A2"/>
<pinref part="R17" gate="G$1" pin="1"/>
<wire x1="58.42" y1="-86.36" x2="63.5" y2="-86.36" width="0.1524" layer="91"/>
</segment>
</net>
<net name="N$36" class="0">
<segment>
<pinref part="J8" gate="G$1" pin="1"/>
<wire x1="96.52" y1="-88.9" x2="93.98" y2="-88.9" width="0.1524" layer="91"/>
<wire x1="93.98" y1="-88.9" x2="93.98" y2="-78.74" width="0.1524" layer="91"/>
<pinref part="T7" gate="-1" pin="A2"/>
<wire x1="93.98" y1="-78.74" x2="81.28" y2="-78.74" width="0.1524" layer="91"/>
<wire x1="81.28" y1="-78.74" x2="81.28" y2="-86.36" width="0.1524" layer="91"/>
<pinref part="R17" gate="G$1" pin="2"/>
<wire x1="81.28" y1="-86.36" x2="81.28" y2="-91.44" width="0.1524" layer="91"/>
<wire x1="73.66" y1="-86.36" x2="81.28" y2="-86.36" width="0.1524" layer="91"/>
<junction x="81.28" y="-86.36"/>
</segment>
</net>
<net name="N$37" class="0">
<segment>
<pinref part="OK8" gate="-1" pin="A1"/>
<pinref part="T7" gate="-1" pin="G"/>
<wire x1="58.42" y1="-96.52" x2="76.2" y2="-96.52" width="0.1524" layer="91"/>
</segment>
</net>
<net name="N$38" class="0">
<segment>
<pinref part="T7" gate="-1" pin="A1"/>
<wire x1="81.28" y1="-99.06" x2="81.28" y2="-101.6" width="0.1524" layer="91"/>
<wire x1="81.28" y1="-101.6" x2="93.98" y2="-101.6" width="0.1524" layer="91"/>
<wire x1="93.98" y1="-101.6" x2="93.98" y2="-91.44" width="0.1524" layer="91"/>
<pinref part="J8" gate="G$1" pin="2"/>
<wire x1="93.98" y1="-91.44" x2="96.52" y2="-91.44" width="0.1524" layer="91"/>
</segment>
</net>
<net name="N$39" class="0">
<segment>
<pinref part="R16" gate="G$1" pin="1"/>
<pinref part="OK8" gate="-1" pin="C"/>
<wire x1="33.02" y1="-96.52" x2="38.1" y2="-96.52" width="0.1524" layer="91"/>
</segment>
</net>
<net name="N$40" class="0">
<segment>
<pinref part="OK9" gate="-1" pin="A2"/>
<pinref part="R19" gate="G$1" pin="1"/>
<wire x1="58.42" y1="-121.92" x2="63.5" y2="-121.92" width="0.1524" layer="91"/>
</segment>
</net>
<net name="N$41" class="0">
<segment>
<pinref part="J9" gate="G$1" pin="1"/>
<wire x1="96.52" y1="-124.46" x2="93.98" y2="-124.46" width="0.1524" layer="91"/>
<wire x1="93.98" y1="-124.46" x2="93.98" y2="-114.3" width="0.1524" layer="91"/>
<pinref part="T8" gate="-1" pin="A2"/>
<wire x1="93.98" y1="-114.3" x2="81.28" y2="-114.3" width="0.1524" layer="91"/>
<wire x1="81.28" y1="-114.3" x2="81.28" y2="-121.92" width="0.1524" layer="91"/>
<pinref part="R19" gate="G$1" pin="2"/>
<wire x1="81.28" y1="-121.92" x2="81.28" y2="-127" width="0.1524" layer="91"/>
<wire x1="73.66" y1="-121.92" x2="81.28" y2="-121.92" width="0.1524" layer="91"/>
<junction x="81.28" y="-121.92"/>
</segment>
</net>
<net name="N$42" class="0">
<segment>
<pinref part="OK9" gate="-1" pin="A1"/>
<pinref part="T8" gate="-1" pin="G"/>
<wire x1="58.42" y1="-132.08" x2="76.2" y2="-132.08" width="0.1524" layer="91"/>
</segment>
</net>
<net name="N$43" class="0">
<segment>
<pinref part="T8" gate="-1" pin="A1"/>
<wire x1="81.28" y1="-134.62" x2="81.28" y2="-137.16" width="0.1524" layer="91"/>
<wire x1="81.28" y1="-137.16" x2="93.98" y2="-137.16" width="0.1524" layer="91"/>
<wire x1="93.98" y1="-137.16" x2="93.98" y2="-127" width="0.1524" layer="91"/>
<pinref part="J9" gate="G$1" pin="2"/>
<wire x1="93.98" y1="-127" x2="96.52" y2="-127" width="0.1524" layer="91"/>
</segment>
</net>
<net name="N$44" class="0">
<segment>
<pinref part="R18" gate="G$1" pin="1"/>
<pinref part="OK9" gate="-1" pin="C"/>
<wire x1="33.02" y1="-132.08" x2="38.1" y2="-132.08" width="0.1524" layer="91"/>
</segment>
</net>
<net name="TR2" class="0">
<segment>
<pinref part="R6" gate="G$1" pin="2"/>
<wire x1="-81.28" y1="-60.96" x2="-86.36" y2="-60.96" width="0.1524" layer="91"/>
<label x="-86.36" y="-60.96" size="1.778" layer="95"/>
</segment>
<segment>
<pinref part="U$1" gate="1" pin="36"/>
<wire x1="116.84" y1="30.48" x2="132.08" y2="30.48" width="0.1524" layer="91"/>
<label x="132.08" y="30.48" size="1.778" layer="95"/>
</segment>
</net>
<net name="TR3" class="0">
<segment>
<pinref part="R8" gate="G$1" pin="2"/>
<wire x1="-81.28" y1="-96.52" x2="-86.36" y2="-96.52" width="0.1524" layer="91"/>
<label x="-86.36" y="-96.52" size="1.778" layer="95"/>
</segment>
<segment>
<pinref part="U$1" gate="1" pin="38"/>
<wire x1="116.84" y1="27.94" x2="132.08" y2="27.94" width="0.1524" layer="91"/>
<label x="132.08" y="27.94" size="1.778" layer="95"/>
</segment>
</net>
<net name="TR4" class="0">
<segment>
<pinref part="R10" gate="G$1" pin="2"/>
<wire x1="-81.28" y1="-132.08" x2="-86.36" y2="-132.08" width="0.1524" layer="91"/>
<label x="-86.36" y="-132.08" size="1.778" layer="95"/>
</segment>
<segment>
<pinref part="U$1" gate="1" pin="40"/>
<wire x1="116.84" y1="25.4" x2="132.08" y2="25.4" width="0.1524" layer="91"/>
<label x="132.08" y="25.4" size="1.778" layer="95"/>
</segment>
</net>
<net name="TR5" class="0">
<segment>
<pinref part="R12" gate="G$1" pin="2"/>
<wire x1="22.86" y1="-25.4" x2="17.78" y2="-25.4" width="0.1524" layer="91"/>
<label x="17.78" y="-25.4" size="1.778" layer="95"/>
</segment>
<segment>
<pinref part="U$1" gate="1" pin="37"/>
<wire x1="101.6" y1="27.94" x2="86.36" y2="27.94" width="0.1524" layer="91"/>
<label x="86.36" y="27.94" size="1.778" layer="95"/>
</segment>
</net>
<net name="TR6" class="0">
<segment>
<pinref part="R14" gate="G$1" pin="2"/>
<wire x1="22.86" y1="-60.96" x2="17.78" y2="-60.96" width="0.1524" layer="91"/>
<label x="17.78" y="-60.96" size="1.778" layer="95"/>
</segment>
<segment>
<pinref part="U$1" gate="1" pin="35"/>
<wire x1="101.6" y1="30.48" x2="86.36" y2="30.48" width="0.1524" layer="91"/>
<label x="86.36" y="30.48" size="1.778" layer="95"/>
</segment>
</net>
<net name="TR7" class="0">
<segment>
<pinref part="R16" gate="G$1" pin="2"/>
<wire x1="22.86" y1="-96.52" x2="17.78" y2="-96.52" width="0.1524" layer="91"/>
<label x="17.78" y="-96.52" size="1.778" layer="95"/>
</segment>
<segment>
<pinref part="U$1" gate="1" pin="33"/>
<wire x1="101.6" y1="33.02" x2="86.36" y2="33.02" width="0.1524" layer="91"/>
<label x="86.36" y="33.02" size="1.778" layer="95"/>
</segment>
</net>
<net name="TR8" class="0">
<segment>
<pinref part="R18" gate="G$1" pin="2"/>
<wire x1="22.86" y1="-132.08" x2="17.78" y2="-132.08" width="0.1524" layer="91"/>
<label x="17.78" y="-132.08" size="1.778" layer="95"/>
</segment>
<segment>
<pinref part="U$1" gate="1" pin="31"/>
<wire x1="101.6" y1="35.56" x2="86.36" y2="35.56" width="0.1524" layer="91"/>
<label x="86.36" y="35.56" size="1.778" layer="95"/>
</segment>
</net>
</nets>
</sheet>
</sheets>
</schematic>
</drawing>
</eagle>
