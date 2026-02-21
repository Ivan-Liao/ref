#!/usr/bin/env python3
from typing import Any, Optional
from collections import deque

class LRUCache:
    """
    A Least Recently Used (LRU) cache keeps items in the cache until it reaches its size
    and/or item limit (only item in our case). In which case, it removes an item that was accessed
    least recently.
    An item is considered accessed whenever `has`, `get`, or `set` is called with its key.

    Implement the LRU cache here and use the unit tests to check your implementation.
    """

    def __init__(self, item_limit: int):
        self.item_limit = item_limit
        self.cache = {}
        self.lru_list = []


    def has(self, key: str) -> bool:
        if key in self.cache:
            # del element from its current position to move to the back of the list
            if len(self.lru_list) == self.item_limit and key in self.lru_list:
                self.lru_list.remove(key)
            # add to queue from right due to access event
            self.lru_list.append(key)
            return True
        else:
            return False
        

    def get(self, key: str) -> Optional[Any]:
        # if key exists, return / get it
        if self.has(key):
            return self.cache[key]
        else:
            return None
    

    def set(self, key: str, value: Any):
        # pop from left of queue if size_limit is reached
        if len(self.lru_list) == self.item_limit:
            key_to_delete = self.lru_list.pop(0)
            del self.cache[key_to_delete]
        # set key or overwrite
        self.cache[key] = value
        self.lru_list.append(key)