<?php

declare(strict_types=1);

namespace Tkotosz\EsTest\Model;

final class ProductId
{
    private string $value;

    public static function fromString(string $value): ProductId
    {
        return new self($value);
    }

    public function toString(): string
    {
        return $this->value;
    }

    private function __construct(string $value)
    {
        $this->value = $value;
    }
}
