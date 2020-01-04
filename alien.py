import re
import pandas as pd

def find_between(s, start, end):
  return (s.split(start))[1].split(end)[0]

def get_name(s):
    return find_between(s,":",":")

def get_expansion(s):
    expansion = find_between(s, ", ", ",")
    if(expansion == "base set"):
        return "Base Game"
    return expansion

def find_color(s):
    if("(Red)" in s):
        return "Red"
    if("(Yellow)" in s):
        return "Yellow"
    if("(Green)" in s):
        return "Green"
    return "UNKNOWN COLOR"

def find_small_desc(s):
    return s.split("]",1)[1]

def get_game_setup(s):
    return s.split("Game Setup: ",1)[1]

def get_player(a):
    return a[0]

def get_mandatory(a):
    if(a[1] == "Mandatory"):
        return True
    return False

def get_phases(a):
    return a[2:]

def get_card_bottom(s):
    attributes = re.findall('\[[^\]]*\]|\([^\)]*\)|\"[^\"]*\"|\S+',s)
    i = 0
    for attribute in attributes:
        a = attribute.replace('(', '')
        a = a.replace(')', '')
        attributes[i] = a
        i+=1
    return attributes
    
def get_design_notes(s):
    return

def get_retooled_gameplay(s):
    if(s.startswith("Retooled gameplay:")):
        return s.split("Retooled gameplay: ",1)[1]
    return

def get_edits(s):
    if(s.startswith("Edited")):
        return s
    return

def get_tips(s):
    if(s.startswith("Tip:")):
        return s.split("Tip: ",1)[1]
    return

# def get_clean_alien():
#     a = {
#         "name": "",
#         "expansion": "",
#         "color": "",
#         "short_desc": "",
#         "description": "",
#         "game_setup": "",
#         "player": "",
#         "mandatory": False,
#         "phases": [],
#         "lore": "",
#         "wild":{
#             "description": "",
#             "player": "",
#             "phase": ""
#         },
#         "super":{
#             "description": "",
#             "player": "",
#             "phase": ""
#         }
#     }
#     return a

file = open("alien.txt")

flare = False
wild = True
classic = False

rules = False

lore = False

# if you don't want to do .strip() again, just create a list of the stripped 
# lines first.
lines = [line.strip() for line in file if line.strip()]

# print(lines)
data = []
alien = {}
count = 1

for line in lines:
    if(line[0] == ':'):
        flare = False
        alien["name"] = get_name(line)
        alien["expansion"] = get_expansion(line)
    elif(get_retooled_gameplay(line)):
        alien["retooled_gameplay"] = get_retooled_gameplay(line)
    elif(get_edits(line)):
        alien["edits"] = get_edits(line)
    elif(get_tips(line)):
        if("tips" in alien):
            alien["tips"].append(get_tips(line))
        else:
            alien["tips"] = [get_tips(line)]
    elif("Game Setup:" in line):
        alien["game_setup"] = get_game_setup(line)
    elif(line[0] == '[' and line[1] == 'q'):
        alien["color"] = find_color(line)
        alien["short_desc"] = find_small_desc(line)
    elif(line[0] == '('):
        rules = False
        if(not flare):
            bottom = get_card_bottom(line)
            alien["player"] = get_player(bottom)
            alien["mandatory"] = get_mandatory(bottom)
            alien["phases"] = get_phases(bottom)
            lore = True
        else:
            bottom = get_card_bottom(line)
            if(classic):
                if(wild):
                    alien["classic_flare"]["wild"]["player"] = bottom[0]
                    alien["classic_flare"]["wild"]["phase"] = bottom[1]
                else:
                    alien["classic_flare"]["super_flare"]["player"] = bottom[0]
                    alien["classic_flare"]["super_flare"]["phase"] = bottom[1]
            else:
                if(wild):
                    alien["wild"]["player"] = bottom[0]
                    alien["wild"]["phase"] = bottom[1]
                else:
                    alien["super_flare"]["player"] = bottom[0]
                    alien["super_flare"]["phase"] = bottom[1]
    elif(lore):
        alien["lore"] = line
        lore = False
    elif(line.startswith("Classic Edition")):
        classic = True
        alien["classic_flare"] = {}
    elif(line.startswith("Wild: ")):
        wild = True
        flare = True
        if(classic):
            alien["classic_flare"]["wild"] = {}
            alien["classic_flare"]["wild"]["description"] = line.split("Wild: ",1)[1]
        else:
            alien["wild"] = {}
            alien["wild"]["description"] = line.split("Wild: ",1)[1]
    elif(line.startswith("Super: ")):
        wild = False
        flare = True
        if(classic):
            alien["classic_flare"]["super_flare"] = {}
            alien["classic_flare"]["super_flare"]["description"] = line.split("Super: ",1)[1]
        else:
            alien["super_flare"] = {}
            alien["super_flare"]["description"] = line.split("Super: ",1)[1]
    elif("You have the power" in line or rules):
        if("description" in alien):
            alien["description"] = alien["description"] + "\n" + line
        else:
            alien["description"] = line
        rules = True
    elif("[/q]" in line):
        alien["imageurl"] = "https://vignette.wikia.nocookie.net/cosmicencounter/images/b/b9/Clone_%28FFG%29.jpg/revision/latest?cb="+str(count)
        data.append(alien)
        classic = False
        alien = {}
        count+=1

df = pd.DataFrame(data)

print(df)

df.to_json('aliens.json', orient='records')