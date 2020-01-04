<?php

declare(strict_types=1);

namespace Tkotosz\EsTest\Model;

final class Product
{
    private ProductId $productId;

    private ProductName $productName;

    public static function fromIdAndName(ProductId $productId, ProductName $productName): Product
    {
        return new self($productId, $productName);
    }

    /**
     * @return array<string,mixed>
     */
    public function toArray(): array
    {
        return [
            'id' => $this->productId->toString(),
            'name' => $this->productName->toString()
        ];
    }

    private function __construct(ProductId $productId, ProductName $productName)
    {
        $this->productId = $productId;
        $this->productName = $productName;
    }
}
