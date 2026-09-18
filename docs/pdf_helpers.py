import os
import pymupdf

# Colors matching the filled sample style:
C_WHITE = (1.0, 1.0, 1.0)
C_DARK = (0.15, 0.15, 0.18)
C_GRAY = (0.45, 0.45, 0.48)
C_LIGHT_GRAY = (0.88, 0.88, 0.90)
C_CREAM = (1.0, 0.976, 0.933)       # #FFF9EE warm card fill
C_GOLD = (0.95, 0.62, 0.18)        # #F39C12 primary accent
C_GOLD_LIGHT = (0.99, 0.88, 0.72)  # #FDE4B8 light gold accent
C_GOLD_DARK = (0.82, 0.48, 0.08)   # #D35400 dark accent
C_GREEN = (0.15, 0.58, 0.30)       # #27AE60 pass green
C_BORDER = (0.90, 0.85, 0.78)      # subtle border

SNAPS_DIR = r"E:\funobotz\game\docs\snaps"
OUTPUT_PDF = r"E:\funobotz\game\docs\FUNOBOTZ_THE_LOST_CORE_PHASE_2.pdf"

def get_snap(filename):
    return os.path.join(SNAPS_DIR, filename)

def init_doc():
    return pymupdf.open()

def add_page(doc):
    return doc.new_page(width=612.0, height=792.0)

def draw_header_footer(page, page_num, total_pages=11):
    # Top accent bar
    page.draw_rect(pymupdf.Rect(45, 26, 567, 28), fill=C_GOLD)
    # Header labels
    page.insert_text(pymupdf.Point(45, 40), "TEAM PHASE 2 DESIGN DOCUMENT", fontsize=8.5, fontname="helv", color=C_GOLD_DARK)
    page.insert_text(pymupdf.Point(405, 40), "FUNOBOTZ  |  DISCOVERY WORLD", fontsize=8.5, fontname="helv", color=C_DARK)
    
    # Bottom separator
    page.draw_rect(pymupdf.Rect(45, 755, 567, 756), fill=C_BORDER)
    # Footer labels
    page.insert_text(pymupdf.Point(45, 768), "FUNOBOTZ: THE LOST CORE  •  Phase 2 Mission Challenge Submission", fontsize=8, fontname="helv", color=C_GRAY)
    page.insert_text(pymupdf.Point(515, 768), f"Page {page_num} of {total_pages}", fontsize=8, fontname="helv", color=C_GRAY)

def draw_section_title(page, y, title, subtitle=None):
    page.draw_rect(pymupdf.Rect(45, y, 48, y + 16), fill=C_GOLD)
    page.insert_text(pymupdf.Point(54, y + 13), title, fontsize=12.5, fontname="helv", color=C_DARK)
    if subtitle:
        page.insert_text(pymupdf.Point(45, y + 26), subtitle, fontsize=8.2, fontname="helv", color=C_GRAY)
        return y + 36
    return y + 24

def draw_card(page, rect, bg_color=C_CREAM, border_color=C_BORDER, gold_accent_left=False):
    page.draw_rect(rect, fill=bg_color, color=border_color, width=0.75)
    if gold_accent_left:
        page.draw_rect(pymupdf.Rect(rect.x0, rect.y0, rect.x0 + 3.5, rect.y1), fill=C_GOLD)

def draw_table(page, top_left_point, col_widths, headers, rows, row_height=18, header_height=19):
    x_start, y_start = top_left_point.x, top_left_point.y
    total_width = sum(col_widths)
    
    # Header row
    page.draw_rect(pymupdf.Rect(x_start, y_start, x_start + total_width, y_start + header_height), fill=C_GOLD_LIGHT, color=C_BORDER, width=0.75)
    cur_x = x_start
    for i, h in enumerate(headers):
        tb_rect = pymupdf.Rect(cur_x + 4, y_start + 2, cur_x + col_widths[i] - 4, y_start + header_height - 1)
        page.insert_textbox(tb_rect, h, fontsize=8.0, fontname="helv", color=C_DARK, align=pymupdf.TEXT_ALIGN_LEFT)
        cur_x += col_widths[i]
    
    cur_y = y_start + header_height
    for r_idx, r in enumerate(rows):
        bg = C_CREAM if r_idx % 2 == 1 else C_WHITE
        page.draw_rect(pymupdf.Rect(x_start, cur_y, x_start + total_width, cur_y + row_height), fill=bg, color=C_BORDER, width=0.5)
        cur_x = x_start
        for c_idx, val in enumerate(r):
            txt_color = C_DARK
            s_val = str(val)
            if s_val in ["PASS", "CLEAR", "5/5", "4/4", "3/3", "2/2", "20/20", "EXCEEDED"]:
                txt_color = C_GREEN
            elif s_val in ["LIVE", "READY", "READY / USED", "VERIFIED", "COMPLETE"]:
                txt_color = C_GOLD_DARK
            
            tb_rect = pymupdf.Rect(cur_x + 3, cur_y + 0.8, cur_x + col_widths[c_idx] - 3, cur_y + row_height - 0.5)
            # Try progressively smaller font sizes to ensure zero textbox overflow/omission
            for fs in [7.8, 7.2, 6.8, 6.4, 6.0, 5.5, 5.0]:
                rc = page.insert_textbox(tb_rect, s_val, fontsize=fs, fontname="helv", color=txt_color, align=pymupdf.TEXT_ALIGN_LEFT)
                if rc >= 0:
                    break
            cur_x += col_widths[c_idx]
        cur_y += row_height
    return cur_y

def draw_image_frame(page, rect, img_path, label, caption):
    # Outer frame
    page.draw_rect(rect, fill=C_WHITE, color=C_BORDER, width=0.75)
    # Header tag for image
    tag_h = 16
    page.draw_rect(pymupdf.Rect(rect.x0, rect.y0, rect.x1, rect.y0 + tag_h), fill=C_GOLD_LIGHT)
    page.insert_text(pymupdf.Point(rect.x0 + 6, rect.y0 + 11.5), label, fontsize=8.0, fontname="helv", color=C_GOLD_DARK)
    
    # Image area
    caption_h = 26
    img_rect = pymupdf.Rect(rect.x0 + 2, rect.y0 + tag_h + 2, rect.x1 - 2, rect.y1 - caption_h)
    if os.path.exists(img_path):
        page.insert_image(img_rect, filename=img_path, keep_proportion=True)
    else:
        page.draw_rect(img_rect, fill=(0.95, 0.95, 0.95))
        page.insert_text(pymupdf.Point(img_rect.x0 + 20, img_rect.y0 + 40), f"[IMAGE: {os.path.basename(img_path)}]", fontsize=9, color=(0.8, 0.2, 0.2))
    
    # Caption box
    cap_rect = pymupdf.Rect(rect.x0, rect.y1 - caption_h, rect.x1, rect.y1)
    page.draw_rect(cap_rect, fill=C_CREAM, color=C_BORDER, width=0.5)
    
    # Textbox wrapping
    tb_rect = pymupdf.Rect(rect.x0 + 5, rect.y1 - caption_h + 2, rect.x1 - 5, rect.y1 - 2)
    page.insert_textbox(tb_rect, caption, fontsize=7.2, fontname="helv", color=C_DARK, align=pymupdf.TEXT_ALIGN_LEFT)

print("Updated PDF Helper module loaded.")
