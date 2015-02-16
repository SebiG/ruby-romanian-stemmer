# encoding: utf-8
class Stemmer
  ###########################################################################
  #step 0
  def step0(r1, c)
    r10 = r1.sub(/(ului|ul)\b/,"").sub(/(iilor|iile|ilor|iua|iei|ii)\b/,"i").sub(/(elor|ele|ea|ei)\b/,"e").sub(/(atia|atie)\b/,"ati").sub("atei","at").sub("aua","a")
    if r10.include?("ile") and not c.include?("abile") then
      r10 = r10.sub("ile","i")
    end
    r10
  end
  ############################################################################
  #step 1
  def step1(r11, r11lgt)
    gata = false
    ss = 0
    while gata == false
      ss = ss + 1
      # puts "loop nr. " + ss.to_s
      if ss == 50 then
        p ss
        gata = true
      end
      case r11lgt
      when 8..16
        if r11.include?("bilita") then
          r11a = r11.sub(/abilitate|abilitati|abilitai/,"abil").sub("ibilitate","ibil")
          if r11 == r11a then #verifica daca s-au facut schimbari
            r11lgt = 7
          else
            r11 = r11a
            r11lgt = r11.length
          end #if
        else
          r11lgt = 7
        end #if
      when 7
        if r11.include?("itat") then
          r11a = r11.sub(/ivitate|ivitati/,"iv").sub(/icitate|icitati/,"ic")
          if r11a == r11 then
            r11lgt = 6
          else
            r11 = r11a
            r11lgt = r11.length
          end #if
        elsif r11.include?("icatori") then
          r11 = r11.sub("icatori","ic")
          r11lgt = r11.length
        else
          r11lgt = 6
        end #if
      when 6
        if r11.include?("it") then
          r11a = r11.sub("ivitai","iv").sub("icitai","ic").sub(/itiune|itoare/,"it")
          if r11a == r11 then
            r11lgt = 5
          else
            r11 = r11a
            r11lgt = r11.length
          end #if
        elsif r11.include?("at") then
          r11a = r11.sub("icator","ic").sub(/atiune|atoare/,"at")
          if r11a == r11 then
            r11lgt = 5
          else
            r11 = r11a
            r11lgt = r11.length
          end #if
        else
          r11lgt = 5
        end #if
      when 5
        if r11.include?("at") then
          r11a = r11.sub(/ative|ativi|atori/,"at")
          if r11a == r11 then
            r11lgt = 4
          else
            r11 = r11a
            r11lgt = r11.length
          end #if
        elsif r11.include?("ic") then
          r11a = r11.sub(/icala|icale|icali|iciva|icive|icivi/,"ic")
          if r11a == r11 then
            r11lgt = 4
          else
            r11 = r11a
            r11lgt = r11.length
          end #if
        elsif r11.include?("it") then
          r11a = r11.sub(/itiva|itive|itivi|itori/,"it")
          if r11a == r11 then
            r11lgt = 4
          else
            r11 = r11a
            r11lgt = r11.length
          end #if
        else
          r11lgt = 4
        end #if
      when 4
        r11a = r11.sub(/ativ|ator/,"at").sub(/ical|iciv/,"ic").sub(/itiv|itor/,"it")
        if r11a == r11 then
          gata = true
        else
          r11 = r11a
          r11lgt = r11.length
        end #if
      else
        gata = true
      end #case
    end #while
    r11
  end #def step1
  ##########################################################################
  #step 2
  #calculez R2 (aici - pentru a prinde schimbarile)
  def step2(r2,c)
    r22 = r2.gsub(/(abila|abile|abili|atori|ibila|ibile|ibili|itate|itati|abil|anta|ante|anti|ator|ibil|itai|oasa|oase|ant|ata|ate|atu|ati|ice|ici|ita|ite|iti|iva|ive|ivi|osi|uta|ute|uti|at|ic|it|iv|os|ut)\b/,"")
    r22 = r22.gsub(/isme|ista|iste|isti|ism/,"ist")
    if c.include?("tiun") then
      r22 = r22.gsub(/iune|iuni/,"")
    end

    if not c.include?("itica") and not c.include?("rica")
    r22 = r22.sub("ica", "")
    end
    r22
  end
  def calculezAR2(r11,c)
    cursor = r11.index(/[aeiou](?=[bcdfghjklmnpqrstvxywzUI])/) #prima consoana precedata de vocala
    if cursor then
      r2 = r11[cursor+2..-1] || "" #dupa pana la sfarsit
      cr2 = r11[0..cursor+1]
      ar2 = [cr2,r2]
    else
      r2 = ""
      ar2 = [r11,r2]
    end
  end #calculezAR2
  #######################################################################
  #step 3
  #doar daca 1 si 2 nu au facut modificari sterge sufixul verbelor din RV
  def step3(rv)
    rv3 = rv.gsub(/([bcdfghjklmnpqrstvxywzUIu])(aserati|iserati|userati|aseram|iseram|useram|arati|asera|asesi|easca|irati|isera|isesi|urati|usera|usesi|andu|aram|asem|aste|asti|eati|eaza|este|esti|iati|indu|iram|isem|uram|usem|and|ara|are|asc|ase|asi|eai|eam|eau|ere|esc|eze|ezi|iai|iam|iau|ind|ira|ire|ise|isi|uar|ura|use|usi|ai|am|au|ea|ez|ia|ui)\b/) {|x| x[0]}
    rv3 = rv3.gsub(/(seserati|seseram|serati|sesera|sesesi|seram|sesem|sera|sese|sesi|ati|eti|iti|sei|am|em|im|se)\b/,"")
  end #step3
  ###########################################################################
  #step 4
  #sterg vocala finala din R1
  def step4(r13)
    r14 = r13.sub(/(ie|[iae]?i|[iae]?a|[iae]?e)\b/, "")
    r14 = r14.sub(/([cltx]u|neo)\b/) {|x| x[0]}
  end

  ###############################
  def calculezARV(cv)
    #calculez RV
    if "aeiou".include?cv[1] then
      if "aeiou".include?cv[0] then #vocala-vocala
        #regiunea dupa urmatoarea consoana
        crv = (/^.[aeiou]+[^aeiou]/.match(cv) || [""])[0]
        rv = cv.sub(crv, "")
      else #consoana-vocala
        #regiunea dupa a treia litera
        rv = cv[3..-1] || cv
        crv = cv[0..2]
      end
    else #a doua litera consoana
      crv = (/(^.[^aeiou]+[aeiou])/.match(cv) || [""])[0]
      rv = cv.sub(crv,"") #regiunea dupa urmatoarea vocala
    end

    if rv == cv then
      rv = ""
      arv = [crv, rv]
    else
      arv = [crv, rv]
    end if rv
  end
  ##################################
  def r1(c, cursor)
    c[cursor+2..-1] || ""
  end
  ##################################


  def extrageStemm(cursor, c)
    r1 = r1(c, cursor)
    cr1 = c[0..cursor+1]

    if r1.length > 1 then
      #step0
      r10 = step0(r1, c)
      r10lgt = r10.length

      #step1
      if r10lgt < 4 then
        r11 = r10
      else
        r11 = step1(r10, r10lgt)
      end

      #step2
      if r11 and r11.length > 2 then
        ar2 = calculezAR2(r11,c)
        r22 = step2(ar2[1],c)
        r12 = ar2[0] + r22
      elsif r11 then
        r12 = r11
      else
        r12 = r10
      end #if r11 and >2

      c2 = cr1 + r12
      #####
    end #pas 0 si pas 1,2 doar daca r1 nu este nil si r1 mai mare ca 1

    #daca nu au facut modificari
    #ruleaza doar daca R1 > 1
    #step3

    if r1.length > 1 then #daca pas0 1 si 2 nu au procesat
      if r10 and r12 and r10 == r12
        c0 = cr1 + r10
        if c0.length > 2 then
          arv = calculezARV(c0)
            if arv[1] != '' and arv[1].length > 1 then
              rv3 = step3(arv[1])
              c3 = arv[0] + rv3
            else
              c3 = c0
            end
        else
          c3 = c0
        end
      else
        c3 = c2
      end
    else
      if c.length > 2 then
        arv = calculezARV(c)
        if arv[1] != '' and arv[1].length > 1 then
          rv3 = step3(arv[1])
          c3 = arv[0] + rv3
        else
          c3 = c
        end
      else
        c3 = c
      end
    end

    #step4
    if c3 then
      r13 = r1(c3, cursor) #calculez R1
      stemm = cr1 + step4(r13)
      #recalculeaza r1 din c3
    elsif c2 then
      r13 = r1(c2, cursor) #calculez R1
      step4(r13)
      #recalculeaa r1 din c2
    else
      r13 = r1(c, cursor) #calculez R1
      step4(r13)
      #recalculeaza din r1 din c
    end

    ####
  end #extrageStemm


  #START
  def obtinestemm(cuvantPregatit)
    #daca cuvantul pregatit are minim 4 litere obtine stemm
    if cuvantPregatit.length < 4 then
      stemm = cuvantPregatit
    else
      # i si u dintre vocale devind "consoane", UPPERCASE
      c = cuvantPregatit.sub(/[aeoiu][ui]([aeoui])[aeiou]?/) {|s| if not s[3] then s[0] + s[1].upcase + s[2] elsif s[2] == "i" then s[0] + s[1].upcase + s[2].upcase + s[3] else s[0] + s[1].upcase + s[2] + s[3] end }
      # nu e perfect, inlocuieste doar prima gasire
      cursor = c.index(/[aeiou](?=[bcdfghjklmnpqrstvxywzUI])/)
      #calculez R1 si C1 #dupa prima consoana care are o vocala in fata
      #prima vocala urmata de consoana
      if cursor then
        ciese = extrageStemm(cursor, c)
        stemm = ciese.tr("UI", "ui")
      else
        stemm = cuvantPregatit
      end
    end
    # puts "Radacina cuvantului este: " + stemm
  end
