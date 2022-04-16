
import sys
import random
from bs4 import BeautifulSoup 


def parse(raw_html, query):
    """
    parse
    """
    
    soup = BeautifulSoup(raw_html, "html.parser")
    els = soup.select(query)
    
    return els
    
    
def load_file(abs_file_name):
    """
    load
    """
    
    with open(abs_file_name, "r", encoding='utf-8') as f:
        raw_html= f.read()
        
    return raw_html

    
def main(args):
    """
    main
    """
    term_list = []
    raw_html = load_file(args[1])
    divs = parse(raw_html, "tbody.luna-table__body div")
    
    idx = 0
    for div in divs:
        if((idx % 2) == 0):
            #print(div.text)
            term_list.append(div.text)
        idx += 1
    
    rtn_idx = random.randrange(0, len(term_list), 2) 
    print(term_list[rtn_idx])

if __name__ == '__main__':    
    main(sys.argv)
    
