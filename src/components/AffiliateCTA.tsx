import {
  Card,
  CardHeader,
  CardTitle,
  CardDescription,
  CardContent,
  CardFooter,
} from '@/components/ui/card';
import { Button } from '@/components/ui/button';

export const AffiliateCTA = () => {
  return (
    <Card className="mt-12 bg-primary-foreground border-primary">
      <CardHeader>
        <CardTitle>Ready to Boost Your Privacy?</CardTitle>
        <CardDescription>
          Get the best VPN service recommended by our experts. Secure your
          connection and browse freely.
        </CardDescription>
      </CardHeader>
      <CardContent>
        <p>
          We've partnered with a top-tier VPN provider to offer you an exclusive
          deal. Click the link below to get started with one of the most trusted
          names in online security.
        </p>
      </CardContent>
      <CardFooter>
        {/* IMPORTANT: Replace this with your actual affiliate link */}
        <Button asChild className="w-full bg-primary hover:bg-primary/90">
          <a href="#" target="_blank" rel="noopener noreferrer nofollow">
            Get Exclusive VPN Deal
          </a>
        </Button>
      </CardFooter>
    </Card>
  );
};
