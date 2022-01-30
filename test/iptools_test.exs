defmodule IptoolsTest do
  use ExUnit.Case
  doctest Iptools

  test "converts an IPv4 dotted-decimal to a list of integers" do
    assert Iptools.to_list("10.0.0.1") == [10, 0, 0, 1]
  end

  test "identifies an IPv4 dotted-decimal ip address" do
    assert Iptools.is_ipv4?("8.8.8.8") == true
    assert Iptools.is_ipv4?("-8.8.8.8") == false
    assert Iptools.is_ipv4?("8.8.8") == false
    assert Iptools.is_ipv4?("8.8.8.8.8") == false
    assert Iptools.is_ipv4?("8.8.8.8.") == false
    assert Iptools.is_ipv4?("1234.8.8.8") == false
    assert Iptools.is_ipv4?("256.8.8.8") == false
    assert Iptools.is_ipv4?("8.256.8.8") == false
    assert Iptools.is_ipv4?("8.8.256.8") == false
    assert Iptools.is_ipv4?("8.8.8.256") == false
    assert Iptools.is_ipv4?("kevin.com") == false
  end
  test "identifies RFC1918 ip addresses" do
    assert Iptools.is_rfc1918?("10.10.10.10") == true
    assert Iptools.is_rfc1918?("172.16.10.10") == true
    assert Iptools.is_rfc1918?("192.168.1.1") == true
    assert Iptools.is_rfc1918?("172.15.10.10") == false
    assert Iptools.is_rfc1918?("172.16.0.1") == true
    assert Iptools.is_rfc1918?("172.32.0.1") == false
    assert Iptools.is_rfc1918?("192.30.252.130") == false
  end

  test "identifies reserved ip addresses" do
    assert Iptools.is_reserved?("0.10.10.10") == true
    assert Iptools.is_reserved?("1.1.1.1") == false
    assert Iptools.is_reserved?("100.64.10.10") == true
    assert Iptools.is_reserved?("169.254.10.10") == true
    assert Iptools.is_reserved?("169.253.10.10") == false
    assert Iptools.is_reserved?("127.0.0.1") == true
    assert Iptools.is_reserved?("10.10.10.10") == true
    assert Iptools.is_reserved?("172.16.10.10") == true
    assert Iptools.is_reserved?("192.0.0.1") == true
    assert Iptools.is_reserved?("192.0.2.1") == true
    assert Iptools.is_reserved?("192.88.99.1") == true
    assert Iptools.is_reserved?("192.89.99.1") == false
    assert Iptools.is_reserved?("192.168.1.1") == true
    assert Iptools.is_reserved?("198.18.99.1") == true
    assert Iptools.is_reserved?("198.51.100.1") == true
    assert Iptools.is_reserved?("198.51.101.1") == false
    assert Iptools.is_reserved?("172.15.10.10") == false
    assert Iptools.is_reserved?("172.16.0.1") == true
    assert Iptools.is_reserved?("172.32.0.1") == false
    assert Iptools.is_reserved?("192.30.252.130") == false
    assert Iptools.is_reserved?("203.0.113.1") == true
    assert Iptools.is_reserved?("203.0.114.1") == false
    assert Iptools.is_reserved?("224.0.0.1") == true
    assert Iptools.is_reserved?("255.255.255.255") == true
  end

  test "converts dotted decimal ips to integers" do
    assert Iptools.to_integer("0.0.0.0") == 0
    assert Iptools.to_integer("0.10.0.0") == 655360
    assert Iptools.to_integer("0.0.10.0") == 2560
    assert Iptools.to_integer("0.0.0.10") == 10
    assert Iptools.to_integer("10.0.0.0") == 167772160
    assert Iptools.to_integer("204.14.239.82") == 3423530834
    assert Iptools.to_integer("255.255.255.255") == 4294967295
  end

  test "identifies if an ip address is between two others (inclusive)" do
    assert Iptools.is_between?("10.0.0.0", "10.0.0.0", "10.255.255.255") == true
    assert Iptools.is_between?("10.0.0.0", "10.0.0.1", "10.255.255.255") == false
    assert Iptools.is_between?("10.255.255.255", "10.0.0.1", "10.255.255.255") == true
    assert Iptools.is_between?("10.255.255.255", "10.0.0.1", "10.255.255.254") == false
  end

  test "converts subnet mask to string of ones and zeros" do
    assert Iptools.subnet_bit_string("255.0.0.0") == "11111111000000000000000000000000"
    assert Iptools.subnet_bit_string("255.255.0.0") == "11111111111111110000000000000000"
    assert Iptools.subnet_bit_string("255.255.255.0") == "11111111111111111111111100000000"
    assert Iptools.subnet_bit_string("255.255.255.255") == "11111111111111111111111111111111"
  end

  test "properly counts the number of bits in a subnet mask" do
    assert Iptools.subnet_bit_count("255.0.0.0") == 8
    assert Iptools.subnet_bit_count("255.255.0.0") == 16
    assert Iptools.subnet_bit_count("255.255.128.0") == 17
    assert Iptools.subnet_bit_count("255.255.255.0") == 24
    assert Iptools.subnet_bit_count("255.255.255.255") == 32
  end

  # https://www.ibm.com/docs/en/i/7.4?topic=concepts-ipv6-address-formats
  describe "identifies an IPv6 ip address" do
    test "identifies an IPv6 ip address" do
      assert Iptools.is_ipv6?("0000:0000:0000:0000:0000:0000:0000:0000") == true
      assert Iptools.is_ipv6?("ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff") == true
      assert Iptools.is_ipv6?("1050:0000:0000:0000:0005:0600:300c:326b") == true
      assert Iptools.is_ipv6?("1050:0000:87a2:2efa:4567:9321:300c:326b") == true

      assert Iptools.is_ipv6?("ffgf:ffff:ffff:ffff:ffff:ffff:ffff:ffff") == false
      assert Iptools.is_ipv6?("ffgf:ffff:ffff:ffff:ffff:ffff:ffff:ffff") == false
      assert Iptools.is_ipv6?("") == false
      assert Iptools.is_ipv6?("example.com") == false
    end

    test "properly handles omitting leading zeroes" do
      assert Iptools.is_ipv6?("1050:0:0:000:5:600:300c:326b") == true
      assert Iptools.is_ipv6?("1050:0000:0000:0000:0005:0600:300c:326b") == true
    end

    test "properly handles double colon notation" do
      assert Iptools.is_ipv6?("ff06::c3") == true
    end

    test "properly handles embedded IPv6 decimal notation" do
      # an IPv4 address is an IPv6 address
      assert Iptools.is_ipv6?("8.8.8.8") == true
      assert Iptools.is_ipv6?("ffff:ffff:ffff:ffff:8.8.8.8") == true
      assert Iptools.is_ipv6?("0:0:0:0:0:ffff:192.1.56.10") == true
      assert Iptools.is_ipv6?("0:0:0:0:0:ffff:192.1.56.10") == true
      assert Iptools.is_ipv6?("::ffff:192.1.56.10") == true
    end
  end
end
