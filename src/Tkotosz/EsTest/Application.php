<?php

declare(strict_types=1);

namespace Tkotosz\EsTest;

use Tkotosz\EsTest\Model\Product;
use Tkotosz\EsTest\Model\ProductId;
use Tkotosz\EsTest\Model\ProductName;

class Application
{
    public function run(): void
    {
        $product = Product::fromIdAndName(
            ProductId::fromString('foo'),
            ProductName::fromString('Foo Product')
        );

        echo json_encode($product->toArray(), JSON_PRETTY_PRINT);
    }
}