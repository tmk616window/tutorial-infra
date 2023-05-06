# NOTE: https://inokara.hateblo.jp/entry/2019/03/21/001507
resource "random_id" "length_4" {
  byte_length = 4
}

resource "random_id" "length_8" {
  byte_length = 8
}

resource "random_id" "length_16" {
  byte_length = 16
}