end

c1 = 'amplificandele'
@c = Stemmer.new
p ccc = @c.obtinestemm(c1)


def stimKey(c1)
  @h[c1].each do |clem|
    clem = clem.sub(/[\.\']/, "")
    p @c.obtinestemm(clem) + "  " + clem
  end
end

nr = 1
xnr = 0
require 'json'
x = File.read('lemmaRo.json')
@lema = JSON.parse(x)
stop = 1

@lema.each do |lx,aflx|
  lxs = @c.obtinestemm(lx)
  # lxs = @c.step4(lx).sub(/at\b/,"")
    stop = stop + 1
  aflx.each do |flx|
    flxs = @c.obtinestemm(flx.sub(/^nemai/,""))
    # flxs = @c.obtinestemm(flxs) #a doua oara
    # flxs = @c.obtinestemm(flxs) if not flx[/ic/]
    xnr = xnr +1
    if flxs != lxs
      nr = nr + 1
      p "********"
      p flxs + " - forma f"
      p lxs
      p "----"
      p flx + " - forma f"
      p lx
    end

  end

    if stop == 1100
      puts "cuvinte procesate:"
      p xnr
      puts "cuvinte care nu se potrivesc:"
      p nr
      puts "cuvinte care se potrivesc:"
      p xnr - nr
      break
    end

end
