require 'test_helper'

class TcpdfTest < ActiveSupport::TestCase

  test "write Basic test" do
    pdf = TCPDF.new

    line = pdf.write(0, "LINE 1")
    assert_equal line,  1

    line = pdf.write(0, "LINE 1\n")
    assert_equal line,  1

    line = pdf.write(0, "LINE 1\n2\n")
    assert_equal line,  2

    line = pdf.write(0, "")
    assert_equal line,  1

    line = pdf.write(0, "\n")
    assert_equal line,  1

    line = pdf.write(0, "abcdefghijklmnopgrstuvwxyz01234567890")
    assert_equal line,  1
    line = pdf.write(0, "abcdefghijklmnopgrstuvwxyz01234567890 abcdefghijklmnopgrstuvwxyz01234567890 abcdefghijklmnopgrstuvwxyz01234567890")
    assert_equal line,  2
    line = pdf.write(0, "abcdefghijklmnopgrstuvwxyz01234567890 abcdefghijklmnopgrstuvwxyz01234567890 abcdefghijklmnopgrstuvwxyz01234567890 abcdefghijklmnopgrstuvwxyz01234567890 abcdefghijklmnopgrstuvwxyz01234567890")
    assert_equal line,  3
  end

  test "write Break test single line 1" do
    pdf = TCPDF.new
    pdf.add_page()

    cell_hight = pdf.get_cell_height_ratio()
    fontsize = pdf.get_font_size()
    break_hight = pdf.set_auto_page_break(true)

    pno = pdf.get_page
    assert_equal pno, 1

    0.upto(60) do |i|
      y = pdf.get_y()
      old_pno = pno

      line = pdf.write(0, "LINE 1\n")
      assert_equal line,  1

      pno = pdf.get_page

      if y + fontsize * cell_hight < break_hight
        assert_equal pno, old_pno
      else
        assert_equal pno, old_pno + 1
      end
    end
  end

  test "write Break test single line 2" do
    pdf = TCPDF.new
    pdf.add_page()

    0.upto(49) do |i|
      line = pdf.write(0, "LINE 1\n")
      assert_equal line,  1

      pno = pdf.get_page
      assert_equal pno, 1
    end

    line = pdf.write(0, "abcdefghijklmnopgrstuvwxyz01234567890 abcdefghijklmnopgrstuvwxyz01234567890 abcdefghijklmnopgrstuvwxyz01234567890")
    assert_equal line,  2
    pno = pdf.get_page
    assert_equal pno, 2
  end

  test "write Break test multi line 1" do
    pdf = TCPDF.new
    pdf.add_page()
    pno = pdf.get_page
    assert_equal pno, 1

    line = pdf.write(0, "1\n\n\n\n\n\n\n\n\n\n 2\n\n\n\n\n\n\n\n\n\n 3\n\n\n\n\n\n\n\n\n\n 4\n\n\n\n\n\n\n\n\n\n")
    assert_equal line, 40 
    pno = pdf.get_page
    assert_equal pno, 1

    line = pdf.write(0, "1\n\n\n\n\n\n\n\n\n\n 2\n\n\n\n\n\n\n\n\n\n 3\n\n\n\n\n\n\n\n\n\n 4\n\n\n\n\n\n\n\n\n\n")
    assert_equal line, 40 
    pno = pdf.get_page
    assert_equal pno, 2
  end

  test "write Break test multi line 2" do
    pdf = TCPDF.new
    pdf.add_page()
    pno = pdf.get_page
    assert_equal pno, 1

    line = pdf.write(0, "1\n\n\n\n\n\n\n\n\n\n 2\n\n\n\n\n\n\n\n\n\n 3\n\n\n\n\n\n\n\n\n\n 4\n\n\n\n\n\n\n\n\n\n 5\n\n\n\n\n\n\n\n\n\n 6\n\n\n\n\n\n\n\n\n\n 7\n\n\n\n\n\n\n\n\n\n 8\n\n\n\n\n\n\n\n\n\n 9\n\n\n\n\n\n\n\n\n\n 10\n\n\n\n\n\n\n\n\n\n 11\n\n\n\n\n\n\n\n\n\n")
    assert_equal line, 110 
    pno = pdf.get_page
    assert_equal pno, 3
  end

  test "write firstline test" do
    pdf = TCPDF.new
    pdf.add_page()
    pno = pdf.get_page
    assert_equal pno, 1

    line = pdf.write(0, "\n", nil, 0, '', false, 0, true)
    assert_equal line,  "\n"

    line = pdf.write(0, "\n", nil, 0, '', false, 0, true)
    assert_equal line,  "\n"

    line = pdf.write(0, "12345\n", nil, 0, '', false, 0, true)
    assert_equal line,  "\n"

    line = pdf.write(0, "12345\nabcde", nil, 0, '', false, 0, true)
    assert_equal line,  "\nabcde"

    line = pdf.write(0, "12345\nabcde\n", nil, 0, '', false, 0, true)
    assert_equal line,  "\nabcde\n"

    line = pdf.write(0, "12345\nabcde\nefgh", nil, 0, '', false, 0, true)
    assert_equal line,  "\nabcde\nefgh"
   end
end
