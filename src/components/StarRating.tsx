'use client';

import { Star } from 'lucide-react';

interface StarRatingProps {
  rating: number;
  size?: number;
}

export const StarRating = ({
  rating: rawRating,
  size = 20,
}: StarRatingProps) => {
  const rating = typeof rawRating === 'number' ? rawRating : 0;

  const fullStars = Math.floor(rating);
  const hasHalfStar = rating % 1 !== 0;
  const emptyStars = 5 - fullStars - (hasHalfStar ? 1 : 0);
  const halfStarPercentage = (rating % 1) * 100;

  return (
    <div className="flex items-center gap-1 text-yellow-400">
      {/* Full Stars */}
      {Array.from({ length: fullStars }).map((_, i) => (
        <Star
          key={`full-${i}`}
          fill="currentColor"
          style={{ width: size, height: size }}
        />
      ))}

      {/* Half Star */}
      {hasHalfStar && (
        <div className="relative">
          <Star
            fill="currentColor"
            style={{
              width: size,
              height: size,
              clipPath: `inset(0 ${100 - halfStarPercentage}% 0 0)`,
            }}
          />
          <Star
            className="absolute top-0 left-0 text-gray-300 dark:text-gray-600"
            style={{ width: size, height: size, zIndex: -1 }}
          />
        </div>
      )}

      {/* Empty Stars */}
      {Array.from({ length: emptyStars }).map((_, i) => (
        <Star
          key={`empty-${i}`}
          className="text-gray-300 dark:text-gray-600"
          style={{ width: size, height: size }}
        />
      ))}
    </div>
  );
};
