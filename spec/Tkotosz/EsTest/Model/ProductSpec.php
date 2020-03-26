<?php

namespace spec\Tkotosz\EsTest\Model;

use PhpSpec\ObjectBehavior;
use Tkotosz\EsTest\Model\Product;

class ProductSpec extends ObjectBehavior
{
    function it_is_initializable()
    {
        $this->shouldHaveType(Product::class);
    }
}
